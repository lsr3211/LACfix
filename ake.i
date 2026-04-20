# 0 "ake.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "ake.c"
# 1 "api.h" 1



# 1 "lac_param.h" 1
# 5 "api.h" 2
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
# 2 "ake.c" 2
# 1 "rand.h" 1

int random_bytes(unsigned char *r, unsigned int len);

int pseudo_random_bytes(unsigned char *r, unsigned int len, const unsigned char *seed);

int hash(const unsigned char *in, unsigned int len_in, unsigned char * out);

int gen_seed(unsigned char *in, unsigned int len_in, unsigned char * out);
# 3 "ake.c" 2
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

# 4 "ake.c" 2



# 6 "ake.c"
int crypto_ake_alice_send(unsigned char *pk,unsigned char *sk, unsigned char *pk_b, unsigned char *sk_a, unsigned char *c, unsigned char *k1)
{
 unsigned char seed[32],buf[512 +544 +32];

 if(pk==
# 10 "ake.c" 3 4
       ((void *)0) 
# 10 "ake.c"
            || sk==
# 10 "ake.c" 3 4
                   ((void *)0) 
# 10 "ake.c"
                        || pk_b==
# 10 "ake.c" 3 4
                                 ((void *)0) 
# 10 "ake.c"
                                      || k1==
# 10 "ake.c" 3 4
                                             ((void *)0)
# 10 "ake.c"
                                                 )
 {
  return -1;
 }

 kg(pk,sk);

 random_bytes(buf,32);
 memcpy(buf+32,sk_a,512 +544);
 gen_seed(buf,512 +544 +32,seed);

 kem_enc_fo_seed(pk_b,k1,c,seed);

 return 0;
}

int crypto_ake_bob_receive(unsigned char *pk_b, unsigned char *sk_b, unsigned char *pk_a, unsigned char *pk, unsigned char *c_in,unsigned char *c_out , unsigned char *k)
{
 unsigned char k1[32],k2[32],k3[32];
 unsigned char in[3*32 +3*544 +712],seed[32];
 unsigned char buf[512 +544 +32];
 unsigned long long clen;

 if(pk_b==
# 33 "ake.c" 3 4
         ((void *)0) 
# 33 "ake.c"
              || sk_b==
# 33 "ake.c" 3 4
                       ((void *)0)
# 33 "ake.c"
                           || pk_a==
# 33 "ake.c" 3 4
                                    ((void *)0) 
# 33 "ake.c"
                                         || pk==
# 33 "ake.c" 3 4
                                                ((void *)0)
# 33 "ake.c"
                                                    || c_in==
# 33 "ake.c" 3 4
                                                             ((void *)0) 
# 33 "ake.c"
                                                                  || c_out==
# 33 "ake.c" 3 4
                                                                            ((void *)0) 
# 33 "ake.c"
                                                                                 || k==
# 33 "ake.c" 3 4
                                                                                       ((void *)0)
# 33 "ake.c"
                                                                                           )
 {
  return -1;
 }


 random_bytes(buf,32);
 memcpy(buf+32,sk_b,512 +544);
 gen_seed(buf,512 +544 +32,seed);

 kem_enc_fo_seed(pk_a,k2,c_out,seed);


 random_bytes(k3,32);
 pke_enc(pk,k3,32,c_out+712,&clen);


 kem_dec_fo(pk_b,sk_b,c_in,k1);


 memcpy(in,pk_a,544);
 memcpy(in+544,pk_b,544);
 memcpy(in+2*544,pk,544);


 memcpy(in+3*544,c_out+712,712);

 memcpy(in+3*544 +712,k1,32);
 memcpy(in+3*544 +712 +32,k2,32);
 memcpy(in+3*544 +712 +2*32,k3,32);

 hash(in,3*32 +3*544 +712,k);

 return 0;
}

int crypto_ake_alice_receive(unsigned char *pk_a, unsigned char *sk_a, unsigned char *pk_b, unsigned char *pk, unsigned char *sk, unsigned char *c1, unsigned char *c_in, unsigned char *k1, unsigned char *k)
{
 unsigned char k2[32],k3[32];
 unsigned char in[3*32 +3*544 +712];
 unsigned long long mlen;

 if(pk_a==
# 75 "ake.c" 3 4
         ((void *)0) 
# 75 "ake.c"
              || sk_a==
# 75 "ake.c" 3 4
                       ((void *)0)
# 75 "ake.c"
                           || pk==
# 75 "ake.c" 3 4
                                  ((void *)0) 
# 75 "ake.c"
                                       || sk==
# 75 "ake.c" 3 4
                                              ((void *)0) 
# 75 "ake.c"
                                                   || c_in==
# 75 "ake.c" 3 4
                                                            ((void *)0) 
# 75 "ake.c"
                                                                 || k1==
# 75 "ake.c" 3 4
                                                                        ((void *)0) 
# 75 "ake.c"
                                                                             || k==
# 75 "ake.c" 3 4
                                                                                   ((void *)0)
# 75 "ake.c"
                                                                                       )
 {
  return -1;
 }

 kem_dec_fo(pk_a,sk_a,c_in,k2);


 pke_dec(sk,c_in+712,712,k3,&mlen);


 memcpy(in,pk_a,544);
 memcpy(in+544,pk_b,544);
 memcpy(in+2*544,pk,544);

 memcpy(in+3*544,c_in+712,712);

 memcpy(in+3*544 +712,k1,32);
 memcpy(in+3*544 +712 +32,k2,32);
 memcpy(in+3*544 +712 +2*32,k3,32);

 hash(in,3*32 +3*544 +712,k);

 return 0;
}
