
#include <string.h>
#include "bin-lwe.h"
#include "rand.h"
#include "lac_param.h"
#include <stdio.h>
#include <stdint.h>
#include "compat.h"




#if LAC_USE_NEON_IMPL
#include <arm_neon.h>
#endif

//generate the public parameter a from seed
int gen_a(unsigned char *a,  const unsigned char *seed)
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
	
	return 0;
}
 
//generate the small random vector for secret and error, with fixed hamming weight
int gen_psi_fix_ham(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
	#if LAC_USE_CT_PSI_FIX_HAM
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
	
	return 0;
	#endif
}

//generate the small random vector for secret and error
int gen_psi_std(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
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

	#endif
	
	return 0;
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

/* cond = 0xffffffff => select x, else select y */
static inline uint32_t ct_select_u32(uint32_t cond, uint32_t x, uint32_t y)
{
    return (x & cond) | (y & ~cond);
}

static inline uint16_t ct_select_u16(uint32_t cond, uint16_t x, uint16_t y)
{
    uint16_t m = (uint16_t)cond;
    return (uint16_t)((x & m) | (y & ~m));
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

static inline uint32_t psi_item_lt_mask(const psi_item_t *a, const psi_item_t *b)
{
    uint32_t key_lt = ct_mask_lt_u32(a->key, b->key);
    uint32_t key_gt = ct_mask_lt_u32(b->key, a->key);
    uint32_t key_eq = ct_mask_eq_u32(a->key, b->key);
    uint32_t idx_lt = ct_mask_lt_u32((uint32_t)a->idx, (uint32_t)b->idx);

    /* a < b 当且仅当 key_a < key_b，或 key 相等但 idx_a < idx_b */
    return key_lt | (key_eq & idx_lt);
}
static inline void psi_item_minmax(psi_item_t *a, psi_item_t *b)
{
    /* 若 b < a，则交换；否则不动 */
    uint32_t b_lt_a = psi_item_lt_mask(b, a);

    ct_swap_u32(&a->key, &b->key, b_lt_a);
    ct_swap_u16(&a->idx, &b->idx, b_lt_a);
}


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
#if LAC_USE_CT_PSI_CMPXCHG_STRICT
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
static void psi_bitonic_sort(psi_item_t *x, unsigned int n)
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
static void psi_partial_select_smallest(psi_item_t *items,
                                        unsigned int n,
                                        unsigned int topk)
{
    unsigned int r, j;

    if (topk > n) topk = n;

    for (r = 0; r < topk; r++) {
        /*
         * 目标：
         * 把 items[r..n-1] 中最小的元素“冒”到 items[r]
         *
         * 固定流程做法：
         * 让 items[r] 依次和后面每个元素做 minmax，
         * 每次都把更小者留在 items[r]。
         */
        for (j = r + 1; j < n; j++) {
            psi_item_minmax(&items[r], &items[j]);
        }
    }
}
/*
 * 生成足够随机字节填充 key。
 * 这里只给骨架：直接沿用 pseudo_random_bytes。
 * 更严谨时可做 seed 扩展流，保证不同调用的 domain separation。
 */
static int fill_random_keys(psi_item_t *items, unsigned int vec_num, unsigned char *seed)
{
    unsigned int i;
    unsigned char buf[4 * vec_num];

    pseudo_random_bytes(buf, 4 * vec_num, seed);

    for (i = 0; i < vec_num; i++) {
        items[i].key = load_u32_le(buf + 4 * i);
        items[i].idx = (uint16_t)i;
    }

    return 0;
}

/* 主函数：更标准的 CT 骨架 */
int gen_psi_fix_ham_ct(lac_small_t *e, unsigned int vec_num, unsigned char *seed)
{
    unsigned int i, k;
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

    psi_item_t items[vec_num];

    /* 1) 为每个位置生成随机 key，idx = 位置编号 */
    fill_random_keys(items, vec_num, seed);

     /* 做完整排序 */
	psi_bitonic_sort(items, vec_num);

    /* 3) 固定扫描写回，避免 e[items[k].idx] = ... 这种数据相关写地址 */
    for (i = 0; i < vec_num; i++) {
        int32_t val = 0;

        /* 前 bound1 个为 +1 */
        for (k = 0; k < (unsigned int)bound1; k++) {
            uint32_t m = ct_mask_eq_u32(i, (uint32_t)items[k].idx);
            val += (int32_t)(m & 1u);
        }

        /* 后面 [bound1, bound2) 为 -1 */
        for (k = (unsigned int)bound1; k < (unsigned int)bound2; k++) {
            uint32_t m = ct_mask_eq_u32(i, (uint32_t)items[k].idx);
            val -= (int32_t)(m & 1u);
        }

        e[i] = (lac_small_t)val;
    }

    return 0;
}


// poly_mul  b=as
#if !LAC_USE_CT_SCALAR
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
#if LAC_USE_CT_SCALAR
/* 恒定时间辅助函数 */
static inline uint16_t ct_mask_eq_i16(int16_t x, int16_t y)
{
    uint16_t q = (uint16_t)(x ^ y);
    q |= (uint16_t)(0u - q);
    q >>= 15;
    q ^= 1u;
    return (uint16_t)(0u - q);
}



static inline int32_t ct_cond_sub_q(int32_t x, int32_t q)
{
    int32_t t = x - q;
    return t + ((t >> 31) & q);
}

/* 需要根据 Q 选取 SHIFT 和 MU */
#define BARRETT_SHIFT 24
#define BARRETT_MU (((uint64_t)1 << BARRETT_SHIFT) / Q)

static inline uint16_t mod_q_barrett_ct_u32(uint32_t x)
{
    uint32_t qhat;
    uint32_t r;

    /* 近似商 */
    qhat = (uint32_t)(((uint64_t)x * (uint64_t)BARRETT_MU) >> BARRETT_SHIFT);

    /* 初步余数 */
    r = x - qhat * Q;

    /*
     * 固定次数修正
     * 如果参数取得合适，通常做 2~3 次条件减法就够
     */
    r = (uint32_t)ct_cond_sub_q((int32_t)r, Q);
    r = (uint32_t)ct_cond_sub_q((int32_t)r, Q);
    r = (uint32_t)ct_cond_sub_q((int32_t)r, Q);

    return (uint16_t)r;
}

static inline int32_t ct_cond_add_q(int32_t x, int32_t q)
{
    return x + ((x >> 31) & q);
}

static void build_vs_masks(const unsigned char *a,
                           const lac_small_t *s,
                           int16_t *v,
                           uint16_t *s0,
                           uint16_t *s1)
{
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
        b[i] = (unsigned char)mod_q_barrett_ct_u32(x);

       
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
        b[i] = (unsigned char)mod_q_barrett_ct_u32(x);
    }

    return 0;
}
#endif


int poly_mul(const unsigned char *a, const lac_small_t *s, unsigned char *b, unsigned int vec_num)
{
#if LAC_USE_NEON_IMPL
    return poly_mul_neon(a, s, b, vec_num);
#else
#if LAC_USE_CT_SCALAR
    return poly_mul_scalar_ct(a, s, b, vec_num);
#else
    return poly_mul_scalar_orig(a, s, b, vec_num);
#endif
#endif
}

int poly_aff(const unsigned char *a, const lac_small_t *s, lac_small_t *e, unsigned char *b, unsigned int vec_num)
{
#if LAC_USE_NEON_IMPL
    return poly_aff_neon(a, s, e, b, vec_num);
#else
#if LAC_USE_CT_SCALAR
    return poly_aff_scalar_ct(a, s, e, b, vec_num);
#else
    return poly_aff_scalar_orig(a, s, e, b, vec_num);
#endif
#endif
}







//NEON版
#if LAC_USE_NEON_IMPL
//向量横向求和
static inline uint32_t hsum_u32x4(uint32x4_t x)
{
    return vaddvq_u32(x);
}

static int poly_mul_neon(const unsigned char *a, const lac_small_t *s, unsigned char *b, unsigned int vec_num)
{
    int i, j;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];

    if (a == NULL || s == NULL || b == NULL) {
        return 1;
    }

    /* 1. 保留原始预处理：构造 v / s0 / s1 */
    memset(s0, 0, sizeof(s0));
    memset(s1, 0, sizeof(s1));

    for (i = 0; i < DIM_N; i++) {
        v[i] = a[DIM_N - 1 - i];
        v[i + DIM_N] = Q - v[i];

        if (s[i] == -1) s0[i] = 0xffff;
        if (s[i] ==  1) s1[i] = 0xffff;
    }

    /* 2. 外层仍然逐个生成 b[i] */
    for (i = 0; i < (int)vec_num; i++) {
        const uint16_t *vp  = (const uint16_t *)(v + DIM_N - i - 1);
        const uint16_t *m0p = (const uint16_t *)s0;
        const uint16_t *m1p = (const uint16_t *)s1;

        uint32x4_t acc0_lo = vdupq_n_u32(0);
        uint32x4_t acc0_hi = vdupq_n_u32(0);
        uint32x4_t acc1_lo = vdupq_n_u32(0);
        uint32x4_t acc1_hi = vdupq_n_u32(0);

        /* 3. 内层按 32 个系数一组，和原代码步调保持一致 */
        for (j = 0; j < DIM_N; j += 32) {
            int blk;
            for (blk = 0; blk < 4; blk++) {
                /* 每次加载 8 个 16-bit lane */
                uint16x8_t vv  = vld1q_u16(vp);   vp  += 8;
                uint16x8_t mm0 = vld1q_u16(m0p);  m0p += 8;
                uint16x8_t mm1 = vld1q_u16(m1p);  m1p += 8;

                /* 对应原始代码里的 (&) 掩码筛选 */
                uint16x8_t t0 = vandq_u16(vv, mm0);
                uint16x8_t t1 = vandq_u16(vv, mm1);

                /* 扩位到 32-bit 后累加 */
                acc0_lo = vaddq_u32(acc0_lo, vmovl_u16(vget_low_u16(t0)));
                acc0_hi = vaddq_u32(acc0_hi, vmovl_u16(vget_high_u16(t0)));
                acc1_lo = vaddq_u32(acc1_lo, vmovl_u16(vget_low_u16(t1)));
                acc1_hi = vaddq_u32(acc1_hi, vmovl_u16(vget_high_u16(t1)));
            }
        }

        /* 4. 横向归约，对应原代码最后的 gather0/gather1 */
        {
            uint32x4_t sum0 = vaddq_u32(acc0_lo, acc0_hi);
            uint32x4_t sum1 = vaddq_u32(acc1_lo, acc1_hi);

            uint32_t gather0 = hsum_u32x4(sum0);
            uint32_t gather1 = hsum_u32x4(sum1);

            b[i] = (gather1 - gather0 + BIG_Q) % Q;
        }
    }

    return 0;
}

