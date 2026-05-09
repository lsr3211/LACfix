#include "bch.h"
#include "ecc.h"
#include "lac_param.h"
#include "compat.h"
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#if LAC_CFG_CT_NEON_AVAILABLE
#include <arm_neon.h>
#endif

#if defined(__GNUC__) || defined(__clang__)
#define LAC_ECC_UNUSED_FN __attribute__((unused))
#else
#define LAC_ECC_UNUSED_FN
#endif

#if defined(LAC128)
//bch(511,256,61)
#include "bch128.h"
#endif

#if defined(LAC192)
//bch(511,384,29)
#include "bch192.h"
#endif

#if defined(LAC256)
//bch(1023,512,115)
#include "bch256.h"
#endif

# define DIV_ROUND_UP(a, b) ((a + b - 1) / b)
# define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(*(arr)))
/*
 * represent a polynomial over GF(2^m)
 */
struct gf_poly {
	unsigned int deg;    /* polynomial degree */
	unsigned int c[0];   /* polynomial terms */
};

/* given its degree, compute a polynomial size in bytes */
#define GF_POLY_SZ(_d) (sizeof(struct gf_poly)+((_d)+1)*sizeof(unsigned int))

/* polynomial of degree 1 */
struct gf_poly_deg1 {
	struct gf_poly poly;
	unsigned int   c[2];
};

static inline uint32_t ecc_ct_mask_nonzero_u32(uint32_t x)
{
	return 0u - ((x | (0u - x)) >> 31);
}

static inline uint32_t ecc_ct_mask_lt_u32(uint32_t a, uint32_t b)
{
	return 0u - ((a - b) >> 31);
}

static inline uint32_t ecc_ct_mask_eq_u32(uint32_t a, uint32_t b)
{
	return ~ecc_ct_mask_nonzero_u32(a ^ b);
}

static void LAC_ECC_UNUSED_FN ecc_correct_std(unsigned char *data_buf,
					      const unsigned int *error_loc,
					      int error_num)
{
	int i;

	if(error_num>0)
	{
		for (i=0;i<error_num;i++)
		{
			if(error_loc[i]<DATA_LEN*8)
				data_buf[(error_loc[i])/8] ^= (1 << ((error_loc[i]) % 8));
		}
	}
}

static void LAC_ECC_UNUSED_FN ecc_correct_ct_scalar(unsigned char *data_buf,
						    const unsigned int *error_loc,
						    int error_num)
{
	int i;
	uint32_t positive_mask = 0u - (uint32_t)(error_num > 0);
	uint32_t err_u = ((uint32_t)error_num) & positive_mask;

	for (i=0;i<MAX_ERROR;i++)
	{
		unsigned int j;
		uint32_t mask_i = ecc_ct_mask_lt_u32((uint32_t)i, err_u);
		uint32_t loc = error_loc[i];
		uint32_t mask_data = ecc_ct_mask_lt_u32(loc, (uint32_t)(DATA_LEN*8));
		uint32_t mask_apply = mask_i & mask_data;
		uint32_t byte_idx = loc >> 3;
		unsigned char bit = (unsigned char)(1u << (loc & 7u));

		for (j=0;j<DATA_LEN;j++)
		{
			uint32_t byte_mask = mask_apply & ecc_ct_mask_eq_u32(j, byte_idx);
			data_buf[j] ^= (unsigned char)(bit & (unsigned char)byte_mask);
		}
	}
}

#if LAC_CFG_CT_NEON_ECC_CORRECT
static void ecc_correct_ct_neon(unsigned char *data_buf,
				const unsigned int *error_loc,
				int error_num)
{
	int i;
	const uint8x16_t idx_lo = {
		0, 1, 2, 3, 4, 5, 6, 7,
		8, 9, 10, 11, 12, 13, 14, 15
	};
	const uint8x16_t idx_hi = {
		16, 17, 18, 19, 20, 21, 22, 23,
		24, 25, 26, 27, 28, 29, 30, 31
	};
	uint32_t positive_mask = 0u - (uint32_t)(error_num > 0);
	uint32_t err_u = ((uint32_t)error_num) & positive_mask;

	for (i=0;i<MAX_ERROR;i++)
	{
		uint32_t mask_i = ecc_ct_mask_lt_u32((uint32_t)i, err_u);
		uint32_t loc = error_loc[i];
		uint32_t mask_data = ecc_ct_mask_lt_u32(loc, (uint32_t)(DATA_LEN*8));
		uint8_t apply = (uint8_t)(mask_i & mask_data);
		uint8_t byte_idx = (uint8_t)(loc >> 3);
		uint8_t bit = (uint8_t)(1u << (loc & 7u));
		uint8x16_t byte_vec = vdupq_n_u8(byte_idx);
		uint8x16_t bit_vec = vdupq_n_u8(bit);
		uint8x16_t apply_vec = vdupq_n_u8(apply);
		uint8x16_t delta_lo = vandq_u8(vandq_u8(vceqq_u8(idx_lo, byte_vec), apply_vec), bit_vec);
		uint8x16_t delta_hi = vandq_u8(vandq_u8(vceqq_u8(idx_hi, byte_vec), apply_vec), bit_vec);

		vst1q_u8(data_buf, veorq_u8(vld1q_u8(data_buf), delta_lo));
		vst1q_u8(data_buf + 16, veorq_u8(vld1q_u8(data_buf + 16), delta_hi));
	}
}
#endif

