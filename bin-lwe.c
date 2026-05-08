
#include <string.h>
#include "bin-lwe.h"
#include "rand.h"
#include "lac_param.h"
#include <stdio.h>
#include <stdint.h>
#include "compat.h"

#if LAC_CFG_CT_NEON_AVAILABLE
#include <arm_neon.h>
#endif

#if defined(__GNUC__) || defined(__clang__)
#define LAC_UNUSED_FN __attribute__((unused))
#else
#define LAC_UNUSED_FN
#endif




//generate the public parameter a from seed
static int LAC_UNUSED_FN gen_a_scalar_backend(unsigned char *a,  const unsigned char *seed)
{
	int i,j;
	unsigned char buf[MESSAGE_LEN];
	//check the pointers
	if(a==NULL || seed==NULL)
	{
		return 1;
	}
	
	pseudo_random_bytes(a,DIM_N,seed);
	
	hash(seed,SEED_LEN,buf);
	j=0;
	for(i=0;i<DIM_N;i++)
	{
		while(a[i]>=Q)
		{
			memcpy(a+i,buf+(j++),1);//replace a[i] with buf[j]
			if(j>=MESSAGE_LEN)
			{
				hash(buf,MESSAGE_LEN,buf);//use hash chain to refresh buf
				j=0;
			}
		}
	}
	LAC_SECURE_CLEAR(buf, sizeof(buf));
			
	return 0;
}

#if LAC_CFG_CT_NEON_AVAILABLE
static int gen_a_ct_neon_backend(unsigned char *a,  const unsigned char *seed)
{
    unsigned int i, lane;
    unsigned int j;
    unsigned char buf[MESSAGE_LEN];
    const uint8x16_t q_vec = vdupq_n_u8((uint8_t)Q);

    if(a==NULL || seed==NULL)
    {
        return 1;
    }

    pseudo_random_bytes(a,DIM_N,seed);

    hash(seed,SEED_LEN,buf);
    j=0;
    for(i=0;i<DIM_N;i+=16u)
    {
        uint8x16_t a_vec = vld1q_u8(a + i);
        uint8x16_t bad_vec = vcgeq_u8(a_vec, q_vec);
        uint8_t bad_lanes[16];

        vst1q_u8(bad_lanes, bad_vec);
        for(lane=0;lane<16u;lane++)
        {
            if(bad_lanes[lane])
            {
                while(a[i + lane]>=Q)
                {
                    memcpy(a+i+lane,buf+(j++),1);
                    if(j>=MESSAGE_LEN)
                    {
                        hash(buf,MESSAGE_LEN,buf);
                        j=0;
                    }
                }
            }
        }
    }
    LAC_SECURE_CLEAR(buf, sizeof(buf));

    return 0;
}
#endif

int gen_a(unsigned char *a,  const unsigned char *seed)
{
#if LAC_CFG_CT_NEON_AVAILABLE
    return gen_a_ct_neon_backend(a, seed);
#else
    return gen_a_scalar_backend(a, seed);
#endif
}
 
//generate the small random vector for secret and error, with fixed hamming weight
int gen_psi_fix_ham(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
	#if LAC_CFG_CT_BINLWE_PSI_FIXED
    return gen_psi_fix_ham_ct(e, vec_num, seed);
	#else
	if(e==NULL)
	{
		return 1;
	}
	
	unsigned char buf[MESSAGE_LEN];
	int i,bound1,bound2,j;
	uint16_t *p_index,mask;
	
	
	#if defined PSI_SQUARE
	
	//Pr[e[i]=-1]=1/8,Pr[s[i]=0]=3/4,Pr[e[i]=1]=1/8,
	unsigned char r[vec_num/2];
	//generate vec_num/2 bytes, use 4 bits to generate one error item
	pseudo_random_bytes(r,vec_num/2,seed);
	//set the number  of 1 or -1
	bound1=vec_num/8;
	bound2=vec_num/4;
	
	#else
	
	//Pr[e[i]=-1]=1/4,Pr[s[i]=0]=1/2,Pr[e[i]=1]=1/4,
	unsigned char r[vec_num];
	//generate vec_num/2 bytes, use 4 bits to generate one error item
	pseudo_random_bytes(r,vec_num,seed);
	//set the number  of 1 or -1
	bound1=vec_num/4;
	bound2=vec_num/2;
	
	#endif
	
	//init e to be 0
	memset(e,0,vec_num);
	//set mask
	mask=DIM_N-1;
	//if collision, refresh index
	hash(seed,SEED_LEN,buf);
	//set index pointer
	p_index=(uint16_t*)r;
	j=0;
	//set 1
	for(i=0;i<bound1;i++)
	{
		while(e[p_index[i]&mask])
		{
			//refresh index
			memcpy(p_index+i,buf+j,2);//replace p_index[i] with buf[j]
			j+=2;
			if(j>=MESSAGE_LEN)
			{
				hash(buf,MESSAGE_LEN,buf);//use hash chain to refresh buf
				j=0;
			}
		}
		e[p_index[i]&mask]=1;

	}
	//set -1
		for(i=bound1;i<bound2;i++)
		{
		while(e[p_index[i]&mask])
		{
			//refresh index
			memcpy(p_index+i,buf+j,2);//replace p_index[i] with buf[j]
			j+=2;
			if(j>=MESSAGE_LEN)
			{
				hash(buf,MESSAGE_LEN,buf);//use hash chain to refresh buf
				j=0;
			}
		}
			e[p_index[i]&mask]=-1;
		}
		LAC_SECURE_CLEAR(buf, sizeof(buf));
		LAC_SECURE_CLEAR(r, sizeof(r));
		
		return 0;
	#endif
}

//generate the small random vector for secret and error
static int LAC_UNUSED_FN gen_psi_std_scalar_backend(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
	int i;
	
	if(e==NULL)
	{
		return 1;
	}
	
	#if defined PSI_SQUARE
	//Pr[e[i]=-1]=1/8,Pr[s[i]=0]=3/4,Pr[e[i]=1]=1/8,
	unsigned char r[vec_num/2],*p1,*p2,*p3;
	int e_0,e_1;
	//generate vec_num/2 bytes, use 4 bits to generate one error item
	pseudo_random_bytes(r,vec_num/2,seed);
	//COMPUTE e from r
	p1=r+vec_num/8;
	p2=p1+vec_num/8;
	p3=p2+vec_num/8;
		for(i=0;i<vec_num;i++)
		{
			e_0=((r[i/8]>>(i%8))&1)-((p1[i/8]>>(i%8))&1);
			e_1=((p2[i/8]>>(i%8))&1)-((p3[i/8]>>(i%8))&1);
			e[i]=e_0*e_1;
		}
		LAC_SECURE_CLEAR(r, sizeof(r));
		
		#else
	//Pr[e[i]=-1]=1/4,Pr[s[i]=0]=1/2,Pr[e[i]=1]=1/4,
	unsigned char r[vec_num/4],*p;
	
	//generate vec_num/4 bytes, use two bits to generate one error item
	pseudo_random_bytes(r,vec_num/4,seed);
	//COMPUTE e from r
	p=r+vec_num/8;
		for(i=0;i<vec_num;i++)
		{
			e[i]=((r[i/8]>>(i%8))&1)-((p[i/8]>>(i%8))&1);
		}
		LAC_SECURE_CLEAR(r, sizeof(r));
	
		#endif
	
	return 0;
}

