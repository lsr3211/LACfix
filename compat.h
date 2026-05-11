#ifndef COMPAT_H
#define COMPAT_H

#include <stddef.h>

/* 小系数向量元素类型。
 * 默认使用 char；若编译时定义 LAC_SIGNED_CHAR，则显式使用 signed char，
 * 避免不同平台上 plain char 的 signedness 差异影响 -1/0/1 的表示。 */
#ifdef LAC_SIGNED_CHAR
typedef signed char lac_small_t;
#else
typedef char lac_small_t;
#endif

#ifndef CT_CONFIG_H
#define CT_CONFIG_H

/* ===== CT / 修复 / 安全清理配置入口 =====
 * 本文件是项目唯一的统一配置入口。
 *
 * 结构分成三层：
 * 1. STD / CT 两档总控：LAC_CONFIG_PROFILE
 * 2. 规范配置宏：统一给项目源码使用
 * 3. 派生宏与工具宏：例如 BCH_CONSTANT_TIME、LAC_SECURE_CLEAR
 *
 * 约定：
 * - 1 表示启用该能力
 * - 0 表示关闭该能力，退回标准/原始实现
 *
 * 兼容策略：
 * - 默认 profile 为 CT
 * - 若编译命令显式传入规范宏，则优先尊重规范宏
 * - 若未显式传入规范宏，则由 profile 自动给出默认值
 */

/* ===== 第一层：STD / CT / CT-NEON 三档总控 =====
 * LAC_PROFILE_STD: 标准/原始实现优先，CT 相关路径默认关闭
 * LAC_PROFILE_CT : 常数时间实现优先，CT 相关路径默认开启
 * LAC_PROFILE_CT_NEON: 在 CT 基线上进一步启用 NEON 后端
 */
#define LAC_PROFILE_STD      0
#define LAC_PROFILE_CT       1
#define LAC_PROFILE_CT_NEON  2

/* 当前默认档位。
 * 若外部未指定，则默认使用 CT 档。 */
#ifndef LAC_CONFIG_PROFILE
#define LAC_CONFIG_PROFILE LAC_PROFILE_CT
#endif

/* 当前 profile 是否包含 CT 语义。CT-NEON 也继承 CT 基线。 */
#if (LAC_CONFIG_PROFILE == LAC_PROFILE_CT) || \
    (LAC_CONFIG_PROFILE == LAC_PROFILE_CT_NEON)
#define LAC_PROFILE_IS_CT 1
#else
#define LAC_PROFILE_IS_CT 0
#endif

/* 当前 profile 是否为 CT-NEON 档。 */
#if LAC_CONFIG_PROFILE == LAC_PROFILE_CT_NEON
#define LAC_PROFILE_IS_CT_NEON 1
#else
#define LAC_PROFILE_IS_CT_NEON 0
#endif

/* ===== 第二层：规范配置宏 =====
 * 这些宏是项目内部建议直接使用的“规范名字”。
 * 派生优先级：
 * 1. 外部显式传入规范宏
 * 2. 根据 LAC_CONFIG_PROFILE 自动给默认值
 */

/* --- bin-lwe.c --- */

/* 控制 poly_mul/poly_aff 是否使用 CT 标量实现。 */
#ifndef LAC_CFG_CT_BINLWE_SCALAR_MUL
#define LAC_CFG_CT_BINLWE_SCALAR_MUL LAC_PROFILE_IS_CT
#endif

/* 控制 gen_psi_fix_ham 是否切换到 gen_psi_fix_ham_ct。 */
#ifndef LAC_CFG_CT_BINLWE_PSI_FIXED
#define LAC_CFG_CT_BINLWE_PSI_FIXED LAC_PROFILE_IS_CT
#endif

/* 控制 gen_psi_fix_ham_ct 内 compare-exchange 是否使用更严格掩码。
 * 只有在启用 LAC_CFG_CT_BINLWE_PSI_FIXED 时才有实际意义。 */
#ifndef LAC_CFG_CT_BINLWE_PSI_STRICT_CMPXCHG
#define LAC_CFG_CT_BINLWE_PSI_STRICT_CMPXCHG LAC_PROFILE_IS_CT
#endif

/* --- bch.c --- */

/* 控制 BCH 解码主流程是否走 CT 实现。 */
#ifndef LAC_CFG_CT_BCH
#define LAC_CFG_CT_BCH LAC_PROFILE_IS_CT
#endif

/* 控制 syndrome 阶段是否也把 a_pow 查表替换成 CT 版本。 */
#ifndef LAC_CFG_CT_BCH_SYNDROME_APOW
#define LAC_CFG_CT_BCH_SYNDROME_APOW LAC_PROFILE_IS_CT
#endif

