#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rand.h"
#include "bch.h"
#include "ecc.h"
#include "bin-lwe.h"
#include "compat.h"

#if LAC_CFG_CT_NEON_AVAILABLE
#include <arm_neon.h>
#endif

#if defined(__GNUC__) || defined(__clang__)
#define LAC_ENC_UNUSED_FN __attribute__((unused))
#else
#define LAC_ENC_UNUSED_FN
#endif

#define RATIO 125

#ifdef LAC256
#define PKE_C2_COMPRESSED_UNIT 8ULL
#define PKE_C2_LEN_DIVISOR 16ULL
#else
#define PKE_C2_COMPRESSED_UNIT 4ULL
#define PKE_C2_LEN_DIVISOR 8ULL
#endif

static int pke_dec_decode_lengths(unsigned long long clen,
				  int *c2_len,
				  unsigned long long *mlen)
{
	const unsigned long long min_c2_bytes =
		(unsigned long long)ECC_LEN * PKE_C2_COMPRESSED_UNIT;
	const unsigned long long max_c2_bytes =
		(unsigned long long)(MESSAGE_LEN + ECC_LEN) *
		PKE_C2_COMPRESSED_UNIT;
	unsigned long long c2_bytes;

	if (clen < (unsigned long long)DIM_N + min_c2_bytes ||
	    clen > (unsigned long long)DIM_N + max_c2_bytes)
	{
		return -1;
	}

	c2_bytes = clen - (unsigned long long)DIM_N;
	if ((c2_bytes % PKE_C2_COMPRESSED_UNIT) != 0ULL)
	{
		return -1;
	}

	*c2_len = (int)(c2_bytes * 2ULL);
	*mlen = (c2_bytes * 2ULL) / PKE_C2_LEN_DIVISOR -
		(unsigned long long)ECC_LEN;

	return 0;
}

static int pke_recover16_aligned_mlen(unsigned long long mlen)
{
	return ((((mlen + (unsigned long long)ECC_LEN) * 8ULL) & 15ULL) == 0ULL);
}

static inline uint32_t enc_ct_mask_lt_u32(uint32_t a, uint32_t b)
{
	uint64_t diff = (uint64_t)a - (uint64_t)b;
	return 0u - (uint32_t)(diff >> 63);
}

static inline uint32_t LAC_ENC_UNUSED_FN enc_ct_mask_ge_u32(uint32_t a,
							    uint32_t b)
{
	return ~enc_ct_mask_lt_u32(a, b);
}

static inline int enc_sub_mod_q_u8(unsigned char x, unsigned char y)
{
#if LAC_CFG_CT_PKE_SUBMODQ
	int32_t d = (int32_t)x - (int32_t)y;
	d += (d >> 31) & Q;
	return (int)d;
#else
	return ((int)x - (int)y + Q) % Q;
#endif
}

#ifdef LAC256
static inline uint32_t enc_ct_select_u32(uint32_t mask, uint32_t x, uint32_t y)
{
	return (mask & x) | (~mask & y);
}
#endif

#if LAC_CFG_CT_NEON_AVAILABLE
static const uint8_t enc_neon_bit_shift_bytes[16] = {
	0, 1, 2, 3, 4, 5, 6, 7,
	0, 1, 2, 3, 4, 5, 6, 7
};

static inline uint8x16_t enc_neon_code_bits16(const unsigned char *p_code)
{
	uint8x8_t lo = vdup_n_u8(p_code[0]);
	uint8x8_t hi = vdup_n_u8(p_code[1]);
	uint8x16_t bytes = vcombine_u8(lo, hi);
	uint8x16_t shifts = vld1q_u8(enc_neon_bit_shift_bytes);
	uint8x16_t shifted = vshlq_u8(bytes, vnegq_s8(vreinterpretq_s8_u8(shifts)));

	return vandq_u8(shifted, vdupq_n_u8(1u));
}

static inline uint8x16_t enc_neon_code_bits16_tail(const unsigned char *p_code,
						   unsigned int n)
{
	uint8x8_t lo = vdup_n_u8(p_code[0]);
	uint8x8_t hi = vdup_n_u8((n > 8u) ? p_code[1] : 0u);
	uint8x16_t bytes = vcombine_u8(lo, hi);
	uint8x16_t shifts = vld1q_u8(enc_neon_bit_shift_bytes);
	uint8x16_t shifted = vshlq_u8(bytes, vnegq_s8(vreinterpretq_s8_u8(shifts)));

	return vandq_u8(shifted, vdupq_n_u8(1u));
}

