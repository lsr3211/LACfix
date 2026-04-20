# 0 "encrypt.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "encrypt.c"
# 1 "/usr/include/string.h" 1 3 4
# 26 "/usr/include/string.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 33 "/usr/include/aarch64-linux-gnu/bits/libc-header-start.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 394 "/usr/include/features.h" 3 4
# 1 "/usr/include/features-time64.h" 1 3 4
# 20 "/usr/include/features-time64.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/wordsize.h" 1 3 4
# 21 "/usr/include/features-time64.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/timesize.h" 1 3 4
# 22 "/usr/include/features-time64.h" 2 3 4
# 395 "/usr/include/features.h" 2 3 4
# 502 "/usr/include/features.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/sys/cdefs.h" 1 3 4
# 576 "/usr/include/aarch64-linux-gnu/sys/cdefs.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/wordsize.h" 1 3 4
# 577 "/usr/include/aarch64-linux-gnu/sys/cdefs.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/long-double.h" 1 3 4
# 578 "/usr/include/aarch64-linux-gnu/sys/cdefs.h" 2 3 4
# 503 "/usr/include/features.h" 2 3 4
# 526 "/usr/include/features.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/gnu/stubs.h" 1 3 4




# 1 "/usr/include/aarch64-linux-gnu/bits/wordsize.h" 1 3 4
# 6 "/usr/include/aarch64-linux-gnu/gnu/stubs.h" 2 3 4


# 1 "/usr/include/aarch64-linux-gnu/gnu/stubs-lp64.h" 1 3 4
# 9 "/usr/include/aarch64-linux-gnu/gnu/stubs.h" 2 3 4
# 527 "/usr/include/features.h" 2 3 4
# 34 "/usr/include/aarch64-linux-gnu/bits/libc-header-start.h" 2 3 4
# 27 "/usr/include/string.h" 2 3 4






# 1 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stddef.h" 1 3 4
# 214 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stddef.h" 3 4

# 214 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 34 "/usr/include/string.h" 2 3 4
# 43 "/usr/include/string.h" 3 4
extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
       size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern void *memmove (void *__dest, const void *__src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));





extern void *memccpy (void *__restrict __dest, const void *__restrict __src,
        int __c, size_t __n)
    __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2))) __attribute__ ((__access__ (__write_only__, 1, 4)));




extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 80 "/usr/include/string.h" 3 4
extern int __memcmpeq (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 107 "/usr/include/string.h" 3 4
extern void *memchr (const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 141 "/usr/include/string.h" 3 4
extern char *strcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));

extern char *strncpy (char *__restrict __dest,
        const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern char *strcat (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));

extern char *strncat (char *__restrict __dest, const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern int strcmp (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));

extern int strncmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern int strcoll (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));

extern size_t strxfrm (char *__restrict __dest,
         const char *__restrict __src, size_t __n)
    __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2))) __attribute__ ((__access__ (__write_only__, 1, 3)));



# 1 "/usr/include/aarch64-linux-gnu/bits/types/locale_t.h" 1 3 4
# 22 "/usr/include/aarch64-linux-gnu/bits/types/locale_t.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/types/__locale_t.h" 1 3 4
# 27 "/usr/include/aarch64-linux-gnu/bits/types/__locale_t.h" 3 4
struct __locale_struct
{

  struct __locale_data *__locales[13];


  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;


  const char *__names[13];
};

typedef struct __locale_struct *__locale_t;
# 23 "/usr/include/aarch64-linux-gnu/bits/types/locale_t.h" 2 3 4

typedef __locale_t locale_t;
# 173 "/usr/include/string.h" 2 3 4


extern int strcoll_l (const char *__s1, const char *__s2, locale_t __l)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 3)));


extern size_t strxfrm_l (char *__dest, const char *__src, size_t __n,
    locale_t __l) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 4)))
     __attribute__ ((__access__ (__write_only__, 1, 3)));





extern char *strdup (const char *__s)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));






extern char *strndup (const char *__string, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));
# 246 "/usr/include/string.h" 3 4
extern char *strchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 273 "/usr/include/string.h" 3 4
extern char *strrchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 286 "/usr/include/string.h" 3 4
extern char *strchrnul (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));





extern size_t strcspn (const char *__s, const char *__reject)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern size_t strspn (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 323 "/usr/include/string.h" 3 4
extern char *strpbrk (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 350 "/usr/include/string.h" 3 4
extern char *strstr (const char *__haystack, const char *__needle)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));