#if LAC_CFG_CT_NEON_AVAILABLE
static inline void store_s8x16_tail(lac_small_t *dst, int8x16_t src, unsigned int n)
{
    if (n >= 8u) {
        vst1_s8((int8_t *)dst, vget_low_s8(src));
        dst += 8;
        src = vcombine_s8(vget_high_s8(src), vdup_n_s8(0));
        n -= 8u;
    }

    if (n != 0u) {
        int8x8_t lo = vget_low_s8(src);

        switch (n) {
        case 7: vst1_lane_s8((int8_t *)dst + 6u, lo, 6);
        case 6: vst1_lane_s8((int8_t *)dst + 5u, lo, 5);
        case 5: vst1_lane_s8((int8_t *)dst + 4u, lo, 4);
        case 4: vst1_lane_s8((int8_t *)dst + 3u, lo, 3);
        case 3: vst1_lane_s8((int8_t *)dst + 2u, lo, 2);
        case 2: vst1_lane_s8((int8_t *)dst + 1u, lo, 1);
        case 1: vst1_lane_s8((int8_t *)dst, lo, 0);
        default: break;
        }
    }
}

static inline uint8x16_t expand_bits16_u8(uint8_t lo, uint8_t hi)
{
    const int8x16_t shifts = {0, -1, -2, -3, -4, -5, -6, -7,
                              0, -1, -2, -3, -4, -5, -6, -7};
    uint8x16_t bytes = {lo, lo, lo, lo, lo, lo, lo, lo,
                        hi, hi, hi, hi, hi, hi, hi, hi};

    return vandq_u8(vshlq_u8(bytes, shifts), vdupq_n_u8(1));
}

static int gen_psi_std_ct_neon_backend(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
    unsigned int i;

    if(e==NULL)
    {
        return 1;
    }

#if defined PSI_SQUARE
    {
        unsigned char r[vec_num/2];
        unsigned char *p1, *p2, *p3;

        pseudo_random_bytes(r,vec_num/2,seed);
        p1=r+vec_num/8;
        p2=p1+vec_num/8;
        p3=p2+vec_num/8;

        for(i=0;i+16u<=vec_num;i+=16u)
        {
            uint8x16_t r_bits = expand_bits16_u8(r[i/8u], r[i/8u + 1u]);
            uint8x16_t p1_bits = expand_bits16_u8(p1[i/8u], p1[i/8u + 1u]);
            uint8x16_t p2_bits = expand_bits16_u8(p2[i/8u], p2[i/8u + 1u]);
            uint8x16_t p3_bits = expand_bits16_u8(p3[i/8u], p3[i/8u + 1u]);
            int8x16_t e0 = vsubq_s8(vreinterpretq_s8_u8(r_bits),
                                    vreinterpretq_s8_u8(p1_bits));
            int8x16_t e1 = vsubq_s8(vreinterpretq_s8_u8(p2_bits),
                                    vreinterpretq_s8_u8(p3_bits));
            vst1q_s8((int8_t *)(e + i), vmulq_s8(e0, e1));
        }
        if(i<vec_num)
        {
            unsigned int rem = vec_num - i;
            uint8_t hi_r = (rem > 8u) ? r[i/8u + 1u] : 0u;
            uint8_t hi_p1 = (rem > 8u) ? p1[i/8u + 1u] : 0u;
            uint8_t hi_p2 = (rem > 8u) ? p2[i/8u + 1u] : 0u;
            uint8_t hi_p3 = (rem > 8u) ? p3[i/8u + 1u] : 0u;
            uint8x16_t r_bits = expand_bits16_u8(r[i/8u], hi_r);
            uint8x16_t p1_bits = expand_bits16_u8(p1[i/8u], hi_p1);
            uint8x16_t p2_bits = expand_bits16_u8(p2[i/8u], hi_p2);
            uint8x16_t p3_bits = expand_bits16_u8(p3[i/8u], hi_p3);
            int8x16_t e0 = vsubq_s8(vreinterpretq_s8_u8(r_bits),
                                    vreinterpretq_s8_u8(p1_bits));
            int8x16_t e1 = vsubq_s8(vreinterpretq_s8_u8(p2_bits),
                                    vreinterpretq_s8_u8(p3_bits));
            store_s8x16_tail(e + i, vmulq_s8(e0, e1), rem);
        }
        LAC_SECURE_CLEAR(r, sizeof(r));
    }
#else
    {
        unsigned char r[vec_num/4],*p;

        pseudo_random_bytes(r,vec_num/4,seed);
        p=r+vec_num/8;

        for(i=0;i+16u<=vec_num;i+=16u)
        {
            uint8x16_t r_bits = expand_bits16_u8(r[i/8u], r[i/8u + 1u]);
            uint8x16_t p_bits = expand_bits16_u8(p[i/8u], p[i/8u + 1u]);
            int8x16_t out = vsubq_s8(vreinterpretq_s8_u8(r_bits),
                                     vreinterpretq_s8_u8(p_bits));
            vst1q_s8((int8_t *)(e + i), out);
        }
        if(i<vec_num)
        {
            unsigned int rem = vec_num - i;
            uint8_t hi_r = (rem > 8u) ? r[i/8u + 1u] : 0u;
            uint8_t hi_p = (rem > 8u) ? p[i/8u + 1u] : 0u;
            uint8x16_t r_bits = expand_bits16_u8(r[i/8u], hi_r);
            uint8x16_t p_bits = expand_bits16_u8(p[i/8u], hi_p);
            int8x16_t out = vsubq_s8(vreinterpretq_s8_u8(r_bits),
                                     vreinterpretq_s8_u8(p_bits));
            store_s8x16_tail(e + i, out, rem);
        }
        LAC_SECURE_CLEAR(r, sizeof(r));
    }
#endif

    return 0;
}
#endif

int gen_psi_std(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
#if LAC_CFG_CT_NEON_AVAILABLE
    return gen_psi_std_ct_neon_backend(e, vec_num, seed);
#else
    return gen_psi_std_scalar_backend(e, vec_num, seed);
#endif
}

 /* ---------------- CT helper ---------------- *///ct辅助函数

static inline uint32_t ct_mask_eq_u32(uint32_t a, uint32_t b)
{
    uint32_t x = a ^ b;
    x |= (uint32_t)(0u - x);
    x >>= 31;
    x ^= 1u;
    return (uint32_t)(0u - x);   /* equal -> 0xffffffff, else 0 */
}

static inline uint32_t ct_mask_nonzero_u32(uint32_t x)
{
    return (uint32_t)(0u - ((x | (0u - x)) >> 31));
}

/* a < b ? 0xffffffff : 0x00000000 */
static inline uint32_t ct_mask_lt_u32(uint32_t a, uint32_t b)
{
    /* unsigned compare */
    uint32_t x = a ^ ((a ^ b) | ((a - b) ^ b));
    x = (x >> 31) & 1u;
    return (uint32_t)(0u - x);
}

static inline void ct_swap_u32(uint32_t *a, uint32_t *b, uint32_t swap_mask)
{
    uint32_t t = (*a ^ *b) & swap_mask;
    *a ^= t;
    *b ^= t;
}

static inline void ct_swap_u16(uint16_t *a, uint16_t *b, uint32_t swap_mask)
{
    uint16_t m = (uint16_t)swap_mask;
    uint16_t t = (uint16_t)((*a ^ *b) & m);
    *a ^= t;
    *b ^= t;
}

typedef struct {
	     uint32_t key;
	     uint16_t idx;
	 } psi_item_t;

/* 从随机字节流中取 32-bit little-endian */
static inline uint32_t load_u32_le(const unsigned char *p)
{
    return ((uint32_t)p[0])
         | ((uint32_t)p[1] << 8)
         | ((uint32_t)p[2] << 16)
         | ((uint32_t)p[3] << 24);
}

/*
 * 固定流程 compare-exchange
 * dir = 1: 升序
 * dir = 0: 降序
 *
 * 交换条件不使用 branch，而是用 mask。
 */