static inline int8x16_t enc_load_s8q_tail(const lac_small_t *in,
					  unsigned int n)
{
	int8x16_t v = vdupq_n_s8(0);

	if (n >= 8u) {
		v = vcombine_s8(vld1_s8((const int8_t *)in), vdup_n_s8(0));
		in += 8u;
		n -= 8u;
	}
	if (n != 0u) {
		int8x8_t hi = vdup_n_s8(0);

		switch (n) {
		case 7: hi = vld1_lane_s8((const int8_t *)in + 6u, hi, 6);
		case 6: hi = vld1_lane_s8((const int8_t *)in + 5u, hi, 5);
		case 5: hi = vld1_lane_s8((const int8_t *)in + 4u, hi, 4);
		case 4: hi = vld1_lane_s8((const int8_t *)in + 3u, hi, 3);
		case 3: hi = vld1_lane_s8((const int8_t *)in + 2u, hi, 2);
		case 2: hi = vld1_lane_s8((const int8_t *)in + 1u, hi, 1);
		case 1: hi = vld1_lane_s8((const int8_t *)in, hi, 0);
		default: break;
		}
		v = vcombine_s8(vget_low_s8(v), hi);
	}

	return v;
}

static inline void enc_store_s8q_tail(lac_small_t *out, int8x16_t v,
				      unsigned int n)
{
	if (n >= 8u) {
		vst1_s8((int8_t *)out, vget_low_s8(v));
		out += 8u;
		n -= 8u;
		v = vcombine_s8(vget_high_s8(v), vdup_n_s8(0));
	}
	if (n != 0u) {
		int8x8_t lo = vget_low_s8(v);

		switch (n) {
		case 7: vst1_lane_s8((int8_t *)out + 6u, lo, 6);
		case 6: vst1_lane_s8((int8_t *)out + 5u, lo, 5);
		case 5: vst1_lane_s8((int8_t *)out + 4u, lo, 4);
		case 4: vst1_lane_s8((int8_t *)out + 3u, lo, 3);
		case 3: vst1_lane_s8((int8_t *)out + 2u, lo, 2);
		case 2: vst1_lane_s8((int8_t *)out + 1u, lo, 1);
		case 1: vst1_lane_s8((int8_t *)out, lo, 0);
		default: break;
		}
	}
}

static inline uint8_t enc_neon_pack8_u16(uint16x8_t mask)
{
	const uint8x8_t weights = {1u, 2u, 4u, 8u, 16u, 32u, 64u, 128u};
	uint8x8_t bits = vmovn_u16(vshrq_n_u16(mask, 15));
	uint8x8_t weighted = vmul_u8(bits, weights);
	uint16x4_t sum16 = vpaddl_u8(weighted);
	uint32x2_t sum32 = vpaddl_u16(sum16);
	uint64x1_t sum64 = vpaddl_u32(sum32);

	return (uint8_t)vget_lane_u64(sum64, 0);
}

static inline int16x8_t enc_neon_sub_mod_q8(uint8x8_t x, uint8x8_t y)
{
	int16x8_t d = vreinterpretq_s16_u16(vsubl_u8(x, y));
	uint16x8_t neg = vcltq_s16(d, vdupq_n_s16(0));

	return vaddq_s16(d, vreinterpretq_s16_u16(vandq_u16(neg, vdupq_n_u16((uint16_t)Q))));
}

static inline uint8_t LAC_ENC_UNUSED_FN enc_neon_recover_pack8(uint8x8_t c2,
							       uint8x8_t out,
							       int16x8_t low,
							       int16x8_t high)
{
	int16x8_t temp = enc_neon_sub_mod_q8(c2, out);
	uint16x8_t ge_low = vcgeq_s16(temp, low);
	uint16x8_t lt_high = vcltq_s16(temp, high);

	return enc_neon_pack8_u16(vandq_u16(ge_low, lt_high));
}

