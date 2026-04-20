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
#define LAC_USE_CT_BCH 0
#endif

#if LAC_USE_CT_BCH
#ifndef BCH_CONSTANT_TIME
#define BCH_CONSTANT_TIME 1
#endif
#endif

#endif
#endif