extern char *strtok (char *__restrict __s, const char *__restrict __delim)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));



extern char *__strtok_r (char *__restrict __s,
    const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 3)));

extern char *strtok_r (char *__restrict __s, const char *__restrict __delim,
         char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 3)));
# 380 "/usr/include/string.h" 3 4
extern char *strcasestr (const char *__haystack, const char *__needle)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));







extern void *memmem (const void *__haystack, size_t __haystacklen,
       const void *__needle, size_t __needlelen)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 3)))
    __attribute__ ((__access__ (__read_only__, 1, 2)))
    __attribute__ ((__access__ (__read_only__, 3, 4)));



extern void *__mempcpy (void *__restrict __dest,
   const void *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *mempcpy (void *__restrict __dest,
        const void *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));




extern size_t strlen (const char *__s)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));




extern size_t strnlen (const char *__string, size_t __maxlen)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));




extern char *strerror (int __errnum) __attribute__ ((__nothrow__ , __leaf__));
# 432 "/usr/include/string.h" 3 4
extern int strerror_r (int __errnum, char *__buf, size_t __buflen) __asm__ ("" "__xpg_strerror_r") __attribute__ ((__nothrow__ , __leaf__))

                        __attribute__ ((__nonnull__ (2)))
    __attribute__ ((__access__ (__write_only__, 2, 3)));
# 458 "/usr/include/string.h" 3 4
extern char *strerror_l (int __errnum, locale_t __l) __attribute__ ((__nothrow__ , __leaf__));



# 1 "/usr/include/strings.h" 1 3 4
# 23 "/usr/include/strings.h" 3 4
# 1 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stddef.h" 1 3 4
# 24 "/usr/include/strings.h" 2 3 4










extern int bcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern void bcopy (const void *__src, void *__dest, size_t __n)
  __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern void bzero (void *__s, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
# 68 "/usr/include/strings.h" 3 4
extern char *index (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 96 "/usr/include/strings.h" 3 4
extern char *rindex (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));






extern int ffs (int __i) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));





extern int ffsl (long int __l) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
__extension__ extern int ffsll (long long int __ll)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));



extern int strcasecmp (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern int strncasecmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));






extern int strcasecmp_l (const char *__s1, const char *__s2, locale_t __loc)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 3)));



extern int strncasecmp_l (const char *__s1, const char *__s2,
     size_t __n, locale_t __loc)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 4)));



# 463 "/usr/include/string.h" 2 3 4



extern void explicit_bzero (void *__s, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)))
    __attribute__ ((__access__ (__write_only__, 1, 2)));



extern char *strsep (char **__restrict __stringp,
       const char *__restrict __delim)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));




extern char *strsignal (int __sig) __attribute__ ((__nothrow__ , __leaf__));
# 489 "/usr/include/string.h" 3 4
extern char *__stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));



extern char *__stpncpy (char *__restrict __dest,
   const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpncpy (char *__restrict __dest,
        const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));




extern size_t strlcpy (char *__restrict __dest,
         const char *__restrict __src, size_t __n)
  __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2))) __attribute__ ((__access__ (__write_only__, 1, 3)));



extern size_t strlcat (char *__restrict __dest,
         const char *__restrict __src, size_t __n)
  __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2))) __attribute__ ((__access__ (__read_write__, 1, 3)));
# 552 "/usr/include/string.h" 3 4

# 2 "encrypt.c" 2
# 1 "api.h" 1



# 1 "lac_param.h" 1
# 5 "api.h" 2
# 14 "api.h"

# 14 "api.h"
int crypto_encrypt_keypair( unsigned char *pk, unsigned char *sk);
int crypto_encrypt( unsigned char *c, unsigned long long *clen, const unsigned char *m, unsigned long long mlen, const unsigned char *pk);
int crypto_encrypt_open(unsigned char *m, unsigned long long *mlen,const unsigned char *c, unsigned long long clen,const unsigned char *sk);

int kg(unsigned char *pk, unsigned char *sk);

int kg_seed(unsigned char *pk, unsigned char *sk, unsigned char *seed);

int pke_enc(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen);

int pke_enc_seed(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen, unsigned char *seed);

int pke_dec(const unsigned char *sk, const unsigned char *c, unsigned long long clen, unsigned char *m, unsigned long long *mlen);


int crypto_kem_keypair( unsigned char *pk, unsigned char *sk);
int crypto_kem_enc( unsigned char *ct, unsigned char *ss, const unsigned char *pk);
int crypto_kem_dec( unsigned char *ss, const unsigned char *ct, const unsigned char *sk);