#ifdef LAC256
static inline uint8_t enc_neon_recover_d2_pack8(uint8x8_t c2_lo,
						uint8x8_t out_lo,
						uint8x8_t c2_hi,
						uint8x8_t out_hi,
						int16x8_t q,
						int16x8_t center,
						int16x8_t d2_bound)
{
	int16x8_t temp1 = enc_neon_sub_mod_q8(c2_lo, out_lo);
	int16x8_t temp2 = enc_neon_sub_mod_q8(c2_hi, out_hi);
	uint16x8_t mask1 = vcltq_s16(temp1, center);
	uint16x8_t mask2 = vcltq_s16(temp2, center);
	int16x8_t flip1 = vsubq_s16(q, temp1);
	int16x8_t flip2 = vsubq_s16(q, temp2);
	int16x8_t merged;

	temp1 = vbslq_s16(mask1, flip1, temp1);
	temp2 = vbslq_s16(mask2, flip2, temp2);
	merged = vsubq_s16(vaddq_s16(temp1, temp2), q);

	return enc_neon_pack8_u16(vcltq_s16(merged, d2_bound));
}
#endif
#endif

#ifndef LAC256
static void LAC_ENC_UNUSED_FN pke_recover_msg_std(const unsigned char *c2,
						  const unsigned char *out,
						  unsigned char *p_code,
						  int c2_len)
{
	int i;
	const int low=Q/4;
	const int high=Q*3/4;

	for(i=0;i<c2_len;i++)
	{
		int temp=enc_sub_mod_q_u8(c2[i], out[i]);

		//recover m from m*q/2+e, RATIO=q/2
		if(temp>=low && temp<high)
		{
			p_code[i/8]=p_code[i/8]^(1<<(i%8));
		}
	}
}

static void LAC_ENC_UNUSED_FN pke_recover_msg_ct_scalar(const unsigned char *c2,
							const unsigned char *out,
							unsigned char *p_code,
							int c2_len)
{
	int i, j;
	const int low = Q/4;
	const int high = Q*3/4;

	for(i=0;i<c2_len;i+=16)
	{
		unsigned char packed_low = 0;
		unsigned char packed_high = 0;

		for(j=0;j<8;j++)
		{
			int temp=enc_sub_mod_q_u8(c2[i+j], out[i+j]);
			uint32_t bit_mask =
				enc_ct_mask_ge_u32((uint32_t)temp, (uint32_t)low) &
				enc_ct_mask_lt_u32((uint32_t)temp, (uint32_t)high) &
				(1u << j);

			packed_low ^= (unsigned char)bit_mask;
		}
		for(j=0;j<8;j++)
		{
			int pos = i + 8 + j;
			int temp=enc_sub_mod_q_u8(c2[pos], out[pos]);
			uint32_t bit_mask =
				enc_ct_mask_ge_u32((uint32_t)temp, (uint32_t)low) &
				enc_ct_mask_lt_u32((uint32_t)temp, (uint32_t)high) &
				(1u << j);

			packed_high ^= (unsigned char)bit_mask;
		}

		p_code[i >> 3] ^= packed_low;
		p_code[(i >> 3) + 1] ^= packed_high;
	}
}

#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
static void pke_recover_msg_ct_neon(const unsigned char *c2,
				    const unsigned char *out,
				    unsigned char *p_code,
				    int c2_len)
{
	int i;
	const int16x8_t low = vdupq_n_s16((int16_t)(Q/4));
	const int16x8_t high = vdupq_n_s16((int16_t)(Q*3/4));

	for (i = 0; i < c2_len; i += 16)
	{
		uint8x16_t c2v = vld1q_u8(c2 + i);
		uint8x16_t outv = vld1q_u8(out + i);
		uint8_t packed_low;
		uint8_t packed_high;

		packed_low = enc_neon_recover_pack8(vget_low_u8(c2v),
						    vget_low_u8(outv),
						    low, high);
		packed_high = enc_neon_recover_pack8(vget_high_u8(c2v),
						     vget_high_u8(outv),
						     low, high);

		p_code[i >> 3] ^= packed_low;
		p_code[(i >> 3) + 1] ^= packed_high;
	}
}
#endif

