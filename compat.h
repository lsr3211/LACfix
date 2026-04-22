#ifndef COMPAT_H
#define COMPAT_H

#ifdef LAC_SIGNED_CHAR
typedef signed char lac_small_t;
#else
typedef char lac_small_t;
#endif

#ifndef SIMD_CONFIG_H
#define SIMD_CONFIG_H

/* 总开关：是否启用 ARM NEON 实现 */
#ifndef LAC_USE_NEON
#define LAC_USE_NEON 0
#endif

#if defined(__aarch64__) || defined(__ARM_NEON) || defined(__ARM_NEON__)
#define LAC_NEON_AVAILABLE 1
#else
#define LAC_NEON_AVAILABLE 0
#endif

#if LAC_USE_NEON && LAC_NEON_AVAILABLE
#define LAC_USE_NEON_IMPL 1
#else
#define LAC_USE_NEON_IMPL 0
#endif

#endif


#ifndef CT_CONFIG_H
#define CT_CONFIG_H

/* 是否启用恒定时间标准版实现 */
#ifndef LAC_USE_CT_SCALAR
#define LAC_USE_CT_SCALAR 1
#endif

/* 是否启用bin-lwe中的gen_psi_fix_ham恒定时间版实现 */
#ifndef LAC_USE_CT_PSI_FIX_HAM
#define LAC_USE_CT_PSI_FIX_HAM 1
#endif

/* 是否启用bch中的恒定时间版实现 */
#ifndef LAC_USE_CT_BCH
#define LAC_USE_CT_BCH 1
#endif

/* kem_dec_fo 是否启用 CT verify + conditional select */
#ifndef LAC_USE_CT_KEM_DEC
#define LAC_USE_CT_KEM_DEC 1
#endif

/* pke_dec 阈值恢复阶段是否启用 CT 掩码写法 */
#ifndef LAC_USE_CT_PKE_DEC
#define LAC_USE_CT_PKE_DEC 1
#endif

/* 高优先级1：pseudo_random_bytes 尾块拷贝偏移修复 */
#ifndef LAC_FIX_RAND_TAIL_COPY
#define LAC_FIX_RAND_TAIL_COPY 1
#endif

/* 高优先级2：ecc_dec 纠错阶段是否使用固定迭代 + 掩码写法 */
#ifndef LAC_USE_CT_ECC_CORRECT
#define LAC_USE_CT_ECC_CORRECT 1
#endif

/* 高优先级4：pke_dec 中 c2-out 的模 q 还原是否使用 CT 减法约减 */
#ifndef LAC_USE_CT_PKE_SUBMODQ
#define LAC_USE_CT_PKE_SUBMODQ 1
#endif

/* 高优先级5：gen_psi_fix_ham_ct compare-exchange 中是否使用严格掩码写法 */
#ifndef LAC_USE_CT_PSI_CMPXCHG_STRICT
#define LAC_USE_CT_PSI_CMPXCHG_STRICT 1
#endif

/* syndrome阶段是否用CT方式替代a_pow查表，便于A/B对比测试 */
#ifndef LAC_USE_CT_BCH_SYNDROME_APOW
#define LAC_USE_CT_BCH_SYNDROME_APOW 0
#endif

/* 高优先级3：当启用 CT-BCH 时，默认强制启用 CT syndrome a_pow 路径 */
#ifndef LAC_FORCE_CT_BCH_SYNDROME_APOW_WHEN_CT_BCH
#define LAC_FORCE_CT_BCH_SYNDROME_APOW_WHEN_CT_BCH 1
#endif

#if LAC_USE_CT_BCH && LAC_FORCE_CT_BCH_SYNDROME_APOW_WHEN_CT_BCH
#undef LAC_USE_CT_BCH_SYNDROME_APOW
#define LAC_USE_CT_BCH_SYNDROME_APOW 1
#endif

#if LAC_USE_CT_BCH
#ifndef BCH_CONSTANT_TIME
#define BCH_CONSTANT_TIME 1
#endif
#endif

#endif
#endif