int kem_enc_fo(const unsigned char *pk, unsigned char *k, unsigned char *c);

int kem_enc_fo_seed(const unsigned char *pk, unsigned char *k, unsigned char *c, unsigned char *seed);

int kem_dec_fo(const unsigned char *pk, const unsigned char *sk, const unsigned char *c, unsigned char *k);



int crypto_ke_alice_send(unsigned char *pk,unsigned char *sk);

int crypto_ke_bob_receive(unsigned char *pk, unsigned char *c, unsigned char *k);

int crypto_ke_alice_receive(unsigned char *pk, unsigned char *sk, unsigned char *c, unsigned char *k);



int crypto_ake_alice_send(unsigned char *pk,unsigned char *sk, unsigned char *pk_b, unsigned char *sk_a, unsigned char *c, unsigned char *k1);

int crypto_ake_bob_receive(unsigned char *pk_b, unsigned char *sk_b, unsigned char *pk_a, unsigned char *pk, unsigned char *c_in, unsigned char *c_out, unsigned char *k);

int crypto_ake_alice_receive(unsigned char *pk_a, unsigned char *sk_a,unsigned char *pk_b, unsigned char *pk, unsigned char *sk, unsigned char *c1, unsigned char *c_in, unsigned char *k1, unsigned char *k);
# 3 "encrypt.c" 2
# 1 "rand.h" 1

int random_bytes(unsigned char *r, unsigned int len);

int pseudo_random_bytes(unsigned char *r, unsigned int len, const unsigned char *seed);

int hash(const unsigned char *in, unsigned int len_in, unsigned char * out);

int gen_seed(unsigned char *in, unsigned int len_in, unsigned char * out);
# 4 "encrypt.c" 2
# 1 "bch.h" 1
# 32 "bch.h"
# 1 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stdint.h" 1 3 4
# 9 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stdint.h" 3 4
# 1 "/usr/include/stdint.h" 1 3 4
# 26 "/usr/include/stdint.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 27 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/types.h" 1 3 4
# 27 "/usr/include/aarch64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/wordsize.h" 1 3 4
# 28 "/usr/include/aarch64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/timesize.h" 1 3 4
# 29 "/usr/include/aarch64-linux-gnu/bits/types.h" 2 3 4



# 31 "/usr/include/aarch64-linux-gnu/bits/types.h" 3 4
typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;


typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;






typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;



typedef long int __quad_t;
typedef unsigned long int __u_quad_t;







typedef long int __intmax_t;
typedef unsigned long int __uintmax_t;
# 141 "/usr/include/aarch64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/typesizes.h" 1 3 4
# 142 "/usr/include/aarch64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/time64.h" 1 3 4
# 143 "/usr/include/aarch64-linux-gnu/bits/types.h" 2 3 4


typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __suseconds64_t;

typedef int __daddr_t;
typedef int __key_t;


typedef int __clockid_t;


typedef void * __timer_t;


typedef int __blksize_t;




typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;


typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;


typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;


typedef long int __fsword_t;

typedef long int __ssize_t;


typedef long int __syscall_slong_t;

typedef unsigned long int __syscall_ulong_t;



typedef __off64_t __loff_t;
typedef char *__caddr_t;


typedef long int __intptr_t;


typedef unsigned int __socklen_t;




typedef int __sig_atomic_t;
# 28 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/wchar.h" 1 3 4
# 29 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/aarch64-linux-gnu/bits/wordsize.h" 1 3 4
# 30 "/usr/include/stdint.h" 2 3 4




# 1 "/usr/include/aarch64-linux-gnu/bits/stdint-intn.h" 1 3 4
# 24 "/usr/include/aarch64-linux-gnu/bits/stdint-intn.h" 3 4
typedef __int8_t int8_t;
typedef __int16_t int16_t;
typedef __int32_t int32_t;
typedef __int64_t int64_t;
# 35 "/usr/include/stdint.h" 2 3 4


# 1 "/usr/include/aarch64-linux-gnu/bits/stdint-uintn.h" 1 3 4
# 24 "/usr/include/aarch64-linux-gnu/bits/stdint-uintn.h" 3 4
typedef __uint8_t uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
# 38 "/usr/include/stdint.h" 2 3 4



# 1 "/usr/include/aarch64-linux-gnu/bits/stdint-least.h" 1 3 4
# 25 "/usr/include/aarch64-linux-gnu/bits/stdint-least.h" 3 4
typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;


typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;
# 42 "/usr/include/stdint.h" 2 3 4





typedef signed char int_fast8_t;

typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
# 60 "/usr/include/stdint.h" 3 4
typedef unsigned char uint_fast8_t;

typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
# 76 "/usr/include/stdint.h" 3 4
typedef long int intptr_t;


typedef unsigned long int uintptr_t;
# 90 "/usr/include/stdint.h" 3 4
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
# 10 "/usr/lib/gcc/aarch64-linux-gnu/13/include/stdint.h" 2 3 4
# 33 "bch.h" 2
# 53 "bch.h"

# 53 "bch.h"
struct bch_control {
 unsigned int m;
 unsigned int n;
 unsigned int t;
 unsigned int ecc_bits;
 unsigned int ecc_bytes;

 uint16_t *a_pow_tab;
 uint16_t *a_log_tab;
 uint32_t *mod8_tab;
 uint32_t *ecc_buf;
 uint32_t *ecc_buf2;
 unsigned int *xi_tab;
 unsigned int *syn;
 int *cache;
 struct gf_poly *elp;
 struct gf_poly *poly_2t[4];
};

struct bch_control *init_bch(int m, int t, unsigned int prim_poly);

void free_bch(struct bch_control *bch);

void encode_bch(struct bch_control *bch, const uint8_t *data,
  unsigned int len, uint8_t *ecc);

void compute_even_syndromes(struct bch_control *bch, unsigned int *syn);

int decode_bch(struct bch_control *bch, const uint8_t *data, unsigned int len,
        const uint8_t *recv_ecc, const uint8_t *calc_ecc,
        const unsigned int *syn, unsigned int *errloc);
# 5 "encrypt.c" 2
# 1 "ecc.h" 1
# 1 "lac_param.h" 1
# 2 "ecc.h" 2
# 37 "ecc.h"
int ecc_enc(const unsigned char *d, unsigned char *c);


int ecc_dec(unsigned char *d, const unsigned char *c);
# 6 "encrypt.c" 2
# 1 "bin-lwe.h" 1



int gen_a(unsigned char *a, const unsigned char *seed);

int gen_psi_std(char *e, unsigned int vec_num, unsigned char *seed);

int gen_psi_fix_ham(char *e, unsigned int vec_num, unsigned char *seed);

int poly_mul(const unsigned char *a, const char *s, unsigned char *b, unsigned int vec_num);

int poly_aff(const unsigned char *a, const char *s, char *e, unsigned char *b, unsigned int vec_num);

int poly_compress(const unsigned char *in, unsigned char *out, const unsigned int vec_num);

int poly_decompress(const unsigned char *in, unsigned char *out, const unsigned int vec_num);
# 7 "encrypt.c" 2




int crypto_encrypt_keypair( unsigned char *pk, unsigned char *sk)
{

 if(pk==
# 14 "encrypt.c" 3 4
       ((void *)0) 
# 14 "encrypt.c"
            || sk==
# 14 "encrypt.c" 3 4
                   ((void *)0)
# 14 "encrypt.c"
                       )
 {
  return -1;
 }
 kg(pk,sk);

 return 0;
}


int crypto_encrypt( unsigned char *c, unsigned long long *clen, const unsigned char *m, unsigned long long mlen, const unsigned char *pk)
{

 if(c==
# 27 "encrypt.c" 3 4
      ((void *)0) 
# 27 "encrypt.c"
           || m==
# 27 "encrypt.c" 3 4
                 ((void *)0) 
# 27 "encrypt.c"
                      || pk==
# 27 "encrypt.c" 3 4
                             ((void *)0)
# 27 "encrypt.c"
                                 )
 {
  return -1;
 }
 if(mlen>32)
 {
  return -1;
 }


 pke_enc(pk,m, mlen,c,clen);

 return 0;
}

int crypto_encrypt_open(unsigned char *m, unsigned long long *mlen,const unsigned char *c, unsigned long long clen,const unsigned char *sk)
{

 if(sk==
# 45 "encrypt.c" 3 4
       ((void *)0) 
# 45 "encrypt.c"
            || m==
# 45 "encrypt.c" 3 4
                  ((void *)0) 
# 45 "encrypt.c"
                       || c==
# 45 "encrypt.c" 3 4
                             ((void *)0) 
# 45 "encrypt.c"
                                  || mlen==
# 45 "encrypt.c" 3 4
                                           ((void *)0)
# 45 "encrypt.c"
                                               )
 {
  return -1;
 }


 pke_dec(sk,c,clen,m,mlen);

 return 0;
}


