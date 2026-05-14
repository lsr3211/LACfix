# LAC 三套架构与三参数集综合分析

本报告基于当前工作区代码重新梳理。三套架构指构建 profile：
`STD`、`CT`、`CTNEON`；三种参数集指 `LAC128`、`LAC192`、
`LAC256`。

## 1. 本次整理内容

- `Makefile` 增加 `PARAM=LAC128/LAC192/LAC256`，参数集不再需要手动改
  `lac_param.h`。
- `Makefile` 增加 `BENCH_NTESTS` 与 `BCH_NTESTS`，速度和周期测试可调轮
  数。
- `test_speed.c`、`test_cpucycles.c` 的 `NTESTS`、`BCH_NTESTS` 改为可由
  编译命令覆盖。
- `README.md`、`docs/code-framework.md`、
  `docs/ct-simd-implementation-notes.md` 补充参数集和 benchmark 构建说明。
- 未删除任何源码或文档。唯一执行的删除动作是 `make clean` 删除构建产物：
  `lac`、`main.o`、`test_correctness.o`、`test_cpucycles.o`、`test_speed.o`、
  `ake.o`、`ke.o`、`kem.o`、`encrypt.o`、`ecc.o`、`bch.o`、`bin-lwe.o`、
  `rand.o`、`rng.o`。随后实验构建又重新生成了 `lac` 和目标文件。

## 2. 代码框架

```text
main.c
  |
  +-- test_correctness.c / test_speed.c / test_cpucycles.c
        |
        +-- api.h
              |
              +-- encrypt.c   CPA PKE: keygen / encrypt / decrypt
              +-- kem.c       FO KEM: encaps / decaps
              +-- ke.c        key exchange wrapper
              +-- ake.c       authenticated key exchange wrapper
                    |
                    +-- bin-lwe.c   LWE sampler, polynomial multiply/add, pack
                    +-- ecc.c       LAC ECC wrapper
                    +-- bch.c       BCH encode/decode core
                    +-- rand.c      random, PRG, SHA-256 seed/hash
                    +-- rng.c       AES-CTR DRBG support
```

核心边界：

- `lac_param.h`：定义安全参数、维度、密钥/密文长度、分布类型。
- `compat.h`：统一控制 STD/CT/CTNEON profile、常数时间开关、NEON 后端和
  安全清零。
- `api.h`：对外暴露 PKE、KEM、KE、AKE。
- `bin-lwe.c`：最大热点，包含 `gen_a`、`gen_psi_*`、`poly_mul`、
  `poly_aff`、`poly_compress`、`poly_decompress`。
- `bch.c`：最复杂的安全路径，包含原始 BCH、CT 标量 BCH、CTNEON BCH。

## 3. 三套架构运行逻辑

### STD

命令：`make PROFILE=STD PARAM=LAC128`

STD 优先保留原始实现路径：

- `compat.h` 将 `LAC_PROFILE_IS_CT` 置 0。
- `gen_psi_fix_ham` 使用原始碰撞重采样流程。
- `poly_mul` / `poly_aff` 使用原始标量路径。
- `pke_dec` 使用普通阈值分支恢复消息。
- `kem_dec_fo` 使用普通比较验证密文。
- `ecc_dec` 的纠错写回按错误个数循环。
- `decode_bch` 使用原始 BCH 解码路径。

优点是最快、最接近原始版本；缺点是保留较多数据相关分支/查表/提前退出，
不适合作为侧信道安全默认路径。

### CT

命令：`make PROFILE=CT PARAM=LAC128`

CT 是当前默认安全基线：

- `gen_psi_fix_ham` 分发到 `gen_psi_fix_ham_ct`，通过固定结构排序和固定
  写回生成固定汉明重量小向量。
- `poly_mul` / `poly_aff` 使用 `poly_mul_scalar_ct`、
  `poly_aff_scalar_ct`，先把 secret 系数转成掩码，再固定工作量累加。
- `pke_dec` 的阈值恢复使用掩码判断，不依赖明文位分支。
- `kem_dec_fo` 同时计算 good key 与 fallback key，再常数时间选择。
- `ecc_dec` 固定迭代 `MAX_ERROR`，用掩码写回纠错。
- `decode_bch` 使用 CT syndrome、CT Berlekamp-Massey、CT Chien search。
- 临时 secret buffer 通过 `LAC_SECURE_CLEAR` 清零。

优点是安全语义清晰；代价是 BCH decode 和固定工作量 sampler 明显变慢。

### CTNEON

命令：`make PROFILE=CTNEON PARAM=LAC128`

CTNEON 不是独立安全模型，而是在 CT 语义上启用 ARM NEON 后端：

- `compat.h` 在 `LAC_CFG_CT_NEON_AVAILABLE` 为 1 时打开 NEON 子模块。
- `bin-lwe.c` 的采样、乘加、压缩/解压使用 NEON 批处理。
- `encrypt.c` 的阈值恢复和消息注入有 NEON 后端。
- `kem.c` 的密文 diff 与 key select 有 NEON 后端。
- `ecc.c` 的纠错写回有 NEON 后端。
- `bch.c` 的 syndrome、ELP、Chien search 有 NEON 后端。