static void pke_recover_msg(const unsigned char *c2,
			    const unsigned char *out,
			    unsigned char *p_code,
			    int c2_len)
{
#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
	pke_recover_msg_ct_neon(c2, out, p_code, c2_len);
#elif LAC_CFG_CT_PKE_THRESHOLD_DEC
	pke_recover_msg_ct_scalar(c2, out, p_code, c2_len);
#else
	pke_recover_msg_std(c2, out, p_code, c2_len);
#endif
}
#else
static void LAC_ENC_UNUSED_FN pke_recover_msg_d2_std(const unsigned char *c2,
						     const unsigned char *out,
						     unsigned char *p_code,
						     int vec_bound)
{
	int i;
	int temp1,temp2;
	int center_point=Q/2;
	int d2_bound=Q/2;

	for(i=0;i<vec_bound;i++)
	{
		//D2 decoding:compute m*q/2+e1 + m*q/2+e2 in [0,2*Q]
		temp1=enc_sub_mod_q_u8(c2[i], out[i]);
		temp2=enc_sub_mod_q_u8(c2[i+vec_bound], out[i+vec_bound]);

		//shift
		if(temp1<center_point)
		{
			temp1=center_point-temp1+center_point;//mirror around Q/2
		}
		if(temp2<center_point)
		{
			temp2=center_point-temp2+center_point;//mirror around Q/2
		}
		//merge erors
		temp1+=temp2-Q;

		//recover m from m*q/2+e1 + m*q/2+e2, RATIO=q/2
		if(temp1<d2_bound)
		{
			p_code[i/8]=p_code[i/8]^(1<<(i%8));
		}
	}
}

static void LAC_ENC_UNUSED_FN pke_recover_msg_d2_ct_scalar(const unsigned char *c2,
							   const unsigned char *out,
							   unsigned char *p_code,
							   int vec_bound)
{
	int i, j;
	const int center_point=Q/2;
	const int d2_bound=Q/2;

	for(i=0;i<vec_bound;i+=16)
	{
		unsigned char packed_low = 0;
		unsigned char packed_high = 0;

		for(j=0;j<8;j++)
		{
			int pos = i + j;
			int temp1=enc_sub_mod_q_u8(c2[pos], out[pos]);
			int temp2=enc_sub_mod_q_u8(c2[pos+vec_bound], out[pos+vec_bound]);
			uint32_t mask1 = enc_ct_mask_lt_u32((uint32_t)temp1,
							    (uint32_t)center_point);
			uint32_t mask2 = enc_ct_mask_lt_u32((uint32_t)temp2,
							    (uint32_t)center_point);
			uint32_t bit_mask =
				0;

			temp1 = (int)enc_ct_select_u32(mask1, (uint32_t)(Q-temp1),
						       (uint32_t)temp1);
			temp2 = (int)enc_ct_select_u32(mask2, (uint32_t)(Q-temp2),
						       (uint32_t)temp2);
			temp1+=temp2-Q;
			bit_mask =
				enc_ct_mask_lt_u32((uint32_t)temp1,
						   (uint32_t)d2_bound) &
				(1u << j);

			packed_low ^= (unsigned char)bit_mask;
		}
		for(j=0;j<8;j++)
		{
			int pos = i + 8 + j;
			int temp1=enc_sub_mod_q_u8(c2[pos], out[pos]);
			int temp2=enc_sub_mod_q_u8(c2[pos+vec_bound], out[pos+vec_bound]);
			uint32_t mask1 = enc_ct_mask_lt_u32((uint32_t)temp1,
							    (uint32_t)center_point);
			uint32_t mask2 = enc_ct_mask_lt_u32((uint32_t)temp2,
							    (uint32_t)center_point);
			uint32_t bit_mask =
				0;

			temp1 = (int)enc_ct_select_u32(mask1, (uint32_t)(Q-temp1),
						       (uint32_t)temp1);
			temp2 = (int)enc_ct_select_u32(mask2, (uint32_t)(Q-temp2),
						       (uint32_t)temp2);
			temp1+=temp2-Q;
			bit_mask =
				enc_ct_mask_lt_u32((uint32_t)temp1,
						   (uint32_t)d2_bound) &
				(1u << j);

			packed_high ^= (unsigned char)bit_mask;
		}

		p_code[i >> 3] ^= packed_low;
		p_code[(i >> 3) + 1] ^= packed_high;
	}
}