int kg_seed(unsigned char *pk, unsigned char *sk, unsigned char *seed)
{
 unsigned char seeds[3*32];
 unsigned char a[512];
 char e[512];

 if(pk==
# 63 "encrypt.c" 3 4
       ((void *)0) 
# 63 "encrypt.c"
            || sk==
# 63 "encrypt.c" 3 4
                   ((void *)0)
# 63 "encrypt.c"
                       )
 {
  return -1;
 }

 pseudo_random_bytes(seeds,3*32,seed);

 memcpy(pk,seeds,32);

 gen_a(a,pk);

 gen_psi_fix_ham((char*)sk,512,seeds+32);
 gen_psi_fix_ham((char*)e,512,seeds+2*32);

 poly_aff(a,(char *)sk,e,pk+32,512);

 memcpy(sk+512,pk,544);
 return 0;
}


int kg(unsigned char *pk, unsigned char *sk)
{
 unsigned char seed[32];


 random_bytes(seed,32);

 kg_seed(pk,sk,seed);

 return 0;
}

int pke_enc(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen)
{
 unsigned char seed[32];


 random_bytes(seed,32);

 pke_enc_seed(pk,m,mlen,c,clen,seed);

 return 0;
}

int pke_dec(const unsigned char *sk, const unsigned char *c,unsigned long long clen, unsigned char *m, unsigned long long *mlen)
{
 unsigned char out[512];
 unsigned char code[64],*p_code;
 unsigned char c2[400];
 int i,c2_len=(clen-512)*2;
 unsigned char m_buf[32];


 if(sk==
# 117 "encrypt.c" 3 4
       ((void *)0) 
# 117 "encrypt.c"
            || m==
# 117 "encrypt.c" 3 4
                  ((void *)0) 
# 117 "encrypt.c"
                       || c==
# 117 "encrypt.c" 3 4
                             ((void *)0)
# 117 "encrypt.c"
                                 )
 {
  return -1;
 }
# 171 "encrypt.c"
 int temp;
 int low=251/4;
 int high=251*3/4;

 poly_decompress(c+512,c2,c2_len);

 poly_mul(c,(char*)sk,out,512);

 *mlen=c2_len/8-18;

 memset(code,0,64);

 p_code=code+(32 -(*mlen));

 for(i=0;i<c2_len;i++)
 {

  temp=(c2[i]-out[i]+251)%251;


  if(temp>=low && temp<high)
  {
   p_code[i/8]=p_code[i/8]^(1<<(i%8));
  }
 }


 ecc_dec(m_buf,code);

 memcpy(m,m_buf+(32 -(*mlen)),*mlen);


 return 0;
}


int pke_enc_seed(const unsigned char *pk, const unsigned char *m, unsigned long long mlen, unsigned char *c, unsigned long long *clen, unsigned char *seed)
{
 unsigned char code[64],seeds[3*32],*p_code;
 char r[512];
 char e1[512],e2[400];
 unsigned char c2[400];
 unsigned char a[512];
 unsigned char m_buf[32];
 int i,c2_len;


 if(pk==
# 218 "encrypt.c" 3 4
       ((void *)0) 
# 218 "encrypt.c"
            || m==
# 218 "encrypt.c" 3 4
                  ((void *)0) 
# 218 "encrypt.c"
                       || c==
# 218 "encrypt.c" 3 4
                             ((void *)0) 
# 218 "encrypt.c"
                                  )
 {
  return -1;
 }
 if(mlen>32)
 {
  return -1;
 }


 gen_a(a,pk);

 memset(m_buf,0,32);

 memcpy(m_buf+(32 -mlen),m,mlen);

 ecc_enc(m_buf,code);

 p_code=code+(32 -mlen);

 pseudo_random_bytes(seeds,3*32,seed);

 gen_psi_fix_ham(r,512,seeds);

 gen_psi_fix_ham(e1,512,seeds+32);

 poly_aff(a,r,e1,c,512);
# 269 "encrypt.c"
 c2_len=(mlen+18)*8;

 gen_psi_std(e2,c2_len,seeds+2*32);

 for(i=0;i<c2_len;i++)
 {

  e2[i]=e2[i]+125*((p_code[i/8]>>(i%8))&1);
 }


 poly_aff(pk+32,r,e2,c2,c2_len);

 poly_compress(c2,c+512,c2_len);
 *clen=512 +c2_len/2;

 return 0;

}
