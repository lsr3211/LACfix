# CT And SIMD Implementation Notes

This note records the current implementation shape after the CT pass and the
subsequent SIMD pass. It is meant to help future cleanup work preserve the same
security model while making the code easier to reason about.

## Build Profiles

The project now has one central configuration entry point in `compat.h`.

| Profile | Meaning | Typical command |
| --- | --- | --- |
| `STD` | Prefer the original paths. CT-specific paths are disabled by default. | `make PROFILE=STD` |
| `CT` | Enable constant-time scalar paths. This is the default profile. | `make PROFILE=CT` |
| `CTNEON` | Enable CT scalar semantics plus NEON backends where the target supports NEON. | `make PROFILE=CTNEON` |

The important design rule is that CT-NEON is not a separate security model. It
inherits the CT semantics and only changes how selected fixed-work operations
are executed.

Parameter sets are selected with `PARAM=LAC128`, `PARAM=LAC192`, or
`PARAM=LAC256`. Correctness and benchmark loop counts can be reduced for smoke
runs with `CTESTS=...`, `BENCH_NTESTS=...`, and `BCH_NTESTS=...`.

## CT Work Summary

The CT pass focused on removing secret-dependent early exits, branches,
lookups, and writes from security-sensitive paths.

- `bin-lwe.c`
  - `gen_psi_fix_ham_ct` uses fixed-work sorting/selection structure for the
    fixed-Hamming-weight sampler.
  - `poly_mul_scalar_ct` and `poly_aff_scalar_ct` convert secret coefficients
    into masks and accumulate without branching on `s[i]`.
  - Modular reduction uses fixed bounded subtract steps where applicable.

- `bch.c`
  - CT syndrome, error locator polynomial, and Chien search variants avoid the
    original decode path's data-dependent root-finding structure.
  - `decode_bch_ct_scalar` exposes a scalar CT decode path for benchmarking
    against pure C and CT-NEON.

- `encrypt.c`
  - Message recovery thresholds are expressed with masks instead of
    secret-dependent branches.
  - `c2 - out mod q` has a CT reduction helper.
  - Message injection has a separate CT wrapper so the scalar and SIMD backends
    share the same dispatch pattern.

- `ecc.c`
  - Correction writeback iterates over fixed public bounds and applies flips
    through masks.

- `kem.c`
  - Decapsulation verification computes both the valid shared secret and the
    fallback key, then selects with a mask derived from ciphertext equality.

- `compat.h`
  - Sensitive temporary buffers are cleared through `LAC_SECURE_CLEAR`.
  - `lac_small_t` can be forced to `signed char` with `LAC_SIGNED_CHAR`, avoiding
    platform-dependent plain-`char` behavior for `-1/0/1`.

## SIMD Work Summary

The SIMD pass currently targets ARM NEON and is guarded by
`LAC_CFG_CT_NEON_AVAILABLE`.

- `bin-lwe.c`
  - NEON backends accelerate the mask-building and polynomial multiply/add
    accumulation paths.
  - Compression/decompression use vectorized nibble packing/unpacking.
  - The implementation processes full vector blocks first and falls back to
    scalar tails for non-multiple lengths.

- `bch.c`
  - NEON variants exist for syndrome accumulation, ELP work, and Chien search.
  - The public benchmark entry point is `decode_bch_ctneon`.

- `encrypt.c`
  - Threshold recovery and message injection have NEON backends.

- `ecc.c`
  - Correction writeback has a NEON backend for applying masked byte updates.

## Current Hotspots Worth Deepening

1. BCH CT decode is the most complex part of the tree.

   The pure C BCH decoder uses a rich algorithmic structure with degree-specific
   root solvers. The CT decoder intentionally pays more fixed work to avoid
   control flow that depends on decode state. This makes `bch.c` the best place
   to document invariants before further refactoring: bounds for `t`,
   polynomial degree limits, valid root counts, and how error locations are
   masked before writeback.

2. `bin-lwe.c` mixes three concerns in one large file.

   It currently contains randomness expansion, sampler logic, scalar CT
   arithmetic, NEON arithmetic, and packing. For maintainability, the next code
   cleanup could split it conceptually into sampler, polynomial arithmetic, and
   packing sections before physically moving files. That gives a safer review
   path: stabilize section boundaries first, split files only after tests remain
   boring.

3. `compat.h` is now the contract.

   The project is much easier to reason about if all feature selection continues
   to flow through `compat.h`. New local `#ifdef` names should be avoided unless
   they are immediately wired into the same profile matrix.

4. SIMD should stay subordinate to CT.

   The useful mental model is: scalar CT defines the behavior; NEON is an
   implementation of selected fixed-work loops. That prevents performance work
   from accidentally reintroducing secret-dependent control flow.

5. The test commands now have a configurable smoke-test path.

   `./lac correctness` is a real correctness run with 10000 iterations per major
   primitive by default. For day-to-day cleanup, build with a smaller
   `CTESTS` value, such as `make CTESTS=100 PROFILE=CTNEON`, while keeping the
   default command as the regression gate.

## Suggested Cleanup Order

1. Keep `compat.h` as the public feature matrix and add any new toggles there.
2. Add short block comments above CT/NEON dispatch wrappers in `bin-lwe.c`,
   `bch.c`, `encrypt.c`, and `ecc.c`.
3. Normalize naming around `CTNEON`; keep the old `SIMD` aliases only as
   compatibility shims.
4. Add focused comments for BCH CT invariants before moving code.
5. After comments and tests settle, consider splitting `bin-lwe.c` and `bch.c`
   into smaller implementation files.

## Verification Snapshot

The following commands were run successfully on Apple arm64:

```sh
make clean
make PROFILE=CTNEON CC=clang
./lac correctness
```

Result: LAC128 PKE, KEM-FO, KE, and AKE correctness tests reported zero error
blocks.