static void ecc_correct(unsigned char *data_buf,
			const unsigned int *error_loc,
			int error_num)
{
#if LAC_CFG_CT_NEON_ECC_CORRECT
	ecc_correct_ct_neon(data_buf, error_loc, error_num);
#elif LAC_CFG_CT_ECC_CORRECT
	ecc_correct_ct_scalar(data_buf, error_loc, error_num);
#else
	ecc_correct_std(data_buf, error_loc, error_num);
#endif
}

static int ecc_workspace_ready = 0;
//init
int ecc_init()
{
	int i;

	if (ecc_workspace_ready)
	{
		return 0;
	}
	//init the bch encoder
	ecc_bch.elp= malloc((ecc_bch.t+1)*sizeof(struct gf_poly_deg1));
	if(ecc_bch.elp==NULL)
	{
		return -1;
	}
	else
	{
		memset(ecc_bch.elp,0,(ecc_bch.t+1)*sizeof(struct gf_poly_deg1));
	}
	for (i = 0; i < ARRAY_SIZE(ecc_bch.poly_2t); i++)
	{
		ecc_bch.poly_2t[i] = malloc(GF_POLY_SZ(2*ecc_bch.t));
		if(ecc_bch.poly_2t[i]==NULL)
		{
			return -1;
		}
		else
		{
			memset(ecc_bch.poly_2t[i],0,GF_POLY_SZ(2*ecc_bch.t));
		}
	}

	ecc_workspace_ready = 1;
	return 0;
}

//free
int ecc_free()
{
	int i;
	
	if(ecc_bch.elp!=NULL)
	{
		free(ecc_bch.elp);
		ecc_bch.elp=NULL;
	}
	
	for (i = 0; i < ARRAY_SIZE(ecc_bch.poly_2t); i++)
	{
		if(ecc_bch.poly_2t[i]!=NULL)
		{
			free(ecc_bch.poly_2t[i]);
			ecc_bch.poly_2t[i]=NULL;
		}
	}

	ecc_workspace_ready = 0;
	return 0;
}

//error corretion encode
int ecc_enc(const unsigned char *d, unsigned char *c)
{
	unsigned char ecc[ECCBUF_LEN];
	unsigned char data_buf[DATABUF_LEN];

	/*
	 * 旧实现：在热路径里做懒初始化。
	 * 现在改为程序启动阶段在 main() 中显式调用 ecc_init()。
	 */
	/*
	if (ecc_prepare_workspace() != 0)
	{
		return -1;
	}
	*/
	//init ecc to be 0 as requited by encode_bch function
	memset(ecc,0,ECCBUF_LEN);
	//clear data_buf and copy data to data_buf
	memset(data_buf,0,DATABUF_LEN);
	memcpy(data_buf,d,DATA_LEN);
	//encoode
	encode_bch(&ecc_bch,data_buf,DATA_LEN,ecc);
	//copy data to the first part of code
	memcpy(c,d,DATA_LEN);
	// compy ecc to the second part of code
	memcpy(c+DATA_LEN,ecc,ECC_LEN);
	LAC_SECURE_CLEAR(ecc, sizeof(ecc));
	LAC_SECURE_CLEAR(data_buf, sizeof(data_buf));
		
	return 0;
}

//error corrction decode
int ecc_dec(unsigned char *d, const unsigned char *c)
{
	//test error without error correction 
	#ifndef TEST_ROW_ERROR_RATE
	int error_num=-1;
				unsigned char ecc[ECCBUF_LEN];
				unsigned char data_buf[DATABUF_LEN];
				unsigned int error_loc[MAX_ERROR];
			/*
			 * 旧实现：在热路径里做懒初始化。
			 * 现在改为程序启动阶段在 main() 中显式调用 ecc_init()。
			 */
			/*
			if (ecc_prepare_workspace() != 0)
			{
				return -1;
			}
			*/
			//clear data_buf and copy data to data_buf
			memset(data_buf,0,DATABUF_LEN);
	memcpy(data_buf,c,DATA_LEN);
	//compy correction code to ecc
	memcpy(ecc,c+DATA_LEN,ECC_LEN);
	memset(ecc+ECC_LEN,0,ECCBUF_LEN-ECC_LEN);
	//decode
	memset(error_loc,0,sizeof(error_loc));
	error_num=decode_bch(&ecc_bch,data_buf,DATA_LEN,ecc,NULL,NULL,error_loc);
	//correct errors
	ecc_correct(data_buf, error_loc, error_num);
			//copy data to d
			memcpy(d,data_buf,DATA_LEN);
		LAC_SECURE_CLEAR(ecc, sizeof(ecc));
		LAC_SECURE_CLEAR(data_buf, sizeof(data_buf));
		LAC_SECURE_CLEAR(error_loc, sizeof(error_loc));
		
		#else
	int error_num=-1;
	//copy data to d
	memcpy(d,c,DATA_LEN);
	#endif
	
	return error_num;
}
