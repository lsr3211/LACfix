#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rand.h"
#include "bch.h"
#include "ecc.h"
#include "compat.h"

#if LAC_CFG_CT_NEON_AVAILABLE
#include <arm_neon.h>
#endif

#if defined(__GNUC__) || defined(__clang__)
#define LAC_KEM_UNUSED_FN __attribute__((unused))
#else
#define LAC_KEM_UNUSED_FN
#endif

static inline uint32_t LAC_KEM_UNUSED_FN ct_mask_zero_u32(uint32_t x)
{
	uint32_t nonzero = (x | (0u - x)) >> 31;
	return 0u - (nonzero ^ 1u);
}

static inline unsigned char LAC_KEM_UNUSED_FN ct_select_u8(uint32_t mask,
							   unsigned char x,
							   unsigned char y)
{
	return (unsigned char)((mask & x) | (~mask & y));
}

#if LAC_CFG_CT_NEON_KEM_DEC_VERIFY
static inline uint8x16_t kem_load_u8q_tail(const unsigned char *in,
					   unsigned int n)
{
	uint8x16_t v = vdupq_n_u8(0);

	switch (n) {
	case 15: v = vld1q_lane_u8(in + 14u, v, 14);
	case 14: v = vld1q_lane_u8(in + 13u, v, 13);
	case 13: v = vld1q_lane_u8(in + 12u, v, 12);
	case 12: v = vld1q_lane_u8(in + 11u, v, 11);
	case 11: v = vld1q_lane_u8(in + 10u, v, 10);
	case 10: v = vld1q_lane_u8(in + 9u, v, 9);
	case 9: v = vld1q_lane_u8(in + 8u, v, 8);
	case 8: v = vld1q_lane_u8(in + 7u, v, 7);
	case 7: v = vld1q_lane_u8(in + 6u, v, 6);
	case 6: v = vld1q_lane_u8(in + 5u, v, 5);
	case 5: v = vld1q_lane_u8(in + 4u, v, 4);
	case 4: v = vld1q_lane_u8(in + 3u, v, 3);
	case 3: v = vld1q_lane_u8(in + 2u, v, 2);
	case 2: v = vld1q_lane_u8(in + 1u, v, 1);
	case 1: v = vld1q_lane_u8(in, v, 0);
	default: break;
	}

	return v;
}

static inline uint32_t kem_neon_or_reduce_u8x16(uint8x16_t v)
{
	uint8x8_t r = vorr_u8(vget_low_u8(v), vget_high_u8(v));

	r = vorr_u8(r, vext_u8(r, r, 4));
	r = vorr_u8(r, vext_u8(r, r, 2));
	r = vorr_u8(r, vext_u8(r, r, 1));
	return (uint32_t)vget_lane_u8(r, 0);
}

static inline void kem_store_u8q_tail(unsigned char *out, uint8x16_t v,
				      unsigned int n)
{
	switch (n) {
	case 15: vst1q_lane_u8(out + 14u, v, 14);
	case 14: vst1q_lane_u8(out + 13u, v, 13);
	case 13: vst1q_lane_u8(out + 12u, v, 12);
	case 12: vst1q_lane_u8(out + 11u, v, 11);
	case 11: vst1q_lane_u8(out + 10u, v, 10);
	case 10: vst1q_lane_u8(out + 9u, v, 9);
	case 9: vst1q_lane_u8(out + 8u, v, 8);
	case 8: vst1q_lane_u8(out + 7u, v, 7);
	case 7: vst1q_lane_u8(out + 6u, v, 6);
	case 6: vst1q_lane_u8(out + 5u, v, 5);
	case 5: vst1q_lane_u8(out + 4u, v, 4);
	case 4: vst1q_lane_u8(out + 3u, v, 3);
	case 3: vst1q_lane_u8(out + 2u, v, 2);
	case 2: vst1q_lane_u8(out + 1u, v, 1);
	case 1: vst1q_lane_u8(out, v, 0);
	default: break;
	}
}

