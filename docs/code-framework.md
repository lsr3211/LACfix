# LAC 代码框架梳理

这份文档用于快速建立代码地图：先看构建入口和公开 API，再顺着 PKE/KEM/KE/AKE 的调用链往下走到 LWE、ECC/BCH、随机数和 CT/NEON 后端。

## 1. 总体分层

```text
main.c
  |
  +-- test_correctness.c / test_speed.c / test_cpucycles.c
        |
        +-- api.h
              |
              +-- encrypt.c   CPA PKE: keygen / encrypt / decrypt
              +-- kem.c       FO KEM: encaps / decaps
              +-- ke.c        two-party key exchange wrapper
              +-- ake.c       authenticated key exchange wrapper
                    |
                    +-- bin-lwe.c   LWE sampler, polynomial arithmetic, pack/unpack
                    +-- ecc.c       LAC ECC wrapper
                    +-- bch.c       BCH encode/decode core
                    +-- rand.c      random bytes, PRG, hash, seed derivation
                    +-- rng.c       AES-CTR DRBG support
```

`lac_param.h` 定义 LAC128/LAC192/LAC256 参数集；日常构建建议用 `make PARAM=...` 选择，不再需要手动改头文件。`compat.h` 是当前优化版最重要的配置入口，统一管理 `STD`、`CT`、`CTNEON` 构建 profile、CT 开关、NEON 后端开关和安全清零宏。

## 2. 文件职责

| 文件 | 职责 |
| --- | --- |
| `Makefile` | 构建 `lac` 测试程序；通过 `PROFILE=STD/CT/CTNEON` 选择实现路径，通过 `PARAM=LAC128/LAC192/LAC256` 选择参数集，通过 `CTESTS=`、`BENCH_NTESTS=`、`BCH_NTESTS=` 调整测试轮数。 |
| `main.c` | 命令行测试入口，分发 `correctness`、`speed`、`cpucycles`、`basicblock` 和若干聚焦 benchmark。 |
| `api.h` | 对外 API 声明，覆盖 PKE、KEM、KE、AKE。 |
| `lac_param.h` | 安全级别、维度、密钥长度、密文长度、消息长度和分布类型。 |
| `compat.h` | 构建 profile 和优化特性矩阵；新增 CT/SIMD 开关应优先挂在这里。 |
| `encrypt.c` | CPA PKE 主实现：密钥生成、加密、解密、消息嵌入和阈值恢复。 |
| `kem.c` | Fujisaki-Okamoto KEM 包装；解封装包含重新加密验证和常数时间选择。 |
| `ke.c` | 基于 PKE 的双方密钥交换流程。 |
| `ake.c` | 认证密钥交换流程，组合 KEM、PKE 和 transcript hash。 |
| `bin-lwe.c/.h` | 生成公参 `a`、采样 secret/error、多项式乘/加、压缩/解压；也是主要性能热点。 |
| `ecc.c/.h` | LAC 层面的 ECC 编解码接口和纠错写回。 |
| `bch.c/.h` | BCH 码核心，包含原始路径、CT 标量路径和 CT-NEON 路径。 |
| `bch128.h` / `bch192.h` / `bch256.h` | 参数集对应的 BCH 预计算表和状态。 |
| `rand.c/.h` | OpenSSL 随机数、伪随机扩展、hash、seed 派生。 |
| `rng.c/.h` | NIST 风格 AES-CTR DRBG。 |
| `test_*.c/.h` | 正确性测试、速度测试和 cycle benchmark。 |

## 3. 核心调用链

### PKE

```text
crypto_encrypt_keypair
  -> kg
     -> kg_seed
        -> gen_a
        -> gen_psi_fix_ham
        -> poly_aff

crypto_encrypt
  -> pke_enc
     -> pke_enc_seed
        -> ecc_enc
        -> gen_psi_fix_ham / gen_psi_std
        -> poly_aff
        -> pke_add_message / pke_add_message_d2
        -> poly_compress

crypto_encrypt_open
  -> pke_dec
     -> poly_decompress
     -> poly_mul
     -> pke_recover_msg / pke_recover_msg_d2
     -> ecc_dec
```

