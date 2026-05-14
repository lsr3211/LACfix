# LAC Optimized Implementation

This repository contains an optimized C implementation of LAC with three build
profiles:

- `STD`: original/standard implementation paths.
- `CT`: constant-time scalar paths enabled by default.
- `CTNEON`: constant-time baseline plus ARM NEON backends where available.

The current optimization work was developed in two phases: first replacing
data-dependent security-sensitive paths with constant-time code, then adding
SIMD acceleration on top of that CT baseline.

## Build

The Makefile defaults to the CT profile:

```sh
make
```

To select a profile explicitly:

```sh
make PROFILE=STD
make PROFILE=CT
make PROFILE=CTNEON
```

To select a parameter set without editing source:

```sh
make PARAM=LAC128
make PARAM=LAC192
make PARAM=LAC256
```

On macOS/Homebrew, OpenSSL is expected at `/opt/homebrew/opt/openssl@3` by
default. Override it when needed:

```sh
make OPENSSL_PREFIX=/path/to/openssl
```

The `NEON` switch can override the automatic NEON choice:

```sh
make PROFILE=CTNEON NEON=ON
make PROFILE=CT NEON=OFF
```

## Tests And Benchmarks

After building, run:

```sh
./lac correctness
./lac speed
./lac cpucycles
./lac basicblock
```

For faster day-to-day smoke testing, reduce the correctness loop count at build
time:

```sh
make CTESTS=100 PROFILE=CTNEON
./lac correctness
```

Benchmark loop counts are also configurable:

```sh
make PROFILE=CTNEON PARAM=LAC256 BENCH_NTESTS=200 BCH_NTESTS=50
./lac speed
./lac cpucycles
```

Focused benchmark commands are also available:

```sh
./lac cpucycles_pke
./lac cpucycles_kem
./lac cpucycles_ke
./lac cpucycles_ake
./lac cpucycles_gena
./lac cpucycles_genpsi
./lac cpucycles_polymul
./lac cpucycles_polyaff
./lac cpucycles_bch
./lac speed_bch
```

## Parameter Sets

Select the security level at build time:

```sh
make PARAM=LAC128
make PARAM=LAC192
make PARAM=LAC256
```

`lac_param.h` still contains the source-level defaults:

```c
#define LAC128
/* or */
#define LAC192
/* or */
#define LAC256
```

If none is selected, `LAC128` is used by default.

## Code Map

- `compat.h`: central profile/configuration entry point for CT, CT-NEON,
  compatibility aliases, and secure clearing.
- `bin-lwe.c`: public parameter generation, secret/error sampling,
  polynomial multiply/add, and compression/decompression. This is the main LWE
  arithmetic hotspot.
- `encrypt.c`: CPA PKE key generation, encryption, decryption, threshold
  recovery, and message injection.
- `bch.c`: BCH encode/decode implementation, including pure C, CT scalar, and
  CT-NEON decode variants.
- `ecc.c`: LAC-level ECC wrapper around BCH encode/decode and correction
  writeback.
- `kem.c`: Fujisaki-Okamoto KEM layer and CT decapsulation verification.
- `ke.c`, `ake.c`: key exchange and authenticated key exchange wrappers.
- `rand.c`, `rng.c`: random bytes, deterministic pseudorandom expansion, hash,
  and NIST-style AES-CTR DRBG support.

More notes are in `docs/ct-simd-implementation-notes.md`.

For a maintainer-oriented overview of the source tree, call graph, and data
layouts, see `docs/code-framework.md`.

## Current Verification Snapshot

On Apple arm64 with Apple clang 17 and OpenSSL 3 from Homebrew:

```sh
make clean
make PROFILE=CTNEON CC=clang
./lac correctness
```

The LAC128 correctness run completed with zero errors across PKE, KEM, KE, and
AKE.