static uint32_t kem_verify_diff_ct_neon(const unsigned char *x,
					const unsigned char *y,
					unsigned int len)
{
	unsigned int i;
	uint8x16_t acc = vdupq_n_u8(0);

	for (i = 0; i + 16u <= len; i += 16u)
		acc = vorrq_u8(acc, veorq_u8(vld1q_u8(x + i),
					     vld1q_u8(y + i)));

	if (i < len) {
		unsigned int rem = len - i;

		acc = vorrq_u8(acc, veorq_u8(kem_load_u8q_tail(x + i, rem),
					     kem_load_u8q_tail(y + i, rem)));
	}

	return kem_neon_or_reduce_u8x16(acc);
}

static void kem_select_key_ct_neon(unsigned char *dst,
				   const unsigned char *good,
				   const unsigned char *bad,
				   uint32_t mask,
				   unsigned int len)
{
	unsigned int i;
	uint8x16_t mask_vec = vdupq_n_u8((uint8_t)mask);

	for (i = 0; i + 16u <= len; i += 16u) {
		uint8x16_t good_vec = vld1q_u8(good + i);
		uint8x16_t bad_vec = vld1q_u8(bad + i);

		vst1q_u8(dst + i, vbslq_u8(mask_vec, good_vec, bad_vec));
	}

	if (i < len) {
		unsigned int rem = len - i;
		uint8x16_t good_vec = kem_load_u8q_tail(good + i, rem);
		uint8x16_t bad_vec = kem_load_u8q_tail(bad + i, rem);

		kem_store_u8q_tail(dst + i,
				   vbslq_u8(mask_vec, good_vec, bad_vec),
				   rem);
	}
}
#endif

//generate keypair
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
	//call the key generation algorithm of pke
	crypto_encrypt_keypair(pk, sk);
	return 0;
}
int crypto_kem_enc( unsigned char *ct, unsigned char *ss, const unsigned char *pk)
{
	kem_enc_fo(pk,ss,ct);
	return 0;
}
int crypto_kem_dec( unsigned char *ss, const unsigned char *ct, const unsigned char *sk)
{
	const unsigned char *pk=sk+DIM_N;
	kem_dec_fo(pk,sk,ct,ss);
	return 0;
}
// fo encryption for cca security 
int kem_enc_fo(const unsigned char *pk, unsigned char *k, unsigned char *c)
{
	unsigned char buf[MESSAGE_LEN+CIPHER_LEN],seed[SEED_LEN];
	unsigned long long clen;

	
	//check parameter
	if(pk==NULL || k==NULL || c==NULL)
	{
		return -1;
	}
	
	//generate random message m, stored in buf
	random_bytes(buf,MESSAGE_LEN);
	//compute seed=gen_seed(m)
	gen_seed(buf,MESSAGE_LEN,seed);
	//encrypt m with seed
	pke_enc_seed(pk,buf,MESSAGE_LEN,c,&clen,seed);
	
	//compute k=hash(m|c)
	memcpy(buf+MESSAGE_LEN,c,CIPHER_LEN);
	hash(buf,MESSAGE_LEN+CIPHER_LEN,k);
	LAC_SECURE_CLEAR(buf, sizeof(buf));
	LAC_SECURE_CLEAR(seed, sizeof(seed));
		
	return 0;
}

// fo encryption for cca security with seed
int kem_enc_fo_seed(const unsigned char *pk, unsigned char *k, unsigned char *c, unsigned char *seed)
{
	unsigned char buf[MESSAGE_LEN+CIPHER_LEN],local_seed[SEED_LEN];
	unsigned long long clen;

	
	//check parameter
	if(pk==NULL || k==NULL || c==NULL)
	{
		return -1;
	}
	
	//generate random message m from seed, stored in buf
	pseudo_random_bytes(buf,MESSAGE_LEN,seed);
	//compute loacal_seed=gen_seed(m)
	gen_seed(buf,MESSAGE_LEN,local_seed);
	//encrypt m with local_seed
	pke_enc_seed(pk,buf,MESSAGE_LEN,c,&clen,local_seed);
	
	//compute k=hash(m|c)
	memcpy(buf+MESSAGE_LEN,c,CIPHER_LEN);
	hash(buf,MESSAGE_LEN+CIPHER_LEN,k);
	LAC_SECURE_CLEAR(buf, sizeof(buf));
	LAC_SECURE_CLEAR(local_seed, sizeof(local_seed));
		
	return 0;
}