### KEM

```text
crypto_kem_keypair
  -> crypto_encrypt_keypair

crypto_kem_enc
  -> kem_enc_fo
     -> random message
     -> gen_seed(message)
     -> pke_enc_seed
     -> hash(message | ciphertext)

crypto_kem_dec
  -> kem_dec_fo
     -> pke_dec
     -> hash(message | ciphertext) as good key
     -> pke_enc_seed(message-derived seed)
     -> compare input ciphertext with re-encrypted ciphertext
     -> hash(hash(sk) | ciphertext) as fallback key
     -> constant-time select good/fallback key
```

### KE / AKE

`ke.c` 是较薄的双方协议包装：Alice 生成 PKE 密钥，Bob 加密临时消息，双方对 `pk | message` 做 hash 得到共享密钥。

`ake.c` 组合了长期身份密钥、临时 PKE 密钥、FO KEM 和 CPA PKE。最终会把 `pk_a | pk_b | pk | c3 | k1 | k2 | k3` 作为 transcript 输入 hash，得到认证会话密钥。

## 4. 数据布局

| 数据 | 布局 |
| --- | --- |
| Public key `pk` | `seed_a | b`，前 `SEED_LEN` 字节用于重新生成公参 `a`，后半部分存 `a*s+e`。 |
| Secret key `sk` | `s | pk`，前 `DIM_N` 字节是 secret，多出来的 `PK_LEN` 字节缓存公钥。 |
| PKE ciphertext `c` | `c1 | compressed(c2)`，`c1` 长度为 `DIM_N`，`c2` 按 nibble 压缩后追加。 |
| Encoded message | `m` 先右对齐放进 `DATA_LEN` 数据区，再经过 `ecc_enc` 生成带 BCH 冗余的 `code`。 |
| KEM shared secret | 长度为 `MESSAGE_LEN`，由 `hash(m | c)` 或 fallback `hash(hash(sk) | c)` 产生。 |

## 5. CT / SIMD 边界

当前优化版的设计约束是：CT 标量路径定义安全语义，NEON 只作为固定工作量循环的后端实现。维护时建议保持以下边界：

- 新的 profile 或优化开关统一放进 `compat.h`。
- `STD` 路径用于保留原始实现行为；安全敏感默认路径应优先走 `CT`。
- `CTNEON` 不应引入新的 secret-dependent 分支、提前退出或数据相关写入。
- 临时 secret buffer 退出前使用 `LAC_SECURE_CLEAR`。
- `lac_small_t` 依赖 `LAC_SIGNED_CHAR` 固定 `-1/0/1` 表示，避免平台默认 `char` 符号性差异。

## 6. 建议阅读顺序

1. 先读 `README.md`，确认构建 profile 和测试命令。
2. 读 `lac_param.h` 和 `api.h`，建立参数集和公开 API 的边界。
3. 读 `encrypt.c` 的 `kg_seed`、`pke_enc_seed`、`pke_dec`，理解 PKE 主流程。
4. 读 `kem.c` 的 `kem_enc_fo`、`kem_dec_fo`，理解 CCA 包装。
5. 读 `bin-lwe.c` 的 `gen_a`、`gen_psi_*`、`poly_mul`、`poly_aff`、`poly_compress`、`poly_decompress`。
6. 最后读 `ecc.c` 和 `bch.c`，这里是纠错和 CT decode 的复杂区域。

## 7. 后续整理顺序

1. 保持当前文件边界，先补足模块注释和文档，不急着拆大文件。
2. 把 `bin-lwe.c` 先按 section 稳定成 sampler、polynomial arithmetic、packing 三块。
3. 给 `bch.c` 的 CT decode 增加更多不变量说明，再考虑拆出 CT/NEON 局部实现。
4. 所有新优化先接入 `compat.h` 特性矩阵，再接入具体 `.c` 文件。
5. 每次整理后至少运行 `make clean && make PROFILE=CT CTESTS=100` 和 `./lac correctness` 做 smoke test；发布前再跑默认 `CTESTS=10000`。