#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
static void pke_recover_msg_d2_ct_neon(const unsigned char *c2,
				       const unsigned char *out,
				       unsigned char *p_code,
				       int vec_bound)
{
	int i;
	const int16x8_t q = vdupq_n_s16((int16_t)Q);
	const int16x8_t center = vdupq_n_s16((int16_t)(Q/2));
	const int16x8_t d2_bound = vdupq_n_s16((int16_t)(Q/2));

	for (i = 0; i < vec_bound; i += 16)
	{
		uint8x16_t c2_first = vld1q_u8(c2 + i);
		uint8x16_t out_first = vld1q_u8(out + i);
		uint8x16_t c2_second = vld1q_u8(c2 + vec_bound + i);
		uint8x16_t out_second = vld1q_u8(out + vec_bound + i);
		uint8_t packed_low;
		uint8_t packed_high;

		packed_low = enc_neon_recover_d2_pack8(vget_low_u8(c2_first),
						       vget_low_u8(out_first),
						       vget_low_u8(c2_second),
						       vget_low_u8(out_second),
						       q, center, d2_bound);
		packed_high = enc_neon_recover_d2_pack8(vget_high_u8(c2_first),
							vget_high_u8(out_first),
							vget_high_u8(c2_second),
							vget_high_u8(out_second),
							q, center, d2_bound);

		p_code[i >> 3] ^= packed_low;
		p_code[(i >> 3) + 1] ^= packed_high;
	}
}
#endif

static void pke_recover_msg_d2(const unsigned char *c2,
			       const unsigned char *out,
			       unsigned char *p_code,
			       int vec_bound)
{
#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
	pke_recover_msg_d2_ct_neon(c2, out, p_code, vec_bound);
#elif LAC_CFG_CT_PKE_THRESHOLD_DEC
	pke_recover_msg_d2_ct_scalar(c2, out, p_code, vec_bound);
#else
	pke_recover_msg_d2_std(c2, out, p_code, vec_bound);
#endif
}
#endif

static void LAC_ENC_UNUSED_FN pke_add_message_std(lac_small_t *e2,
						  const unsigned char *p_code,
						  int c2_len)
{
	int i;

	for(i=0;i<c2_len;i++)
		e2[i]=e2[i]+RATIO*((p_code[i/8]>>(i%8))&1);
}

static void LAC_ENC_UNUSED_FN pke_add_message_ct_scalar(lac_small_t *e2,
							const unsigned char *p_code,
							int c2_len)
{
	int i;

	for(i=0;i<c2_len;i++)
		e2[i]=e2[i]+RATIO*((p_code[i/8]>>(i%8))&1);
}

#if LAC_CFG_CT_NEON_PKE_MESSAGE_ADD
static void pke_add_message_ct_neon(lac_small_t *e2,
				    const unsigned char *p_code,
				    int c2_len)
{
	int i;
	const int vec_len = c2_len & ~15;
	const uint8x16_t ratio = vdupq_n_u8((uint8_t)RATIO);

	for (i = 0; i < vec_len; i += 16)
	{
		uint8x16_t bits = enc_neon_code_bits16(p_code + (i >> 3));
		int8x16_t msg = vreinterpretq_s8_u8(vmulq_u8(bits, ratio));
		int8x16_t vals = vld1q_s8((const int8_t *)(e2 + i));

		vst1q_s8((int8_t *)(e2 + i), vaddq_s8(vals, msg));
	}

	if (i < c2_len)
	{
		unsigned int rem = (unsigned int)(c2_len - i);
		uint8x16_t bits = enc_neon_code_bits16_tail(p_code + (i >> 3), rem);
		int8x16_t msg = vreinterpretq_s8_u8(vmulq_u8(bits, ratio));
		int8x16_t vals = enc_load_s8q_tail(e2 + i, rem);

		enc_store_s8q_tail(e2 + i, vaddq_s8(vals, msg), rem);
	}
}
#endif