// decrypt of fo mode
int kem_dec_fo(const unsigned char *pk, const unsigned char *sk, const unsigned char *c, unsigned char *k)
{
#if LAC_CFG_CT_KEM_DEC_VERIFY
	unsigned char buf[MESSAGE_LEN+CIPHER_LEN],seed[SEED_LEN];
	unsigned char c_v[CIPHER_LEN];
	unsigned char k_good[MESSAGE_LEN],k_bad[MESSAGE_LEN];
	unsigned char fallback_in[MESSAGE_LEN+CIPHER_LEN];
	unsigned long long mlen,clen;
	uint32_t diff = 0;
	uint32_t match_mask;
#if !LAC_CFG_CT_NEON_KEM_DEC_VERIFY
	unsigned int i;
#endif
	
	//check parameter
	if(pk==NULL || sk==NULL || k==NULL || c==NULL)
	{
		return -1;
	}
	
	//compute m from c
	pke_dec(sk,c,CIPHER_LEN, buf,&mlen);
	//compte k=hash(m|c)
	memcpy(buf+MESSAGE_LEN,c,CIPHER_LEN);
	hash(buf,MESSAGE_LEN+CIPHER_LEN,k_good);
	//re-encryption with seed=gen_seed(m)
	gen_seed(buf,MESSAGE_LEN,seed);
	pke_enc_seed(pk,buf,MESSAGE_LEN,c_v,&clen,seed);

#if LAC_CFG_CT_NEON_KEM_DEC_VERIFY
	diff = kem_verify_diff_ct_neon(c, c_v, CIPHER_LEN);
#else
	for (i = 0; i < CIPHER_LEN; i++)
		diff |= (uint32_t)(c[i] ^ c_v[i]);
#endif

	//k=hash(hash(sk)|c)
	hash((unsigned char*)sk,DIM_N,fallback_in);
	memcpy(fallback_in+MESSAGE_LEN,c,CIPHER_LEN);
	hash(fallback_in,MESSAGE_LEN+CIPHER_LEN,k_bad);

		match_mask = ct_mask_zero_u32(diff);
#if LAC_CFG_CT_NEON_KEM_DEC_VERIFY
		kem_select_key_ct_neon(k, k_good, k_bad, match_mask,
				       MESSAGE_LEN);
#else
		for (i = 0; i < MESSAGE_LEN; i++)
			k[i] = ct_select_u8(match_mask, k_good[i], k_bad[i]);
#endif
		LAC_SECURE_CLEAR(buf, sizeof(buf));
		LAC_SECURE_CLEAR(seed, sizeof(seed));
		LAC_SECURE_CLEAR(c_v, sizeof(c_v));
		LAC_SECURE_CLEAR(k_good, sizeof(k_good));
		LAC_SECURE_CLEAR(k_bad, sizeof(k_bad));
		LAC_SECURE_CLEAR(fallback_in, sizeof(fallback_in));
	#else
	unsigned char buf[MESSAGE_LEN+CIPHER_LEN],seed[SEED_LEN];
	unsigned char c_v[CIPHER_LEN];
	unsigned long long mlen,clen;

	//compute m from c
	pke_dec(sk,c,CIPHER_LEN, buf,&mlen);
	//compte k=hash(m|c)
	memcpy(buf+MESSAGE_LEN,c,CIPHER_LEN);
	hash(buf,MESSAGE_LEN+CIPHER_LEN,k);
	//re-encryption with seed=gen_seed(m)
	gen_seed(buf,MESSAGE_LEN,seed);
	pke_enc_seed(pk,buf,MESSAGE_LEN,c_v,&clen,seed);

	//verify
		if(memcmp(c,c_v,CIPHER_LEN)!=0)
		{
			//k=hash(hash(sk)|c)
			hash((unsigned char*)sk,DIM_N,buf);
			hash(buf,MESSAGE_LEN+CIPHER_LEN,k);
		}
		LAC_SECURE_CLEAR(buf, sizeof(buf));
		LAC_SECURE_CLEAR(seed, sizeof(seed));
		LAC_SECURE_CLEAR(c_v, sizeof(c_v));
	#endif

	return 0;
}