static inline void psi_item_compare_exchange(psi_item_t *a, psi_item_t *b, uint32_t dir)
{
    uint32_t key_a = a->key;
    uint32_t key_b = b->key;
    uint16_t idx_a = a->idx;
    uint16_t idx_b = b->idx;

    /* key 相等时按 idx 破平，保证顺序确定 */
    uint32_t key_lt = ct_mask_lt_u32(key_a, key_b);
    uint32_t key_gt = ct_mask_lt_u32(key_b, key_a);
    uint32_t key_eq = ct_mask_eq_u32(key_a, key_b);
    uint32_t idx_lt = ct_mask_lt_u32((uint32_t)idx_a, (uint32_t)idx_b);

    /* (a < b) ? 0xffffffff : 0 */
    uint32_t a_lt_b = key_lt | (key_eq & idx_lt);

    /*
     * dir=1 升序：若 b < a，则交换
     * dir=0 降序：若 a < b，则交换
     */
    uint32_t swap_if_asc  = ~a_lt_b;   /* a !< b -> 可能等于或大于 */
#if LAC_CFG_CT_BINLWE_PSI_STRICT_CMPXCHG
    uint32_t not_equal    = key_gt | key_lt |
                            ct_mask_nonzero_u32((uint32_t)(idx_a ^ idx_b));
#else
    uint32_t not_equal    = key_gt | key_lt | ((idx_a ^ idx_b) ? 0xffffffffu : 0u);
#endif
    swap_if_asc &= not_equal;

    uint32_t swap_if_desc = a_lt_b;

    uint32_t dir_mask = (uint32_t)(0u - (dir & 1u));
    uint32_t swap_mask = (swap_if_asc & dir_mask) | (swap_if_desc & ~dir_mask);

    ct_swap_u32(&a->key, &b->key, swap_mask);
    ct_swap_u16(&a->idx, &b->idx, swap_mask);
}

/*
 * bitonic sort 要求长度最好是 2 的幂。
 * 你的 vec_num 在当前参数集里本来就是 512/1024 这类值，通常满足。
 * 若未来参数集不是 2 的幂，可以 pad 到 next_pow2，再把补位元素 key 设成最大值。
 */
static void LAC_UNUSED_FN psi_bitonic_sort(psi_item_t *x, unsigned int n)
 {
    unsigned int k, j, i;

     for (k = 2; k <= n; k <<= 1) {
         for (j = k >> 1; j > 0; j >>= 1) {
             for (i = 0; i < n; i++) {
                 unsigned int l = i ^ j;
                 if (l > i) {
                     /* 方向由公开循环变量决定，不涉及秘密 */
                     uint32_t dir = ((i & k) == 0) ? 1u : 0u;
                     psi_item_compare_exchange(&x[i], &x[l], dir);
                 }
             }
         }
     }
 }
/*
 * 生成足够随机字节填充 key。
 * 这里只给骨架：直接沿用 pseudo_random_bytes。
 * 更严谨时可做 seed 扩展流，保证不同调用的 domain separation。
 */
static int fill_random_keys_scalar(psi_item_t *items, unsigned int vec_num, unsigned char *seed)
{
    unsigned int i;
    unsigned char buf[4 * vec_num];

    pseudo_random_bytes(buf, 4 * vec_num, seed);

	    for (i = 0; i < vec_num; i++) {
	        items[i].key = load_u32_le(buf + 4 * i);
	        items[i].idx = (uint16_t)i;
	    }
	    LAC_SECURE_CLEAR(buf, sizeof(buf));

	    return 0;
}

static int LAC_UNUSED_FN fill_random_keys(psi_item_t *items, unsigned int vec_num, unsigned char *seed)
{
    return fill_random_keys_scalar(items, vec_num, seed);
}

#if LAC_CFG_CT_NEON_AVAILABLE
static int fill_random_keys_ct_neon_soa(uint32_t *keys,
                                        uint16_t *idxs,
                                        unsigned int vec_num,
                                        unsigned char *seed)
{
    unsigned int i;
    unsigned char buf[4 * vec_num];
    const uint16x4_t idx_bias = {0u, 1u, 2u, 3u};

    if ((vec_num & 3u) != 0u) {
        return 1;
    }

    pseudo_random_bytes(buf, 4 * vec_num, seed);

    for (i = 0; i < vec_num; i += 4) {
        uint8x16_t bytes = vld1q_u8(buf + 4 * i);
        uint32x4_t key = vreinterpretq_u32_u8(bytes);
        uint16x4_t idx = vadd_u16(vdup_n_u16((uint16_t)i), idx_bias);

        vst1q_u32(keys + i, key);
        vst1_u16(idxs + i, idx);
    }

    LAC_SECURE_CLEAR(buf, sizeof(buf));
    return 0;
}

static inline void psi_vec_compare_exchange_u32(uint32x4_t key_a,
                                                uint32x4_t key_b,
                                                uint32x4_t idx_a,
                                                uint32x4_t idx_b,
                                                uint32x4_t dir_mask,
                                                uint32x4_t *new_key_a,
                                                uint32x4_t *new_key_b,
                                                uint32x4_t *new_idx_a,
                                                uint32x4_t *new_idx_b)
{
    uint32x4_t key_lt = vcltq_u32(key_a, key_b);
    uint32x4_t key_gt = vcltq_u32(key_b, key_a);
    uint32x4_t key_eq = vceqq_u32(key_a, key_b);
    uint32x4_t idx_lt = vcltq_u32(idx_a, idx_b);
    uint32x4_t idx_ne = vmvnq_u32(vceqq_u32(idx_a, idx_b));
    uint32x4_t a_lt_b = vorrq_u32(key_lt, vandq_u32(key_eq, idx_lt));
    uint32x4_t not_equal = vorrq_u32(vorrq_u32(key_lt, key_gt), idx_ne);
    uint32x4_t swap_if_asc = vandq_u32(vmvnq_u32(a_lt_b), not_equal);
    uint32x4_t swap_if_desc = a_lt_b;
    uint32x4_t swap_mask = vorrq_u32(vandq_u32(swap_if_asc, dir_mask),
                                     vandq_u32(swap_if_desc, vmvnq_u32(dir_mask)));

    *new_key_a = vbslq_u32(swap_mask, key_b, key_a);
    *new_key_b = vbslq_u32(swap_mask, key_a, key_b);
    *new_idx_a = vbslq_u32(swap_mask, idx_b, idx_a);
    *new_idx_b = vbslq_u32(swap_mask, idx_a, idx_b);
}

static inline void psi_sort_soa_step_j_ge4(uint32_t *keys,
                                           uint16_t *idxs,
                                           unsigned int i,
                                           unsigned int j,
                                           uint32_t dir)
{
    uint32x4_t key_a = vld1q_u32(keys + i);
    uint32x4_t key_b = vld1q_u32(keys + i + j);
    uint32x4_t idx_a = vmovl_u16(vld1_u16(idxs + i));
    uint32x4_t idx_b = vmovl_u16(vld1_u16(idxs + i + j));
    uint32x4_t new_key_a;
    uint32x4_t new_key_b;
    uint32x4_t new_idx_a;
    uint32x4_t new_idx_b;

    psi_vec_compare_exchange_u32(key_a, key_b, idx_a, idx_b,
                                 vdupq_n_u32(0u - (dir & 1u)),
                                 &new_key_a, &new_key_b,
                                 &new_idx_a, &new_idx_b);

    vst1q_u32(keys + i, new_key_a);
    vst1q_u32(keys + i + j, new_key_b);
    vst1_u16(idxs + i, vmovn_u32(new_idx_a));
    vst1_u16(idxs + i + j, vmovn_u32(new_idx_b));
}