static void LAC_ENC_UNUSED_FN pke_add_message(lac_small_t *e2,
					      const unsigned char *p_code,
					      int c2_len)
{
#if LAC_CFG_CT_NEON_PKE_MESSAGE_ADD
	pke_add_message_ct_neon(e2, p_code, c2_len);
#elif LAC_CFG_CT_PKE_MESSAGE_ADD
	pke_add_message_ct_scalar(e2, p_code, c2_len);
#else
	pke_add_message_std(e2, p_code, c2_len);
#endif
}

#ifdef LAC256
static void LAC_ENC_UNUSED_FN pke_add_message_d2_std(lac_small_t *e2,
						     const unsigned char *p_code,
						     int vec_bound)
{
	int i;

	for(i=0;i<vec_bound;i++)
	{
		int8_t message=RATIO*((p_code[i/8]>>(i%8))&1);
		e2[i]=e2[i]+message;
		e2[i+vec_bound]=e2[i+vec_bound]+message;
	}
}

static void LAC_ENC_UNUSED_FN pke_add_message_d2_ct_scalar(lac_small_t *e2,
							   const unsigned char *p_code,
							   int vec_bound)
{
	int i;

	for(i=0;i<vec_bound;i++)
	{
		int8_t message=RATIO*((p_code[i/8]>>(i%8))&1);
		e2[i]=e2[i]+message;
		e2[i+vec_bound]=e2[i+vec_bound]+message;
	}
}

#if LAC_CFG_CT_NEON_PKE_MESSAGE_ADD
static void pke_add_message_d2_ct_neon(lac_small_t *e2,
				       const unsigned char *p_code,
				       int vec_bound)
{
	int i;
	const int vec_len = vec_bound & ~15;
	const uint8x16_t ratio = vdupq_n_u8((uint8_t)RATIO);

	for (i = 0; i < vec_len; i += 16)
	{
		uint8x16_t bits = enc_neon_code_bits16(p_code + (i >> 3));
		int8x16_t msg = vreinterpretq_s8_u8(vmulq_u8(bits, ratio));
		int8x16_t lo = vld1q_s8((const int8_t *)(e2 + i));
		int8x16_t hi = vld1q_s8((const int8_t *)(e2 + vec_bound + i));

		vst1q_s8((int8_t *)(e2 + i), vaddq_s8(lo, msg));
		vst1q_s8((int8_t *)(e2 + vec_bound + i), vaddq_s8(hi, msg));
	}

	if (i < vec_bound)
	{
		unsigned int rem = (unsigned int)(vec_bound - i);
		uint8x16_t bits = enc_neon_code_bits16_tail(p_code + (i >> 3), rem);
		int8x16_t msg = vreinterpretq_s8_u8(vmulq_u8(bits, ratio));
		int8x16_t lo = enc_load_s8q_tail(e2 + i, rem);
		int8x16_t hi = enc_load_s8q_tail(e2 + vec_bound + i, rem);

		enc_store_s8q_tail(e2 + i, vaddq_s8(lo, msg), rem);
		enc_store_s8q_tail(e2 + vec_bound + i, vaddq_s8(hi, msg), rem);
	}
}
#endif

static void pke_add_message_d2(lac_small_t *e2,
			       const unsigned char *p_code,
			       int vec_bound)
{
#if LAC_CFG_CT_NEON_PKE_MESSAGE_ADD
	pke_add_message_d2_ct_neon(e2, p_code, vec_bound);
#elif LAC_CFG_CT_PKE_MESSAGE_ADD
	pke_add_message_d2_ct_scalar(e2, p_code, vec_bound);
#else
	pke_add_message_d2_std(e2, p_code, vec_bound);
#endif
}
#endif

//key generation
int crypto_encrypt_keypair( unsigned char *pk, unsigned char *sk)
{
	//check parameter
	if(pk==NULL || sk==NULL)
	{
		return -1;
	}
	kg(pk,sk);
	
	return 0;
}

//encryption
int crypto_encrypt( unsigned char *c, unsigned long long *clen, const unsigned char *m, unsigned long long mlen, const unsigned char *pk)
{
	//check parameter
	if(c==NULL || clen==NULL || m==NULL || pk==NULL)
	{
		return -1;
	}
	if(mlen>MESSAGE_LEN)
	{
		return -1;
	}
	
	//call pke encryption function
	return pke_enc(pk,m, mlen,c,clen);
}
//decryption
int crypto_encrypt_open(unsigned char *m, unsigned long long *mlen,const unsigned char *c, unsigned long long clen,const unsigned char *sk)
{
	//check parameter
	if(sk==NULL || m==NULL || c==NULL || mlen==NULL)
	{
		return -1;
	}

	//call pke decryption function
	return pke_dec(sk,c,clen,m,mlen);
}