优点是保留 CT 语义同时明显追回性能；在 Apple arm64 本机，PKE/KEM/AKE 速度
大多落在 STD 与 CT 之间，BCH CT decode 提升最明显。

## 4. 三参数集运行逻辑

| 参数集 | `DIM_N` | `PK_LEN` | `CIPHER_LEN` | `C2_VEC_NUM` | 分布 | ECC | 特点 |
| --- | ---: | ---: | ---: | ---: | --- | --- | --- |
| LAC128 | 512 | 544 | 712 | 400 | `PSI` | 18 字节, `MAX_ERROR=16` | 维度较小，整体最快 |
| LAC192 | 1024 | 1056 | 1188 | 328 | `PSI_SQUARE` | 9 字节, `MAX_ERROR=8` | 维度加倍但 ECC 较短 |
| LAC256 | 1024 | 1056 | 1424 | 800 | `PSI` | 18 字节, `MAX_ERROR=16` | 使用 D2 编解码，密文最大 |

LAC256 的 PKE 和 KEM 更重，主要因为 `C2_VEC_NUM=800` 且走 D2 编码/解码：
消息位会注入两份 `e2` 区间，解密时对两份噪声镜像合并后再阈值恢复。

## 5. 核心协议调用链

PKE keygen:

```text
crypto_encrypt_keypair
  -> kg
     -> kg_seed
        -> pseudo_random_bytes(seed -> seed_a, seed_s, seed_e)
        -> gen_a(seed_a)
        -> gen_psi_fix_ham(s)
        -> gen_psi_fix_ham(e)
        -> poly_aff(a, s, e) = a*s + e
        -> pk = seed_a | b
        -> sk = s | pk
```

PKE encrypt/decrypt:

```text
pke_enc_seed
  -> gen_a(pk.seed)
  -> ecc_enc(message)
  -> gen_psi_fix_ham(r), gen_psi_fix_ham(e1), gen_psi_std(e2)
  -> c1 = a*r + e1
  -> e2 += encoded_message * q/2
  -> c2 = pk.b*r + e2
  -> poly_compress(c2)

pke_dec
  -> poly_decompress(c2)
  -> out = c1*s
  -> recover encoded_message from c2 - out
  -> ecc_dec
```

KEM:

```text
kem_enc_fo
  -> random m
  -> seed = gen_seed(m)
  -> pke_enc_seed(pk, m, seed)
  -> shared_key = hash(m | ciphertext)

kem_dec_fo
  -> m' = pke_dec(sk, ciphertext)
  -> good_key = hash(m' | ciphertext)
  -> reencrypt m' and compare ciphertext
  -> bad_key = hash(hash(sk) | ciphertext)
  -> CT profile selects good/bad key with masks
```

KE:

```text
Alice: crypto_ke_alice_send -> PKE keygen
Bob  : random m -> PKE encrypt -> hash(pk-prefix | m)
Alice: PKE decrypt -> hash(pk-prefix | m)
```

AKE:

```text
Alice send:
  ephemeral PKE keygen
  seed = hash(random | sk_a)
  KEM to Bob static pk_b -> c_a, k1

Bob receive:
  seed = hash(random | sk_b)
  KEM to Alice static pk_a -> c_b[0], k2
  PKE to Alice ephemeral pk -> c_b[1], k3
  decaps c_a -> k1
  session = hash(pk_a | pk_b | pk | c3 | k1 | k2 | k3)

Alice receive:
  decaps c_b[0] -> k2
  decrypt c_b[1] -> k3
  session = same transcript hash
```

## 6. 测试矩阵

测试环境：

- Apple clang 17.0.0
- arm64 macOS
- OpenSSL 3 from `/opt/homebrew/opt/openssl@3`
- 正确性：`CTESTS=20`
- 速度：`BENCH_NTESTS=50`, `BCH_NTESTS=20`
- 周期接口：`BENCH_NTESTS=50`。在 arm64 上 `cpucycles()` 使用
  `clock_gettime` 纳秒 fallback，因此只用于相对对比。

正确性结果：

| Profile | LAC128 | LAC192 | LAC256 |
| --- | --- | --- | --- |
| STD | PKE/KEM/KE/AKE 全 0 error | 全 0 error | 全 0 error |
| CT | PKE/KEM/KE/AKE 全 0 error | 全 0 error | 全 0 error |
| CTNEON | PKE/KEM/KE/AKE 全 0 error | 全 0 error | 全 0 error |

## 7. 速度结果摘要

单位：微秒/操作，短基准。

### PKE

| Profile | Param | Keygen | Encrypt | Decrypt |
| --- | --- | ---: | ---: | ---: |
| STD | LAC128 | 89.14 | 60.14 | 25.76 |
| STD | LAC192 | 148.28 | 124.74 | 78.16 |
| STD | LAC256 | 162.60 | 168.76 | 64.50 |
| CT | LAC128 | 302.00 | 237.70 | 392.40 |
| CT | LAC192 | 571.52 | 372.54 | 185.12 |
| CT | LAC256 | 742.62 | 490.34 | 318.72 |
| CTNEON | LAC128 | 129.82 | 98.60 | 153.04 |
| CTNEON | LAC192 | 260.52 | 230.94 | 107.72 |
| CTNEON | LAC256 | 293.24 | 295.50 | 151.98 |