static inline void psi_sort_soa_step_j2(uint32_t *keys,
                                        uint16_t *idxs,
                                        unsigned int i,
                                        uint32_t dir)
{
    uint32x2_t key_a2 = vld1_u32(keys + i);
    uint32x2_t key_b2 = vld1_u32(keys + i + 2u);
    uint16x4_t idx_a16 = {idxs[i], idxs[i + 1u], 0u, 0u};
    uint16x4_t idx_b16 = {idxs[i + 2u], idxs[i + 3u], 0u, 0u};
    uint32x4_t key_a = vcombine_u32(key_a2, vdup_n_u32(0));
    uint32x4_t key_b = vcombine_u32(key_b2, vdup_n_u32(0));
    uint32x4_t idx_a = vmovl_u16(idx_a16);
    uint32x4_t idx_b = vmovl_u16(idx_b16);
    uint32x4_t new_key_a;
    uint32x4_t new_key_b;
    uint32x4_t new_idx_a;
    uint32x4_t new_idx_b;
    uint16x8_t idx_pair;
    uint8x16_t idx_pair_bytes;
    uint8x16_t idx_out_bytes;
    const uint8x16_t idx_j2_sel = {0u, 1u, 2u, 3u, 8u, 9u, 10u, 11u,
                                   0xffu, 0xffu, 0xffu, 0xffu,
                                   0xffu, 0xffu, 0xffu, 0xffu};

    psi_vec_compare_exchange_u32(key_a, key_b, idx_a, idx_b,
                                 vdupq_n_u32(0u - (dir & 1u)),
                                 &new_key_a, &new_key_b,
                                 &new_idx_a, &new_idx_b);

    vst1_u32(keys + i, vget_low_u32(new_key_a));
    vst1_u32(keys + i + 2u, vget_low_u32(new_key_b));
    idx_pair = vcombine_u16(vmovn_u32(new_idx_a), vmovn_u32(new_idx_b));
    idx_pair_bytes = vreinterpretq_u8_u16(idx_pair);
    idx_out_bytes = vqtbl1q_u8(idx_pair_bytes, idx_j2_sel);
    vst1_u8((unsigned char *)(idxs + i), vget_low_u8(idx_out_bytes));
}

static inline void psi_sort_soa_step_j1(uint32_t *keys,
                                        uint16_t *idxs,
                                        unsigned int i,
                                        unsigned int k)
{
    uint32x4_t key = vld1q_u32(keys + i);
    uint16x4_t idx16 = vld1_u16(idxs + i);
    uint32x4_t key_a = vuzp1q_u32(key, key);
    uint32x4_t key_b = vuzp2q_u32(key, key);
    uint16x4_t idx_a16 = vuzp1_u16(idx16, idx16);
    uint16x4_t idx_b16 = vuzp2_u16(idx16, idx16);
    uint32x4_t idx_a = vmovl_u16(idx_a16);
    uint32x4_t idx_b = vmovl_u16(idx_b16);
    uint32_t dir0 = (((i + 0u) & k) == 0u) ? 0xffffffffu : 0u;
    uint32_t dir1 = (((i + 2u) & k) == 0u) ? 0xffffffffu : 0u;
    uint32_t dir_arr[4] = {dir0, dir1, 0u, 0u};
    uint32x4_t new_key_a;
    uint32x4_t new_key_b;
    uint32x4_t new_idx_a;
    uint32x4_t new_idx_b;
    uint32x4_t out_key;
    uint16x4_t out_idx16;

    psi_vec_compare_exchange_u32(key_a, key_b, idx_a, idx_b,
                                 vld1q_u32(dir_arr),
                                 &new_key_a, &new_key_b,
                                 &new_idx_a, &new_idx_b);

    out_key = vzip1q_u32(new_key_a, new_key_b);
    out_idx16 = vzip1_u16(vmovn_u32(new_idx_a), vmovn_u32(new_idx_b));
    vst1q_u32(keys + i, out_key);
    vst1_u16(idxs + i, out_idx16);
}

static void psi_bitonic_sort_soa_ct_neon(uint32_t *keys, uint16_t *idxs, unsigned int n)
{
    unsigned int k, j, block, off;

    for (k = 2; k <= n; k <<= 1) {
        for (j = k >> 1; j > 0; j >>= 1) {
            if (j >= 4u) {
                for (block = 0; block < n; block += (j << 1)) {
                    uint32_t dir = ((block & k) == 0u) ? 1u : 0u;
                    for (off = 0; off < j; off += 4u) {
                        psi_sort_soa_step_j_ge4(keys, idxs, block + off, j, dir);
                    }
                }
            } else if (j == 2u) {
                for (block = 0; block < n; block += 4u) {
                    uint32_t dir = ((block & k) == 0u) ? 1u : 0u;
                    psi_sort_soa_step_j2(keys, idxs, block, dir);
                }
            } else {
                for (block = 0; block < n; block += 4u) {
                    psi_sort_soa_step_j1(keys, idxs, block, k);
                }
            }
        }
    }
}

static int psi_writeback_ct_neon_soa(lac_small_t *e,
                                     unsigned int vec_num,
                                     const uint16_t *idxs,
                                     unsigned int bound1,
                                     unsigned int bound2)
{
    unsigned int i, k;
    const uint16x8_t one_u16 = vdupq_n_u16(1u);
    const uint16x8_t idx_lo_bias = {0u, 1u, 2u, 3u, 4u, 5u, 6u, 7u};
    const uint16x8_t idx_hi_bias = {8u, 9u, 10u, 11u, 12u, 13u, 14u, 15u};

    if ((vec_num & 15u) != 0u) {
        return 1;
    }

    for (i = 0; i < vec_num; i += 16) {
        uint16x8_t idx_base = vdupq_n_u16((uint16_t)i);
        uint16x8_t idx_lo_vec = vaddq_u16(idx_base, idx_lo_bias);
        uint16x8_t idx_hi_vec = vaddq_u16(idx_base, idx_hi_bias);
        int16x8_t val_lo = vdupq_n_s16(0);
        int16x8_t val_hi = vdupq_n_s16(0);

        for (k = 0; k < bound1; k++) {
            uint16x8_t idx_k = vdupq_n_u16(idxs[k]);
            uint16x8_t m_lo = vceqq_u16(idx_lo_vec, idx_k);
            uint16x8_t m_hi = vceqq_u16(idx_hi_vec, idx_k);
            int16x8_t add_lo = vreinterpretq_s16_u16(vandq_u16(m_lo, one_u16));
            int16x8_t add_hi = vreinterpretq_s16_u16(vandq_u16(m_hi, one_u16));
            val_lo = vaddq_s16(val_lo, add_lo);
            val_hi = vaddq_s16(val_hi, add_hi);
        }

        for (k = bound1; k < bound2; k++) {
            uint16x8_t idx_k = vdupq_n_u16(idxs[k]);
            uint16x8_t m_lo = vceqq_u16(idx_lo_vec, idx_k);
            uint16x8_t m_hi = vceqq_u16(idx_hi_vec, idx_k);
            int16x8_t sub_lo = vreinterpretq_s16_u16(vandq_u16(m_lo, one_u16));
            int16x8_t sub_hi = vreinterpretq_s16_u16(vandq_u16(m_hi, one_u16));
            val_lo = vsubq_s16(val_lo, sub_lo);
            val_hi = vsubq_s16(val_hi, sub_hi);
        }

        vst1q_s8((int8_t *)(e + i), vcombine_s8(vmovn_s16(val_lo),
                                                 vmovn_s16(val_hi)));
    }

    return 0;
}
#endif

