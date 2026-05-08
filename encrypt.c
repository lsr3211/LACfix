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

static inline uint32_t enc_ct_mask_lt_u32(uint32_t a, uint32_t b)
{
	uint64_t diff = (uint64_t)a - (uint64_t)b;
	return 0u - (uint32_t)(diff >> 63);
}

static inline uint32_t enc_ct_mask_ge_u32(uint32_t a, uint32_t b)
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

static const uint8_t enc_neon_bit_shift_bytes8[8] = {
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

static inline uint8x8_t enc_neon_code_bits8(const unsigned char *p_code)
{
	uint8x8_t bytes = vdup_n_u8(p_code[0]);
	uint8x8_t shifts = vld1_u8(enc_neon_bit_shift_bytes8);
	uint8x8_t shifted = vshl_u8(bytes, vneg_s8(vreinterpret_s8_u8(shifts)));

	return vand_u8(shifted, vdup_n_u8(1u));
}

static inline uint8_t enc_neon_pack8_u16(uint16x8_t mask)
{
	uint16_t lanes[8];
	uint8_t packed = 0;
	unsigned int i;

	vst1q_u16(lanes, mask);
	for (i = 0; i < 8u; i++)
		packed |= (uint8_t)(((lanes[i] >> 15) & 1u) << i);

	return packed;
}

static inline int16x8_t enc_neon_sub_mod_q8(uint8x8_t x, uint8x8_t y)
{
	int16x8_t d = vreinterpretq_s16_u16(vsubl_u8(x, y));
	uint16x8_t neg = vcltq_s16(d, vdupq_n_s16(0));

	return vaddq_s16(d, vreinterpretq_s16_u16(vandq_u16(neg, vdupq_n_u16((uint16_t)Q))));
}
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
	int i;
	const int low = Q/4;
	const int high = Q*3/4;

	for(i=0;i<c2_len;i++)
	{
		int temp=enc_sub_mod_q_u8(c2[i], out[i]);

		uint32_t bit_mask =
			enc_ct_mask_ge_u32((uint32_t)temp, (uint32_t)low) &
			enc_ct_mask_lt_u32((uint32_t)temp, (uint32_t)high) &
			(1u << (i%8));

		p_code[i/8] ^= (unsigned char)bit_mask;
	}
}