static int poly_aff_neon(const unsigned char *a, const lac_small_t *s, lac_small_t *e, unsigned char *b, unsigned int vec_num)
{
    int i, j;
    int16_t v[DIM_N + DIM_N];
    uint16_t s0[DIM_N], s1[DIM_N];

    if (a == NULL || s == NULL || e == NULL || b == NULL) {
        return 1;
    }

    memset(s0, 0, sizeof(s0));
    memset(s1, 0, sizeof(s1));

    for (i = 0; i < DIM_N; i++) {
        v[i] = a[DIM_N - 1 - i];
        v[i + DIM_N] = Q - v[i];

        if (s[i] == -1) s0[i] = 0xffff;
        if (s[i] ==  1) s1[i] = 0xffff;
    }

    for (i = 0; i < (int)vec_num; i++) {
        const uint16_t *vp  = (const uint16_t *)(v + DIM_N - i - 1);
        const uint16_t *m0p = (const uint16_t *)s0;
        const uint16_t *m1p = (const uint16_t *)s1;

        uint32x4_t acc0_lo = vdupq_n_u32(0);
        uint32x4_t acc0_hi = vdupq_n_u32(0);
        uint32x4_t acc1_lo = vdupq_n_u32(0);
        uint32x4_t acc1_hi = vdupq_n_u32(0);

        for (j = 0; j < DIM_N; j += 32) {
            int blk;
            for (blk = 0; blk < 4; blk++) {
                uint16x8_t vv  = vld1q_u16(vp);   vp  += 8;
                uint16x8_t mm0 = vld1q_u16(m0p);  m0p += 8;
                uint16x8_t mm1 = vld1q_u16(m1p);  m1p += 8;

                uint16x8_t t0 = vandq_u16(vv, mm0);
                uint16x8_t t1 = vandq_u16(vv, mm1);

                acc0_lo = vaddq_u32(acc0_lo, vmovl_u16(vget_low_u16(t0)));
                acc0_hi = vaddq_u32(acc0_hi, vmovl_u16(vget_high_u16(t0)));
                acc1_lo = vaddq_u32(acc1_lo, vmovl_u16(vget_low_u16(t1)));
                acc1_hi = vaddq_u32(acc1_hi, vmovl_u16(vget_high_u16(t1)));
            }
        }

        {
            uint32x4_t sum0 = vaddq_u32(acc0_lo, acc0_hi);
            uint32x4_t sum1 = vaddq_u32(acc1_lo, acc1_hi);

            uint32_t gather0 = hsum_u32x4(sum0);
            uint32_t gather1 = hsum_u32x4(sum1);

            b[i] = (gather1 - gather0 + e[i] + BIG_Q) % Q;
        }
    }

    return 0;
}
#endif

// compress: cut the low 4bit
int poly_compress(const unsigned char *in,  unsigned char *out, const unsigned int vec_num)
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
// decompress: set the low 4bits to be 0
int poly_decompress(const unsigned char *in,  unsigned char *out, const unsigned int vec_num)
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