/* 主函数：更标准的 CT 骨架 */
int gen_psi_fix_ham_ct(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
    int bound1, bound2;

    if (e == NULL || seed == NULL) {
        return 1;
    }

#if defined PSI_SQUARE
    bound1 = (int)(vec_num / 8);
    bound2 = (int)(vec_num / 4);
#else
    bound1 = (int)(vec_num / 4);
    bound2 = (int)(vec_num / 2);
#endif

    /*
     * 这里默认 vec_num 不超过 65535，因为 idx 用 uint16_t。
     * 对你当前 LAC 参数集够用。
     * 若以后 vec_num 可能更大，把 idx 改成 uint32_t。
     */
    if (vec_num > 65535u) {
        return 1;
    }

    /*
     * bitonic sort 最适合 n 为 2 的幂。
     * 如果你的参数集保证是 2 的幂，这里可直接用。
     * 若不保证，请做 next_pow2 padding。
     */
    {
        unsigned int t = vec_num;
        if ((t & (t - 1u)) != 0u) {
            return 1;  /* 骨架版先显式限制，后续可扩成 pad 版 */
        }
    }

#if LAC_CFG_CT_NEON_AVAILABLE
    {
        uint32_t keys[vec_num];
        uint16_t idxs[vec_num];

        if (fill_random_keys_ct_neon_soa(keys, idxs, vec_num, seed) != 0) {
            return 1;
        }

        psi_bitonic_sort_soa_ct_neon(keys, idxs, vec_num);

        if (psi_writeback_ct_neon_soa(e, vec_num, idxs,
                                      (unsigned int)bound1,
                                      (unsigned int)bound2) != 0) {
            LAC_SECURE_CLEAR(keys, sizeof(keys));
            LAC_SECURE_CLEAR(idxs, sizeof(idxs));
            return 1;
        }

        LAC_SECURE_CLEAR(keys, sizeof(keys));
        LAC_SECURE_CLEAR(idxs, sizeof(idxs));
    }
#else
    psi_item_t items[vec_num];

    /* 1) 为每个位置生成随机 key，idx = 位置编号 */
    fill_random_keys(items, vec_num, seed);

     /* 做完整排序 */
	psi_bitonic_sort(items, vec_num);

    {
        unsigned int i, k;
        for (i = 0; i < vec_num; i++) {
            int32_t val = 0;

            for (k = 0; k < (unsigned int)bound1; k++) {
                uint32_t m = ct_mask_eq_u32(i, (uint32_t)items[k].idx);
                val += (int32_t)(m & 1u);
            }

            for (k = (unsigned int)bound1; k < (unsigned int)bound2; k++) {
                uint32_t m = ct_mask_eq_u32(i, (uint32_t)items[k].idx);
                val -= (int32_t)(m & 1u);
            }

            e[i] = (lac_small_t)val;
        }
    }
	    LAC_SECURE_CLEAR(items, sizeof(items));
#endif

	    return 0;
	}


// poly_mul  b=as
#if !LAC_CFG_CT_BINLWE_SCALAR_MUL
static int poly_mul_scalar_orig(const unsigned char *a, const lac_small_t *s, unsigned char *b, unsigned int vec_num)
{
	int i,j;
	int16_t v[DIM_N+DIM_N],s0[DIM_N],s1[DIM_N];
	int64_t *v_p,*s0_p,*s1_p;
	int64_t sum0,sum1;
	int32_t gather0,gather1;
	
	//construct matrix of a
	memset(s0,0,DIM_N*2);
	memset(s1,0,DIM_N*2);
	for(i=0;i<DIM_N;i++)
	{
		v[i]=a[DIM_N-1-i];
		v[i+DIM_N]=Q-v[i];
		if(s[i]==-1)
			s0[i]=0xffff;
		if(s[i]==1)
			s1[i]=0xffff;
	}	
	
	for(i=0;i<vec_num;i++)
	{
		v_p=(int64_t*)(v+DIM_N-i-1);
		s0_p=(int64_t*)s0;
		s1_p=(int64_t*)s1;
		sum0=0;
		sum1=0;
		for(j=0;j<DIM_N;j+=32)
		{
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
		}
		gather0=((sum0&0xffff)+((sum0>>16)&0xffff)+((sum0>>32)&0xffff)+((sum0>>48)&0xffff));
		gather1=((sum1&0xffff)+((sum1>>16)&0xffff)+((sum1>>32)&0xffff)+((sum1>>48)&0xffff));
		b[i]=(gather1-gather0+BIG_Q)%Q;
	}
	
	return 0;
}
//b=as+e 
static int poly_aff_scalar_orig(const unsigned char *a, const lac_small_t *s, lac_small_t *e, unsigned char *b, unsigned int vec_num)
{
	int i,j;
	int16_t v[DIM_N+DIM_N],s0[DIM_N],s1[DIM_N];
	int64_t *v_p,*s0_p,*s1_p;
	int64_t sum0,sum1;
	int32_t gather0,gather1;
	
	//construct matrix of a
	memset(s0,0,DIM_N*2);
	memset(s1,0,DIM_N*2);
	for(i=0;i<DIM_N;i++)
	{
		v[i]=a[DIM_N-1-i];
		v[i+DIM_N]=Q-v[i];
		if(s[i]==-1)
			s0[i]=0xffff;
		if(s[i]==1)
			s1[i]=0xffff;
	}	
	
	for(i=0;i<vec_num;i++)
	{
		v_p=(int64_t*)(v+DIM_N-i-1);
		s0_p=(int64_t*)s0;
		s1_p=(int64_t*)s1;
		sum0=0;
		sum1=0;
		for(j=0;j<DIM_N;j+=32)
		{
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
			
			sum0+=((*v_p)&(*s0_p++));
			sum1+=((*v_p++)&(*s1_p++));
		}
		gather0=((sum0&0xffff)+((sum0>>16)&0xffff)+((sum0>>32)&0xffff)+((sum0>>48)&0xffff));
		gather1=((sum1&0xffff)+((sum1>>16)&0xffff)+((sum1>>32)&0xffff)+((sum1>>48)&0xffff));
		b[i]=(gather1-gather0+e[i]+BIG_Q)%Q;
	}
	
	return 0;
}
#endif

//恒定时间版（未进行SIMD化）
#if LAC_CFG_CT_BINLWE_SCALAR_MUL
/* 恒定时间辅助函数 */
static inline uint16_t ct_mask_eq_i16(int16_t x, int16_t y)
{
    uint16_t q = (uint16_t)(x ^ y);
    q |= (uint16_t)(0u - q);
    q >>= 15;
    q ^= 1u;
    return (uint16_t)(0u - q);
}



/*
 * 对当前 CT 标量路径，输入满足：
 *   x = gather1 - gather0 + BIG_Q (+ e[i])
 * 其中 |gather1-gather0| < DIM_N * Q，且 BIG_Q = 1024 * Q。
 * 在当前参数集 (DIM_N <= 1024) 下，恒有 x < 2048 * Q。
 *
 * 因此可用固定 12 轮的“按 2^k * Q 条件减法”完成约减。
 * 这里每轮都执行相同指令序列，不依赖秘密分支，也不需要
 * 额外证明 Barrett 近似商的误差界。
 */
static inline uint32_t ct_mask_ge_u32(uint32_t a, uint32_t b)
{
    return ~ct_mask_lt_u32(a, b);
}

static inline uint16_t mod_q_ct_bounded_u32(uint32_t x)
{
    unsigned int k;

    for (k = 12; k-- > 0;) {
        uint32_t qk = ((uint32_t)Q) << k;
        uint32_t mask = ct_mask_ge_u32(x, qk);
        x -= qk & mask;
    }

    return (uint16_t)x;
}