#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
static void pke_recover_msg_ct_neon(const unsigned char *c2,
				    const unsigned char *out,
				    unsigned char *p_code,
				    int c2_len)
{
	int i;
	const int vec_len = c2_len & ~7;
	const int16x8_t low = vdupq_n_s16((int16_t)(Q/4));
	const int16x8_t high = vdupq_n_s16((int16_t)(Q*3/4));

	for (i = 0; i < vec_len; i += 8)
	{
		int16x8_t temp = enc_neon_sub_mod_q8(vld1_u8(c2 + i),
						     vld1_u8(out + i));
		uint16x8_t ge_low = vcgeq_s16(temp, low);
		uint16x8_t lt_high = vcltq_s16(temp, high);
		uint8_t packed = enc_neon_pack8_u16(vandq_u16(ge_low, lt_high));

		p_code[i >> 3] ^= packed;
	}

	for (; i < c2_len; i++)
	{
		int temp=enc_sub_mod_q_u8(c2[i], out[i]);
		uint32_t bit_mask =
			enc_ct_mask_ge_u32((uint32_t)temp, (uint32_t)(Q/4)) &
			enc_ct_mask_lt_u32((uint32_t)temp, (uint32_t)(Q*3/4)) &
			(1u << (i%8));

		p_code[i/8] ^= (unsigned char)bit_mask;
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
	int i;
	const int center_point=Q/2;
	const int d2_bound=Q/2;

	for(i=0;i<vec_bound;i++)
	{
		int temp1=enc_sub_mod_q_u8(c2[i], out[i]);
		int temp2=enc_sub_mod_q_u8(c2[i+vec_bound], out[i+vec_bound]);
		uint32_t mask1 = enc_ct_mask_lt_u32((uint32_t)temp1,
						    (uint32_t)center_point);
		uint32_t mask2 = enc_ct_mask_lt_u32((uint32_t)temp2,
						    (uint32_t)center_point);

		temp1 = (int)enc_ct_select_u32(mask1, (uint32_t)(Q-temp1),
					       (uint32_t)temp1);
		temp2 = (int)enc_ct_select_u32(mask2, (uint32_t)(Q-temp2),
					       (uint32_t)temp2);
		temp1+=temp2-Q;

		{
			uint32_t bit_mask =
				enc_ct_mask_lt_u32((uint32_t)temp1,
						   (uint32_t)d2_bound) &
				(1u << (i%8));

			p_code[i/8] ^= (unsigned char)bit_mask;
		}
	}
}

#if LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
static void pke_recover_msg_d2_ct_neon(const unsigned char *c2,
				       const unsigned char *out,
				       unsigned char *p_code,
				       int vec_bound)
{
	int i;
	const int vec_len = vec_bound & ~7;
	const int16x8_t q = vdupq_n_s16((int16_t)Q);
	const int16x8_t center = vdupq_n_s16((int16_t)(Q/2));
	const int16x8_t d2_bound = vdupq_n_s16((int16_t)(Q/2));

	for (i = 0; i < vec_len; i += 8)
	{
		int16x8_t temp1 = enc_neon_sub_mod_q8(vld1_u8(c2 + i),
						      vld1_u8(out + i));
		int16x8_t temp2 = enc_neon_sub_mod_q8(vld1_u8(c2 + vec_bound + i),
						      vld1_u8(out + vec_bound + i));
		uint16x8_t mask1 = vcltq_s16(temp1, center);
		uint16x8_t mask2 = vcltq_s16(temp2, center);
		int16x8_t flip1 = vsubq_s16(q, temp1);
		int16x8_t flip2 = vsubq_s16(q, temp2);
		int16x8_t merged;
		uint8_t packed;

		temp1 = vbslq_s16(mask1, flip1, temp1);
		temp2 = vbslq_s16(mask2, flip2, temp2);
		merged = vsubq_s16(vaddq_s16(temp1, temp2), q);
		packed = enc_neon_pack8_u16(vcltq_s16(merged, d2_bound));

		p_code[i >> 3] ^= packed;
	}

	for (; i < vec_bound; i++)
	{
		int temp1=enc_sub_mod_q_u8(c2[i], out[i]);
		int temp2=enc_sub_mod_q_u8(c2[i+vec_bound], out[i+vec_bound]);
		uint32_t mask1 = enc_ct_mask_lt_u32((uint32_t)temp1, (uint32_t)(Q/2));
		uint32_t mask2 = enc_ct_mask_lt_u32((uint32_t)temp2, (uint32_t)(Q/2));

		temp1 = (int)enc_ct_select_u32(mask1, (uint32_t)(Q-temp1), (uint32_t)temp1);
		temp2 = (int)enc_ct_select_u32(mask2, (uint32_t)(Q-temp2), (uint32_t)temp2);
		temp1+=temp2-Q;

		p_code[i/8] ^= (unsigned char)(enc_ct_mask_lt_u32((uint32_t)temp1,
								  (uint32_t)(Q/2)) &
					       (1u << (i%8)));
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
		uint8x8_t bits = enc_neon_code_bits8(p_code + (i >> 3));
		int8x8_t msg = vreinterpret_s8_u8(vmul_u8(bits, vdup_n_u8((uint8_t)RATIO)));
		int8x8_t vals = vld1_s8((const int8_t *)(e2 + i));

		vst1_s8((int8_t *)(e2 + i), vadd_s8(vals, msg));
	}
}
#endif

static void pke_add_message(lac_small_t *e2,
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

	for (; i < vec_bound; i++)
	{
		int8_t message=RATIO*((p_code[i/8]>>(i%8))&1);
		e2[i]=e2[i]+message;
		e2[i+vec_bound]=e2[i+vec_bound]+message;
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
	if(c==NULL || m==NULL || pk==NULL)
	{
		return -1;
	}
	if(mlen>MESSAGE_LEN)
	{
		return -1;
	}
	
	//call pke encryption function
	pke_enc(pk,m, mlen,c,clen);

	return 0;
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
	pke_dec(sk,c,clen,m,mlen);

	return 0;
}

//key generation with seed
int kg_seed(unsigned char *pk, unsigned char *sk, unsigned char *seed)
{
	unsigned char seeds[3*SEED_LEN];
	unsigned char a[DIM_N];
	lac_small_t e[DIM_N];
	//check pointer
	if(pk==NULL || sk==NULL)
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
	
	//generate seed
	random_bytes(seed,SEED_LEN);
	//encrypt with seed 
	pke_enc_seed(pk,m,mlen,c,clen,seed);	
	LAC_SECURE_CLEAR(seed, sizeof(seed));

	return 0;
}
// decrypt
int pke_dec(const unsigned char *sk, const unsigned char *c,unsigned long long clen, unsigned char *m, unsigned long long *mlen)
{
	unsigned char out[DIM_N];
	unsigned char code[CODE_LEN],*p_code;
	unsigned char c2[C2_VEC_NUM];
	int c2_len=(clen-DIM_N)*2;
	unsigned char m_buf[MESSAGE_LEN];
	
	//check parameter
	if(sk==NULL || m==NULL || c==NULL)
	{
		return -1;
	}
	
	#ifdef LAC256 //D2 decoding
	
	int vec_bound=c2_len/2;
	//compute mlen
	*mlen=c2_len/16-ECC_LEN;
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
	
		
	//c2 decompress
	poly_decompress(c+DIM_N,c2,c2_len);
	//c1*sk
	poly_mul(c,(lac_small_t*)sk,out,DIM_N);
	//compute mlen
	*mlen=c2_len/8-ECC_LEN;
	//init code
	memset(code,0,CODE_LEN);
	//shift the pointer of code
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
	if(pk==NULL || m==NULL || c==NULL )
	{
		return -1;
	}
	if(mlen>MESSAGE_LEN)
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