/* 控制当 CT-BCH 打开时，是否强制把 syndrome a_pow 路径也推成 CT。 */
#ifndef LAC_CFG_CT_BCH_FORCE_SYNDROME_APOW
#define LAC_CFG_CT_BCH_FORCE_SYNDROME_APOW LAC_PROFILE_IS_CT
#endif

/* --- kem.c --- */

/* 控制 kem_dec_fo 是否使用 CT verify + conditional select。 */
#ifndef LAC_CFG_CT_KEM_DEC_VERIFY
#define LAC_CFG_CT_KEM_DEC_VERIFY LAC_PROFILE_IS_CT
#endif

/* --- encrypt.c --- */

/* 控制 pke_dec 的阈值恢复是否使用 CT 掩码写法。 */
#ifndef LAC_CFG_CT_PKE_THRESHOLD_DEC
#define LAC_CFG_CT_PKE_THRESHOLD_DEC LAC_PROFILE_IS_CT
#endif

/* 控制 pke_dec 中 c2-out 的模 q 还原是否使用 CT 约减。 */
#ifndef LAC_CFG_CT_PKE_SUBMODQ
#define LAC_CFG_CT_PKE_SUBMODQ LAC_PROFILE_IS_CT
#endif

/* 控制 pke_enc_seed 中 message 注入 e2 是否走 CT 标量路径。
 * 当前 CT 标量与 STD 逻辑等价，但保留独立开关，便于和 CT-NEON 对齐。 */
#ifndef LAC_CFG_CT_PKE_MESSAGE_ADD
#define LAC_CFG_CT_PKE_MESSAGE_ADD LAC_PROFILE_IS_CT
#endif

/* --- ecc.c --- */

/* 控制 ecc_dec 的纠错写回是否使用固定迭代 + 掩码。 */
#ifndef LAC_CFG_CT_ECC_CORRECT
#define LAC_CFG_CT_ECC_CORRECT LAC_PROFILE_IS_CT
#endif

/* --- ecc.c CT-NEON 配置 --- */

#ifndef LAC_CFG_CT_NEON_ECC
#define LAC_CFG_CT_NEON_ECC LAC_CFG_CT_NEON_AVAILABLE
#endif

#ifndef LAC_CFG_CT_NEON_ECC_CORRECT
#define LAC_CFG_CT_NEON_ECC_CORRECT LAC_CFG_CT_NEON_ECC
#endif

/* --- CT-NEON 配置 --- */

/* 总控：允许在 CT 基线上切到 CT-NEON 后端。 */
#ifndef LAC_CFG_CT_NEON
#define LAC_CFG_CT_NEON LAC_PROFILE_IS_CT_NEON
#endif

/* 只有在打开 CT-NEON 且编译器/目标平台支持 NEON 时，才真正启用。 */
#ifndef LAC_CFG_CT_NEON_AVAILABLE
#if LAC_CFG_CT_NEON && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#define LAC_CFG_CT_NEON_AVAILABLE 1
#else
#define LAC_CFG_CT_NEON_AVAILABLE 0
#endif
#endif

/* bin-lwe 核心乘加路径：
 * 这是当前最适合先做 CT-NEON 的热点。 */
#ifndef LAC_CFG_CT_NEON_BINLWE_CORE
#define LAC_CFG_CT_NEON_BINLWE_CORE LAC_CFG_CT_NEON_AVAILABLE
#endif

/* bin-lwe 打包/解包路径：
 * 吞吐友好，适合作为第二批 CT-NEON 小改动。 */
#ifndef LAC_CFG_CT_NEON_BINLWE_PACK
#define LAC_CFG_CT_NEON_BINLWE_PACK LAC_CFG_CT_NEON_AVAILABLE
#endif

/* encrypt.c 阈值恢复与 message 注入路径。 */
#ifndef LAC_CFG_CT_NEON_ENCRYPT
#define LAC_CFG_CT_NEON_ENCRYPT LAC_CFG_CT_NEON_AVAILABLE
#endif

#ifndef LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC
#define LAC_CFG_CT_NEON_PKE_THRESHOLD_DEC LAC_CFG_CT_NEON_ENCRYPT
#endif

#ifndef LAC_CFG_CT_NEON_PKE_MESSAGE_ADD
#define LAC_CFG_CT_NEON_PKE_MESSAGE_ADD LAC_CFG_CT_NEON_ENCRYPT
#endif

/* bch.c 解码路径：在 CT 标量基线上启用 NEON 后端。 */
#ifndef LAC_CFG_CT_NEON_BCH
#define LAC_CFG_CT_NEON_BCH LAC_CFG_CT_NEON_AVAILABLE
#endif

#ifndef LAC_CFG_CT_NEON_BCH_SYNDROME
#define LAC_CFG_CT_NEON_BCH_SYNDROME LAC_CFG_CT_NEON_BCH
#endif

#ifndef LAC_CFG_CT_NEON_BCH_ELP
#define LAC_CFG_CT_NEON_BCH_ELP LAC_CFG_CT_NEON_BCH
#endif