static void build_vs_masks(const unsigned char *a,
                           const lac_small_t *s,
                           int16_t *v,
                           uint16_t *s0,
                           uint16_t *s1)
{
#if LAC_CFG_CT_NEON_BINLWE_CORE
    unsigned int i;
    const uint16x8_t q_vec = vdupq_n_u16((uint16_t)Q);
    const int8x16_t neg_one = vdupq_n_s8(-1);
    const int8x16_t pos_one = vdupq_n_s8(1);

    for (i = 0; i < DIM_N; i += 16) {
        uint8x16_t a_src = vld1q_u8(a + DIM_N - i - 16u);
        uint8x16_t a_rev = vcombine_u8(vrev64_u8(vget_high_u8(a_src)),
                                       vrev64_u8(vget_low_u8(a_src)));
        uint16x8_t a_lo = vmovl_u8(vget_low_u8(a_rev));
        uint16x8_t a_hi = vmovl_u8(vget_high_u8(a_rev));
        uint16x8_t qa_lo = vsubq_u16(q_vec, a_lo);
        uint16x8_t qa_hi = vsubq_u16(q_vec, a_hi);
        int8x16_t s_vec = vld1q_s8((const int8_t *)(s + i));
        uint8x16_t s0_u8 = vreinterpretq_u8_s8(vceqq_s8(s_vec, neg_one));
        uint8x16_t s1_u8 = vreinterpretq_u8_s8(vceqq_s8(s_vec, pos_one));
        uint16x8_t s0_lo = vreinterpretq_u16_u8(vzip1q_u8(s0_u8, s0_u8));
        uint16x8_t s0_hi = vreinterpretq_u16_u8(vzip2q_u8(s0_u8, s0_u8));
        uint16x8_t s1_lo = vreinterpretq_u16_u8(vzip1q_u8(s1_u8, s1_u8));
        uint16x8_t s1_hi = vreinterpretq_u16_u8(vzip2q_u8(s1_u8, s1_u8));

        vst1q_s16(v + i, vreinterpretq_s16_u16(a_lo));
        vst1q_s16(v + i + 8u, vreinterpretq_s16_u16(a_hi));
        vst1q_s16(v + DIM_N + i, vreinterpretq_s16_u16(qa_lo));
        vst1q_s16(v + DIM_N + i + 8u, vreinterpretq_s16_u16(qa_hi));
        vst1q_u16(s0 + i, s0_lo);
        vst1q_u16(s0 + i + 8u, s0_hi);
        vst1q_u16(s1 + i, s1_lo);
        vst1q_u16(s1 + i + 8u, s1_hi);
    }
#else
    int i;
    memset(s0, 0, DIM_N * sizeof(uint16_t));
    memset(s1, 0, DIM_N * sizeof(uint16_t));

    for(i = 0; i < DIM_N; i++) {
        int16_t si = (int16_t)s[i];
        v[i] = a[DIM_N - 1 - i];
        v[i + DIM_N] = Q - v[i];
        s0[i] = ct_mask_eq_i16(si, -1);
        s1[i] = ct_mask_eq_i16(si,  1);
    }
#endif
}

static int poly_mul_scalar_ct(const unsigned char *a, const lac_small_t *s,
                       unsigned char *b, unsigned int vec_num)
{
    int i, j;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];

    build_vs_masks(a, s, v, s0, s1);

    for(i = 0; i < (int)vec_num; i++) {
        const int64_t *v_p  = (const int64_t *)(v + DIM_N - i - 1);
        const int64_t *s0_p = (const int64_t *)s0;
        const int64_t *s1_p = (const int64_t *)s1;
        int64_t sum0 = 0, sum1 = 0;

        for(j = 0; j < DIM_N; j += 32) {
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
            sum0 += ((*v_p) & (*s0_p++)); sum1 += ((*v_p++) & (*s1_p++));
        }

        int32_t gather0 = ((sum0 & 0xffff) + ((sum0 >> 16) & 0xffff)
                         + ((sum0 >> 32) & 0xffff) + ((sum0 >> 48) & 0xffff));
        int32_t gather1 = ((sum1 & 0xffff) + ((sum1 >> 16) & 0xffff)
                         + ((sum1 >> 32) & 0xffff) + ((sum1 >> 48) & 0xffff));
		uint32_t x = (uint32_t)(gather1 - gather0 + BIG_Q);
		
		//b[i]=(gather1-gather0+BIG_Q)%Q;
        b[i] = (unsigned char)mod_q_ct_bounded_u32(x);

       
    }

    return 0;
}

static int poly_aff_scalar_ct(const unsigned char *a, const lac_small_t *s,
                              lac_small_t *e, unsigned char *b,
                              unsigned int vec_num)
{
    int i, j;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];
    const int64_t *v_p, *s0_p, *s1_p;
    int64_t sum0, sum1;
    int32_t gather0, gather1;
   // int32_t x;

    if (a == NULL || s == NULL || e == NULL || b == NULL) {
        return 1;
    }

    /* 构造 v / s0 / s1 */
    memset(s0, 0, sizeof(s0));
    memset(s1, 0, sizeof(s1));

    for (i = 0; i < DIM_N; i++) {
        int16_t si = (int16_t)s[i];

        v[i] = a[DIM_N - 1 - i];
        v[i + DIM_N] = Q - v[i];

        /* 用恒定时间掩码代替秘密分支 */
        s0[i] = ct_mask_eq_i16(si, -1);
        s1[i] = ct_mask_eq_i16(si,  1);
    }

    for (i = 0; i < (int)vec_num; i++) {
        v_p  = (const int64_t *)(v + DIM_N - i - 1);
        s0_p = (const int64_t *)s0;
        s1_p = (const int64_t *)s1;
        sum0 = 0;
        sum1 = 0;

        for (j = 0; j < DIM_N; j += 32) {
            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));

            sum0 += ((*v_p) & (*s0_p++));
            sum1 += ((*v_p++) & (*s1_p++));
        }

        gather0 = (int32_t)((sum0 & 0xffff)
                 + ((sum0 >> 16) & 0xffff)
                 + ((sum0 >> 32) & 0xffff)
                 + ((sum0 >> 48) & 0xffff));

        gather1 = (int32_t)((sum1 & 0xffff)
                 + ((sum1 >> 16) & 0xffff)
                 + ((sum1 >> 32) & 0xffff)
                 + ((sum1 >> 48) & 0xffff));

   
        uint32_t x = (uint32_t)(gather1 - gather0 + (int32_t)e[i] + BIG_Q);
		//b[i]=(gather1-gather0+e[i]+BIG_Q)%Q;
        b[i] = (unsigned char)mod_q_ct_bounded_u32(x);
    }

    return 0;
}
#endif

static int LAC_UNUSED_FN poly_mul_scalar_backend(const unsigned char *a,
                                                 const lac_small_t *s,
                                                 unsigned char *b,
                                                 unsigned int vec_num)
{
#if LAC_CFG_CT_BINLWE_SCALAR_MUL
    return poly_mul_scalar_ct(a, s, b, vec_num);
#else
    return poly_mul_scalar_orig(a, s, b, vec_num);
#endif
}

static int LAC_UNUSED_FN poly_aff_scalar_backend(const unsigned char *a,
                                                 const lac_small_t *s,
                                                 lac_small_t *e,
                                                 unsigned char *b,
                                                 unsigned int vec_num)
{
#if LAC_CFG_CT_BINLWE_SCALAR_MUL
    return poly_aff_scalar_ct(a, s, e, b, vec_num);
#else
    return poly_aff_scalar_orig(a, s, e, b, vec_num);
#endif
}

#if LAC_CFG_CT_NEON_BINLWE_CORE
static inline uint16x4_t mod_q_ct_bounded_u32x4(uint32x4_t x)
{
    unsigned int k;

    for (k = 12; k-- > 0;) {
        uint32x4_t qk = vdupq_n_u32(((uint32_t)Q) << k);
        uint32x4_t mask = vcgeq_u32(x, qk);
        x = vsubq_u32(x, vandq_u32(qk, mask));
    }

    return vmovn_u32(x);
}

static inline uint32x4_t neon_hsum4_u32x4(uint32x4_t a,
                                          uint32x4_t b,
                                          uint32x4_t c,
                                          uint32x4_t d)
{
    uint32x4_t ab = vpaddq_u32(a, b);
    uint32x4_t cd = vpaddq_u32(c, d);
    return vpaddq_u32(ab, cd);
}