//key generation with seed
int kg_seed(unsigned char *pk, unsigned char *sk, unsigned char *seed)
{
	unsigned char seeds[3*SEED_LEN];
	unsigned char a[DIM_N];
	lac_small_t e[DIM_N];
	//check pointer
	if(pk==NULL || sk==NULL || seed==NULL)
	{
		return -1;
	}
	//generate three seeds for a,sk,e
	pseudo_random_bytes(seeds,3*SEED_LEN,seed);	
	//copy the seed of a to pk
	memcpy(pk,seeds,SEED_LEN);
	//generate a
	gen_a(a,pk);
	//generate  sk,e
	gen_psi_fix_ham((lac_small_t*)sk,DIM_N,seeds+SEED_LEN);
	gen_psi_fix_ham((lac_small_t*)e,DIM_N,seeds+2*SEED_LEN);
	//compute pk=a*sk+e
	poly_aff(a,(lac_small_t *)sk,e,pk+SEED_LEN,DIM_N);
	//copy pk=as+e to the second part of sk, now sk=s|pk
	memcpy(sk+DIM_N,pk,PK_LEN);
	LAC_SECURE_CLEAR(seeds, sizeof(seeds));
	LAC_SECURE_CLEAR(a, sizeof(a));
	LAC_SECURE_CLEAR(e, sizeof(e));
	return 0;
}

//key generation
int kg(unsigned char *pk, unsigned char *sk)
{
	unsigned char seed[SEED_LEN];
	
	//generate seed
	random_bytes(seed,SEED_LEN);		
	//key generation with seed 
	kg_seed(pk,sk,seed);	
	LAC_SECURE_CLEAR(seed, sizeof(seed));
		
	return 0;
}
// encryption
int pke_enc(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen)
{
	unsigned char seed[SEED_LEN];

	if(pk==NULL || m==NULL || c==NULL || clen==NULL)
	{
		return -1;
	}
	if(mlen>MESSAGE_LEN)
	{
		return -1;
	}
	if(!pke_recover16_aligned_mlen(mlen))
	{
		return -1;
	}

	//generate seed
	random_bytes(seed,SEED_LEN);
	//encrypt with seed 
	if(pke_enc_seed(pk,m,mlen,c,clen,seed) != 0)
	{
		LAC_SECURE_CLEAR(seed, sizeof(seed));
		return -1;
	}
	LAC_SECURE_CLEAR(seed, sizeof(seed));

	return 0;
}
// decrypt
int pke_dec(const unsigned char *sk, const unsigned char *c,unsigned long long clen, unsigned char *m, unsigned long long *mlen)
{
	unsigned char out[DIM_N];
	unsigned char code[CODE_LEN],*p_code;
	unsigned char c2[C2_VEC_NUM];
	int c2_len;
	unsigned char m_buf[MESSAGE_LEN];
	unsigned long long decoded_mlen;

	//check parameter
	if(sk==NULL || m==NULL || c==NULL || mlen==NULL)
	{
		return -1;
	}
	if(pke_dec_decode_lengths(clen, &c2_len, &decoded_mlen) != 0)
	{
		return -1;
	}

	#ifdef LAC256 //D2 decoding

	int vec_bound=c2_len/2;
	if((vec_bound & 15) != 0)
	{
		return -1;
	}
	*mlen = decoded_mlen;
	//shif the pointer of ecc data
	p_code=code+(DATA_LEN-(*mlen));
	//init code
	memset(code,0,CODE_LEN);
	//c2 decompress
	poly_decompress(c+DIM_N,c2,c2_len);
	//c1*sk
	poly_mul(c,(lac_small_t *)sk,out,DIM_N);
	//compute c2-c1*sk and recover data from m*q/2+e
	pke_recover_msg_d2(c2, out, p_code, vec_bound);
		//bch decode to recover m
		ecc_dec(m_buf,code);
		//get plaintext
		memcpy(m,m_buf+(DATA_LEN-(*mlen)),*mlen);

	#else

	if((c2_len & 15) != 0)
	{
		return -1;
	}

	//c2 decompress
	poly_decompress(c+DIM_N,c2,c2_len);
	//c1*sk
	poly_mul(c,(lac_small_t*)sk,out,DIM_N);
	//init code
	memset(code,0,CODE_LEN);
	//shift the pointer of code
	*mlen = decoded_mlen;
	p_code=code+(DATA_LEN-(*mlen));

	pke_recover_msg(c2, out, p_code, c2_len);

		//bch decode to recover m
		ecc_dec(m_buf,code);
		//get plaintext
		memcpy(m,m_buf+(DATA_LEN-(*mlen)),*mlen);
		#endif
	LAC_SECURE_CLEAR(out, sizeof(out));
	LAC_SECURE_CLEAR(code, sizeof(code));
	LAC_SECURE_CLEAR(c2, sizeof(c2));
	LAC_SECURE_CLEAR(m_buf, sizeof(m_buf));
		
	return 0;
}