### KEM-FO

| Profile | Param | Keygen | Encaps | Decaps |
| --- | --- | ---: | ---: | ---: |
| STD | LAC128 | 45.72 | 60.70 | 76.58 |
| STD | LAC192 | 78.88 | 100.04 | 136.62 |
| STD | LAC256 | 84.72 | 123.06 | 156.14 |
| CT | LAC128 | 131.04 | 134.02 | 400.84 |
| CT | LAC192 | 268.24 | 271.30 | 387.94 |
| CT | LAC256 | 333.84 | 353.24 | 622.62 |
| CTNEON | LAC128 | 79.80 | 90.66 | 189.84 |
| CTNEON | LAC192 | 142.94 | 156.48 | 216.86 |
| CTNEON | LAC256 | 153.64 | 179.08 | 269.34 |

### KE / AKE

| Profile | Param | KE Alice0 | KE Bob | KE Alice1 | AKE Alice0 | AKE Bob | AKE Alice1 |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| STD | LAC128 | 38.86 | 56.56 | 19.56 | 78.80 | 141.62 | 64.58 |
| STD | LAC192 | 59.16 | 79.54 | 47.74 | 125.12 | 240.44 | 139.42 |
| STD | LAC256 | 64.02 | 100.54 | 43.78 | 154.16 | 301.78 | 151.10 |
| CT | LAC128 | 101.76 | 108.04 | 259.64 | 202.58 | 548.86 | 583.60 |
| CT | LAC192 | 229.72 | 245.40 | 135.34 | 470.76 | 877.30 | 510.72 |
| CT | LAC256 | 317.22 | 353.20 | 280.70 | 685.96 | 1537.44 | 956.42 |
| CTNEON | LAC128 | 55.18 | 66.50 | 91.52 | 107.76 | 242.20 | 201.10 |
| CTNEON | LAC192 | 106.68 | 123.86 | 66.84 | 210.60 | 378.20 | 217.34 |
| CTNEON | LAC256 | 115.70 | 148.54 | 92.82 | 237.44 | 487.68 | 312.00 |

### BCH decode

| Profile | Param | Pure C | CT scalar | SIMD/CTNEON |
| --- | --- | ---: | ---: | ---: |
| STD | LAC128 | 1.15 | 1.00 | 1.00 fallback |
| STD | LAC192 | 0.30 | 0.30 | 0.20 fallback |
| STD | LAC256 | 0.95 | 0.70 | 0.65 fallback |
| CT | LAC128 | 0.75 | 252.10 | 246.95 fallback |
| CT | LAC192 | 0.25 | 108.35 | 102.35 fallback |
| CT | LAC256 | 0.75 | 247.05 | 251.50 fallback |
| CTNEON | LAC128 | 0.90 | 282.00 | 55.90 |
| CTNEON | LAC192 | 0.30 | 104.25 | 23.55 |
| CTNEON | LAC256 | 0.80 | 253.15 | 53.85 |

## 8. 综合结论

1. 正确性上，9 组 profile/参数集均通过 PKE、KEM-FO、KE、AKE smoke test。
2. STD 是最快路径，但不是当前安全默认。它适合作为兼容基线和性能参照。
3. CT 标量路径的主要成本来自固定工作量 sampler、poly arithmetic 与 BCH CT
   decode。LAC256 的 D2 路径让加密、解封装、AKE Bob 侧成本进一步上升。
4. CTNEON 对 CT 成本有明显回收：PKE、KEM、KE、AKE 大多接近或显著优于 CT；
   BCH decode 从约 100-280 us 降到约 24-56 us。
5. LAC192 的 BCH 较轻，因为 `MAX_ERROR=8`、ECC 9 字节；虽然 `DIM_N=1024`，
   解密/BCH 部分不一定比 LAC128/LAC256 慢。
6. LAC256 密文最大、`C2_VEC_NUM=800` 且使用 D2 编解码，所以在加密、
   KEM decap、AKE Bob/Alice1 上通常最重。

## 9. 建议

- 日常默认使用 `PROFILE=CT` 或 `PROFILE=CTNEON`；在 Apple arm64 上优先用
  `CTNEON`。
- 回归测试建议先跑：
  `make PROFILE=CTNEON PARAM=LAC256 CTESTS=100 BENCH_NTESTS=200 BCH_NTESTS=50 CC=clang`
  再执行 `./lac correctness` 与 `./lac speed`。
- 发布前再把 `CTESTS` 和 benchmark 轮数调回默认长跑。
- 后续代码整理优先顺序：先给 `bin-lwe.c` 和 `bch.c` 补 section 级注释，再
  考虑物理拆文件；拆文件前保持 `compat.h` 作为唯一 profile/feature 矩阵。