static inline void poly_ct_neon_gather4_vec(const int16_t *v_base0,
                                            const int16_t *v_base1,
                                            const int16_t *v_base2,
                                            const int16_t *v_base3,
                                            const uint16_t *s0,
                                            const uint16_t *s1,
                                            uint32x4_t *gather0,
                                            uint32x4_t *gather1)
{
    unsigned int j;
    const uint16_t *v0_u16 = (const uint16_t *)v_base0;
    const uint16_t *v1_u16 = (const uint16_t *)v_base1;
    const uint16_t *v2_u16 = (const uint16_t *)v_base2;
    const uint16_t *v3_u16 = (const uint16_t *)v_base3;
    uint32x4_t acc00 = vdupq_n_u32(0);
    uint32x4_t acc01 = vdupq_n_u32(0);
    uint32x4_t acc10 = vdupq_n_u32(0);
    uint32x4_t acc11 = vdupq_n_u32(0);
    uint32x4_t acc20 = vdupq_n_u32(0);
    uint32x4_t acc21 = vdupq_n_u32(0);
    uint32x4_t acc30 = vdupq_n_u32(0);
    uint32x4_t acc31 = vdupq_n_u32(0);

    for (j = 0; j < DIM_N; j += 8) {
        uint16x8_t v0_vec = vld1q_u16(v0_u16 + j);
        uint16x8_t v1_vec = vld1q_u16(v1_u16 + j);
        uint16x8_t v2_vec = vld1q_u16(v2_u16 + j);
        uint16x8_t v3_vec = vld1q_u16(v3_u16 + j);
        uint16x8_t s0_vec = vld1q_u16(s0 + j);
        uint16x8_t s1_vec = vld1q_u16(s1 + j);

        acc00 = vpadalq_u16(acc00, vandq_u16(v0_vec, s0_vec));
        acc01 = vpadalq_u16(acc01, vandq_u16(v0_vec, s1_vec));
        acc10 = vpadalq_u16(acc10, vandq_u16(v1_vec, s0_vec));
        acc11 = vpadalq_u16(acc11, vandq_u16(v1_vec, s1_vec));
        acc20 = vpadalq_u16(acc20, vandq_u16(v2_vec, s0_vec));
        acc21 = vpadalq_u16(acc21, vandq_u16(v2_vec, s1_vec));
        acc30 = vpadalq_u16(acc30, vandq_u16(v3_vec, s0_vec));
        acc31 = vpadalq_u16(acc31, vandq_u16(v3_vec, s1_vec));
    }

    *gather0 = neon_hsum4_u32x4(acc00, acc10, acc20, acc30);
    *gather1 = neon_hsum4_u32x4(acc01, acc11, acc21, acc31);
}

static int poly_mul_ct_neon_backend(const unsigned char *a, const lac_small_t *s,
                                    unsigned char *b, unsigned int vec_num)
{
    unsigned int i;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];

    build_vs_masks(a, s, v, s0, s1);

    for (i = 0; i + 3u < vec_num; i += 4) {
        uint32x4_t gather0;
        uint32x4_t gather1;
        uint32x4_t x_vec;
        uint8x8_t out_vec;

        poly_ct_neon_gather4_vec(v + DIM_N - i - 1,
                                 v + DIM_N - (i + 1u) - 1,
                                 v + DIM_N - (i + 2u) - 1,
                                 v + DIM_N - (i + 3u) - 1,
                                 s0, s1, &gather0, &gather1);
        x_vec = vreinterpretq_u32_s32(vaddq_s32(vsubq_s32(vreinterpretq_s32_u32(gather1),
                                                          vreinterpretq_s32_u32(gather0)),
                                                vdupq_n_s32(BIG_Q)));
        out_vec = vmovn_u16(vcombine_u16(mod_q_ct_bounded_u32x4(x_vec),
                                         vdup_n_u16(0)));
        vst1_lane_u8(b + i, out_vec, 0);
        vst1_lane_u8(b + i + 1u, out_vec, 1);
        vst1_lane_u8(b + i + 2u, out_vec, 2);
        vst1_lane_u8(b + i + 3u, out_vec, 3);
    }

    if (i < vec_num) {
        unsigned int rem = vec_num - i;
        const int16_t *v_base0 = v + DIM_N - i - 1;
        const int16_t *v_base1 = (rem > 1u) ? v + DIM_N - (i + 1u) - 1 : v_base0;
        const int16_t *v_base2 = (rem > 2u) ? v + DIM_N - (i + 2u) - 1 : v_base0;
        uint32x4_t gather0;
        uint32x4_t gather1;
        uint32x4_t x_vec;
        uint8x8_t out_vec;

        poly_ct_neon_gather4_vec(v_base0, v_base1, v_base2, v_base0,
                                 s0, s1, &gather0, &gather1);
        x_vec = vreinterpretq_u32_s32(vaddq_s32(vsubq_s32(vreinterpretq_s32_u32(gather1),
                                                          vreinterpretq_s32_u32(gather0)),
                                                vdupq_n_s32(BIG_Q)));
        out_vec = vmovn_u16(vcombine_u16(mod_q_ct_bounded_u32x4(x_vec),
                                         vdup_n_u16(0)));

        switch (rem) {
        case 3: vst1_lane_u8(b + i + 2u, out_vec, 2);
        case 2: vst1_lane_u8(b + i + 1u, out_vec, 1);
        case 1: vst1_lane_u8(b + i, out_vec, 0);
        default: break;
        }
    }

    return 0;
}

static int poly_aff_ct_neon_backend(const unsigned char *a, const lac_small_t *s,
                                    lac_small_t *e, unsigned char *b,
                                    unsigned int vec_num)
{
    unsigned int i;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];

    if (a == NULL || s == NULL || e == NULL || b == NULL) {
        return 1;
    }

    build_vs_masks(a, s, v, s0, s1);

    for (i = 0; i + 3u < vec_num; i += 4) {
        {
            uint32x4_t gather0;
            uint32x4_t gather1;
            int8x8_t e8 = {e[i], e[i + 1u], e[i + 2u], e[i + 3u],
                           0, 0, 0, 0};
            int32x4_t e32 = vmovl_s16(vget_low_s16(vmovl_s8(e8)));
            uint32x4_t x_vec;
            uint8x8_t out_vec;

            poly_ct_neon_gather4_vec(v + DIM_N - i - 1,
                                     v + DIM_N - (i + 1u) - 1,
                                     v + DIM_N - (i + 2u) - 1,
                                     v + DIM_N - (i + 3u) - 1,
                                     s0, s1, &gather0, &gather1);
            x_vec = vreinterpretq_u32_s32(vaddq_s32(vaddq_s32(vsubq_s32(vreinterpretq_s32_u32(gather1),
                                                                        vreinterpretq_s32_u32(gather0)),
                                                              e32),
                                                    vdupq_n_s32(BIG_Q)));
            out_vec = vmovn_u16(vcombine_u16(mod_q_ct_bounded_u32x4(x_vec),
                                             vdup_n_u16(0)));
            vst1_lane_u8(b + i, out_vec, 0);
            vst1_lane_u8(b + i + 1u, out_vec, 1);
            vst1_lane_u8(b + i + 2u, out_vec, 2);
            vst1_lane_u8(b + i + 3u, out_vec, 3);
        }
    }

    if (i < vec_num) {
        unsigned int rem = vec_num - i;
        const int16_t *v_base0 = v + DIM_N - i - 1;
        const int16_t *v_base1 = (rem > 1u) ? v + DIM_N - (i + 1u) - 1 : v_base0;
        const int16_t *v_base2 = (rem > 2u) ? v + DIM_N - (i + 2u) - 1 : v_base0;
        int8x8_t e8 = {e[i],
                       (rem > 1u) ? e[i + 1u] : 0,
                       (rem > 2u) ? e[i + 2u] : 0,
                       0, 0, 0, 0, 0};
        int32x4_t e32 = vmovl_s16(vget_low_s16(vmovl_s8(e8)));
        uint32x4_t gather0;
        uint32x4_t gather1;
        uint32x4_t x_vec;
        uint8x8_t out_vec;

        poly_ct_neon_gather4_vec(v_base0, v_base1, v_base2, v_base0,
                                 s0, s1, &gather0, &gather1);
        x_vec = vreinterpretq_u32_s32(vaddq_s32(vaddq_s32(vsubq_s32(vreinterpretq_s32_u32(gather1),
                                                                    vreinterpretq_s32_u32(gather0)),
                                                          e32),
                                                vdupq_n_s32(BIG_Q)));
        out_vec = vmovn_u16(vcombine_u16(mod_q_ct_bounded_u32x4(x_vec),
                                         vdup_n_u16(0)));

        switch (rem) {
        case 3: vst1_lane_u8(b + i + 2u, out_vec, 2);
        case 2: vst1_lane_u8(b + i + 1u, out_vec, 1);
        case 1: vst1_lane_u8(b + i, out_vec, 0);
        default: break;
        }
    }

    return 0;
}
#endif


