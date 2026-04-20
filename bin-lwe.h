#include <stdint.h>
#include "compat.h"
//generate the public parameter a from seed
int gen_a(unsigned char *a,  const unsigned char *seed);
//generate the small random vector for secret and error
int gen_psi_std(lac_small_t *e, unsigned int vec_num, unsigned char *seed);
//generate the small random vector for secret and error
int gen_psi_fix_ham(lac_small_t *e, unsigned int vec_num, unsigned char *seed);
int gen_psi_fix_ham_ct(lac_small_t *e, unsigned int vec_num, unsigned char *seed);
// poly_mul  b=[as]
int poly_mul(const unsigned char *a, const lac_small_t *s, unsigned char *b, unsigned int  vec_num);
// poly_aff  b=as+e 
int poly_aff(const unsigned char *a, const  lac_small_t *s, lac_small_t *e, unsigned char *b, unsigned int vec_num);
// compress: cut the low 4bit
int poly_compress(const unsigned char *in,  unsigned char *out, const unsigned int vec_num);
// de-compress: set the low 4bit to be zero
int poly_decompress(const unsigned char *in, unsigned char *out, const unsigned int vec_num);