// encryption with seed
int pke_enc_seed(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen, unsigned char *seed)
{
	unsigned char code[CODE_LEN],seeds[3*SEED_LEN],*p_code;
	lac_small_t r[DIM_N];
	lac_small_t e1[DIM_N],e2[C2_VEC_NUM];
	unsigned char c2[C2_VEC_NUM];
	unsigned char a[DIM_N];
	unsigned char m_buf[MESSAGE_LEN];
	int c2_len;
	
	//check parameter
	if(pk==NULL || m==NULL || c==NULL || clen==NULL || seed==NULL)
	{
		return -1;
	}
	if(mlen>MESSAGE_LEN)
	{
		return -1;
	}
	if(!pke_recover16_aligned_mlen(mlen))
	{
		return -1;
	}

	//generate  a from seed in the first part of pk
	gen_a(a,pk);
	//package m_buf
	memset(m_buf,0,MESSAGE_LEN);
	//set data
	memcpy(m_buf+(DATA_LEN-mlen),m,mlen);
	//encode m with ecc code
	ecc_enc(m_buf,code);
	//set p_code
	p_code=code+(DATA_LEN-mlen);
	//generate three seeds for r,e1,e2
	pseudo_random_bytes(seeds,3*SEED_LEN,seed);
	//generate random vector r
	gen_psi_fix_ham(r,DIM_N,seeds);
	//generate error vector e1
	gen_psi_fix_ham(e1,DIM_N,seeds+SEED_LEN);
	//compute c1=a*r+e1
	poly_aff(a,r,e1,c,DIM_N);
	
	//D2 encoding
	#ifdef LAC256
	
	//compute the length of c2
	c2_len=(mlen+ECC_LEN)*8*2;
	//generate error vector e2
	gen_psi_std(e2,c2_len,seeds+2*SEED_LEN);
		
	int vec_bound=c2_len/2;
	//compute  code*q/2+e2,
	pke_add_message_d2(e2, p_code, vec_bound);

	#else
	
	//compute the length of c2
	c2_len=(mlen+ECC_LEN)*8;
	//generate error vector e2
	gen_psi_std(e2,c2_len,seeds+2*SEED_LEN);
	//compute  code*q/2+e2,
	pke_add_message(e2, p_code, c2_len);
	#endif
	//c2=b*r+e2+m*[q/2]
	poly_aff(pk+SEED_LEN,r,e2,c2,c2_len);
	//compress c2
	poly_compress(c2,c+DIM_N,c2_len);
	*clen=DIM_N+c2_len/2;
	LAC_SECURE_CLEAR(code, sizeof(code));
	LAC_SECURE_CLEAR(seeds, sizeof(seeds));
	LAC_SECURE_CLEAR(r, sizeof(r));
	LAC_SECURE_CLEAR(e1, sizeof(e1));
	LAC_SECURE_CLEAR(e2, sizeof(e2));
	LAC_SECURE_CLEAR(c2, sizeof(c2));
	LAC_SECURE_CLEAR(a, sizeof(a));
	LAC_SECURE_CLEAR(m_buf, sizeof(m_buf));
	
	return 0;

}