int poly_mul(const unsigned char *a, const lac_small_t *s, unsigned char *b, unsigned int vec_num)
{
#if LAC_CFG_CT_NEON_BINLWE_CORE
    return poly_mul_ct_neon_backend(a, s, b, vec_num);
#else
    return poly_mul_scalar_backend(a, s, b, vec_num);
#endif
}

int poly_aff(const unsigned char *a, const lac_small_t *s, lac_small_t *e, unsigned char *b, unsigned int vec_num)
{
#if LAC_CFG_CT_NEON_BINLWE_CORE
    return poly_aff_ct_neon_backend(a, s, e, b, vec_num);
#else
    return poly_aff_scalar_backend(a, s, e, b, vec_num);
#endif
}

static int LAC_UNUSED_FN poly_compress_scalar(const unsigned char *in, unsigned char *out,
                                              unsigned int vec_num)
{
	int i,loop;
	loop=vec_num/2;
	for(i=0;i<loop;i++)
	{
		out[i]=(in[i*2]+0x08)>>4;
		out[i]=out[i]^((in[i*2+1]+0x08)&0xf0);
	}
	
	return 0;
}

#if LAC_CFG_CT_NEON_BINLWE_PACK
static inline uint8x8_t poly_compress4_ct_neon(const unsigned char *in,
                                               uint16x8_t add8)
{
    uint8x8_t src = vld1_u8(in);
    uint16x8_t rounded = vshrq_n_u16(vaddq_u16(vmovl_u8(src), add8), 4);
    uint8x8x2_t eo = vuzp_u8(vmovn_u16(rounded), vdup_n_u8(0));

    return vorr_u8(eo.val[0], vshl_n_u8(eo.val[1], 4));
}

static int poly_compress_ct_neon(const unsigned char *in, unsigned char *out,
                                 unsigned int vec_num)
{
    unsigned int i;
    unsigned int loop;
    const uint16x8_t add8 = vdupq_n_u16(0x08);

    if (in == NULL || out == NULL) {
        return 1;
    }
    if ((vec_num & 1u) != 0u) {
        return 1;
    }

    loop = vec_num >> 1; /* out bytes */
    for (i = 0; i + 8u <= loop; i += 8) {
        uint8x16_t src = vld1q_u8(in + (i << 1));
        uint16x8_t rounded_lo = vshrq_n_u16(vaddq_u16(vmovl_u8(vget_low_u8(src)), add8), 4);
        uint16x8_t rounded_hi = vshrq_n_u16(vaddq_u16(vmovl_u8(vget_high_u8(src)), add8), 4);
        uint8x8x2_t eo = vuzp_u8(vmovn_u16(rounded_lo), vmovn_u16(rounded_hi));
        uint8x8_t packed = veor_u8(eo.val[0], vshl_n_u8(eo.val[1], 4));
        vst1_u8(out + i, packed);
    }
    if (i < loop) {
        unsigned int rem = loop - i;

        if (rem >= 4u) {
            uint8x8_t packed4 = poly_compress4_ct_neon(in + (i << 1), add8);
            vst1_lane_u8(out + i, packed4, 0);
            vst1_lane_u8(out + i + 1u, packed4, 1);
            vst1_lane_u8(out + i + 2u, packed4, 2);
            vst1_lane_u8(out + i + 3u, packed4, 3);
            i += 4u;
            rem -= 4u;
        }

        while (rem != 0u) {
            out[i] = (unsigned char)((in[i * 2u] + 0x08u) >> 4);
            out[i] = (unsigned char)(out[i] ^ ((in[i * 2u + 1u] + 0x08u) & 0xf0u));
            i++;
            rem--;
        }
    }

    return 0;
}
#endif

// compress: cut the low 4bit
int poly_compress(const unsigned char *in, unsigned char *out,
                  const unsigned int vec_num)
{
#if LAC_CFG_CT_NEON_BINLWE_PACK
    return poly_compress_ct_neon(in, out, vec_num);
#else
    return poly_compress_scalar(in, out, vec_num);
#endif
}

static int LAC_UNUSED_FN poly_decompress_scalar(const unsigned char *in, unsigned char *out,
                                                unsigned int vec_num)
{
	int i,loop;
	loop=vec_num/2;
	for(i=0;i<loop;i++)
	{
		out[i*2]=in[i]<<4;
		out[i*2+1]=in[i]&0xf0;
	}
	
	return 0;
}

#if LAC_CFG_CT_NEON_BINLWE_PACK
static inline uint8x16_t poly_decompress4_ct_neon(const unsigned char *in,
                                                  uint8x8_t hi_mask)
{
    uint8x8_t src = vdup_n_u8(0);
    uint8x8_t even;
    uint8x8_t odd;
    uint8x8x2_t inter;

    src = vld1_lane_u8(in, src, 0);
    src = vld1_lane_u8(in + 1u, src, 1);
    src = vld1_lane_u8(in + 2u, src, 2);
    src = vld1_lane_u8(in + 3u, src, 3);

    even = vshl_n_u8(src, 4);
    odd = vand_u8(src, hi_mask);
    inter = vzip_u8(even, odd);

    return vcombine_u8(inter.val[0], inter.val[1]);
}

static int poly_decompress_ct_neon(const unsigned char *in, unsigned char *out,
                                   unsigned int vec_num)
{
    unsigned int i;
    unsigned int loop;
    const uint8x8_t hi_mask = vdup_n_u8(0xF0);

    if (in == NULL || out == NULL) {
        return 1;
    }
    if ((vec_num & 1u) != 0u) {
        return 1;
    }

    loop = vec_num >> 1; /* in bytes */
    for (i = 0; i + 8u <= loop; i += 8) {
        uint8x8_t src = vld1_u8(in + i);
        uint8x8_t even = vshl_n_u8(src, 4);
        uint8x8_t odd = vand_u8(src, hi_mask);
        uint8x8x2_t inter = vzip_u8(even, odd);
        vst1q_u8(out + (i << 1), vcombine_u8(inter.val[0], inter.val[1]));
    }
    if (i < loop) {
        unsigned int rem = loop - i;

        if (rem >= 4u) {
            vst1_u8(out + (i << 1), vget_low_u8(poly_decompress4_ct_neon(in + i, hi_mask)));
            i += 4u;
            rem -= 4u;
        }

        while (rem != 0u) {
            out[i * 2u] = (unsigned char)(in[i] << 4);
            out[i * 2u + 1u] = (unsigned char)(in[i] & 0xf0u);
            i++;
            rem--;
        }
    }

    return 0;
}
#endif

// decompress: set the low 4bits to be 0
int poly_decompress(const unsigned char *in, unsigned char *out,
                    const unsigned int vec_num)
{
#if LAC_CFG_CT_NEON_BINLWE_PACK
    return poly_decompress_ct_neon(in, out, vec_num);
#else
    return poly_decompress_scalar(in, out, vec_num);
#endif
}

