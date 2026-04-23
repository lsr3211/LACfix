#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rand.h"
#include "bch.h"
#include "ecc.h"
#include "compat.h"

static inline uint32_t ct_mask_zero_u32(uint32_t x)
{
	uint32_t nonzero = (x | (0u - x)) >> 31;
	return 0u - (nonzero ^ 1u);
}

static inline unsigned char ct_select_u8(uint32_t mask,
					 unsigned char x,
					 unsigned char y)
{
	return (unsigned char)((mask & x) | (~mask & y));
}

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
#if LAC_USE_CT_KEM_DEC
	unsigned char buf[MESSAGE_LEN+CIPHER_LEN],seed[SEED_LEN];
	unsigned char c_v[CIPHER_LEN];
	unsigned char k_good[MESSAGE_LEN],k_bad[MESSAGE_LEN];
	unsigned char fallback_in[MESSAGE_LEN+CIPHER_LEN];
	unsigned long long mlen,clen;
	uint32_t diff = 0;
	uint32_t match_mask;
	unsigned int i;
	
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

	for (i = 0; i < CIPHER_LEN; i++)
		diff |= (uint32_t)(c[i] ^ c_v[i]);

	//k=hash(hash(sk)|c)
	hash((unsigned char*)sk,DIM_N,fallback_in);
	memcpy(fallback_in+MESSAGE_LEN,c,CIPHER_LEN);
	hash(fallback_in,MESSAGE_LEN+CIPHER_LEN,k_bad);

		match_mask = ct_mask_zero_u32(diff);
		for (i = 0; i < MESSAGE_LEN; i++)
			k[i] = ct_select_u8(match_mask, k_good[i], k_bad[i]);
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