#ifndef LAC_CFG_CT_NEON_BCH_CHIEN
#define LAC_CFG_CT_NEON_BCH_CHIEN LAC_CFG_CT_NEON_BCH
#endif

#if !LAC_CFG_CT_NEON_AVAILABLE
#undef LAC_CFG_CT_NEON_BCH
#define LAC_CFG_CT_NEON_BCH 0
#undef LAC_CFG_CT_NEON_BCH_SYNDROME
#define LAC_CFG_CT_NEON_BCH_SYNDROME 0
#undef LAC_CFG_CT_NEON_BCH_ELP
#define LAC_CFG_CT_NEON_BCH_ELP 0
#undef LAC_CFG_CT_NEON_BCH_CHIEN
#define LAC_CFG_CT_NEON_BCH_CHIEN 0
#endif

/* 兼容别名：保留之前的 SIMD 命名，避免后续小范围代码还没改完时断掉。 */
#ifndef LAC_CFG_SIMD
#define LAC_CFG_SIMD LAC_CFG_CT_NEON
#endif

#ifndef LAC_CFG_SIMD_NEON
#define LAC_CFG_SIMD_NEON LAC_CFG_CT_NEON_AVAILABLE
#endif

#ifndef LAC_CFG_SIMD_BINLWE_CORE
#define LAC_CFG_SIMD_BINLWE_CORE LAC_CFG_CT_NEON_BINLWE_CORE
#endif

#ifndef LAC_CFG_SIMD_BINLWE_PACK
#define LAC_CFG_SIMD_BINLWE_PACK LAC_CFG_CT_NEON_BINLWE_PACK
#endif

#ifndef LAC_CFG_SIMD_ENCRYPT
#define LAC_CFG_SIMD_ENCRYPT LAC_CFG_CT_NEON_ENCRYPT
#endif

#ifndef LAC_CFG_SIMD_ECC
#define LAC_CFG_SIMD_ECC LAC_CFG_CT_NEON_ECC
#endif

#ifndef LAC_CFG_SIMD_BCH
#define LAC_CFG_SIMD_BCH LAC_CFG_CT_NEON_BCH
#endif

#ifndef LAC_CFG_SIMD_BCH_ELP
#define LAC_CFG_SIMD_BCH_ELP LAC_CFG_CT_NEON_BCH_ELP
#endif

/* ===== 修复类 / 安全卫生类开关 =====
 * 这些宏不跟随 STD/CT 总控摇摆，保持独立默认值。
 */

/* [rand.c] 修复 pseudo_random_bytes 尾块拷贝偏移问题。 */
#ifndef LAC_FIX_RAND_TAIL_COPY
#define LAC_FIX_RAND_TAIL_COPY 1
#endif

/* 控制是否擦除敏感中间值。 */
#ifndef LAC_CFG_SECURE_CLEAR
#define LAC_CFG_SECURE_CLEAR 1
#endif

/* ===== 第三层：非 CT 历史宏兼容 =====
 * 这类宏不属于 CT 配置体系，但项目外部或历史代码可能仍会引用，
 * 因此保留兼容名字。
 */
#ifndef LAC_USE_SECURE_CLEAR
#define LAC_USE_SECURE_CLEAR LAC_CFG_SECURE_CLEAR
#endif

/* ===== 第四层：派生宏 ===== */

/* BCH syndrome a_pow 的最终生效值：
 * 若开启 CT-BCH 且允许强制提升，则覆盖默认值并直接启用。 */
#if LAC_CFG_CT_BCH && LAC_CFG_CT_BCH_FORCE_SYNDROME_APOW
#undef LAC_CFG_CT_BCH_SYNDROME_APOW
#define LAC_CFG_CT_BCH_SYNDROME_APOW 1
#endif

/* [bch.c] 派生兼容宏：
 * 某些 BCH 实现分支直接看 BCH_CONSTANT_TIME；
 * 这里把它绑定到 LAC_CFG_CT_BCH，确保 CT-BCH 打开时相关代码一致。 */
#if LAC_CFG_CT_BCH
#ifndef BCH_CONSTANT_TIME
#define BCH_CONSTANT_TIME 1
#endif
#endif

/* 敏感数据清零实现：
 * 使用 volatile 写入，避免被优化器直接删除。 */
static inline void lac_secure_clear_impl(void *ptr, size_t len)
{
#if LAC_CFG_SECURE_CLEAR
	volatile unsigned char *p = (volatile unsigned char *)ptr;

	while (len--) {
		*p++ = 0;
	}
#else
	(void)ptr;
	(void)len;
#endif
}

/* 统一清零调用入口。 */
#define LAC_SECURE_CLEAR(ptr, len) lac_secure_clear_impl((ptr), (len))

#endif
#endif
