#include "test_correctness.h"
#include "test_speed.h"
#include "test_cpucycles.h"
#include "rand.h"
#include "api.h"
#include "ecc.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
	int test_poly_aff_cpucycles(void);
	int ret = 0;

	if (ecc_init() != 0)
	{
		printf("ecc_init failed\n");
		return -1;
	}

	if(argc!=2)
	{
		printf("command format:\n");
		printf("lac speed : test the speed of lac\n");
		printf("lac cpucycles: test the cpucycles of lac\n");

		printf("  ./lac cpucycles_pke\n");
        printf("  ./lac cpucycles_kem\n");
        printf("  ./lac cpucycles_ke\n");
        printf("  ./lac cpucycles_ake\n");
        printf("  ./lac cpucycles_gena\n");
        printf("  ./lac cpucycles_genpsi\n");
        printf("  ./lac cpucycles_polymul\n");
        printf("  ./lac cpucycles_hash\n");
        printf("  ./lac cpucycles_aes\n"); 
		printf("  ./lac cpucycles_polyaff\n"); //new fix

		printf("lac correctness: test the correctness of lac\n");
		printf("lac basicblock: test the speed of basic blocks used in lac\n");
	}
	else
	{
		printf("============== test %s ==============\n\n",STRENGTH);
		if(strcmp(argv[1],"speed")==0)
		{
			test_pke_speed();
			test_kem_fo_speed();
			test_ke_speed();
			test_ake_speed();	
		}
		
		if(strcmp(argv[1],"cpucycles")==0)
        {
          test_pke_cpucycles();
           test_kem_fo_cpucycles();
           test_ke_cpucycles();
           test_ake_cpucycles();
        }
        else if(strcmp(argv[1],"cpucycles_pke")==0)
        {
            test_pke_cpucycles();
        }
        else if(strcmp(argv[1],"cpucycles_kem")==0)
        {
            test_kem_fo_cpucycles();
        }
        else if(strcmp(argv[1],"cpucycles_ke")==0)
        {
           test_ke_cpucycles();
        }
        else if(strcmp(argv[1],"cpucycles_ake")==0)
        {
            test_ake_cpucycles();
        }
        else if(strcmp(argv[1],"cpucycles_gena")==0)
        {
            test_gen_a_cpucycles();
        }
            else if(strcmp(argv[1],"cpucycles_genpsi")==0)
        {
			 test_gen_psi_cpucycles();
        }
		else if(strcmp(argv[1],"cpucycles_polymul")==0)
		{
			 test_poly_mul_cpucycles();
			}
        else if(strcmp(argv[1],"cpucycles_hash")==0)
		{
             test_hash_cpucycles();
         }
        else if(strcmp(argv[1],"cpucycles_aes")==0)
        {
            test_aes_cpucycles();
		}
		else if(strcmp(argv[1], "cpucycles_polyaff") == 0)
		{
            test_poly_aff_cpucycles();
          }
		
		if(strcmp(argv[1],"correctness")==0)
		{
			test_pke_correctness();
			test_kem_fo_correctness();
			test_ke_correctness();
			test_ake_correctness();	
		}
		
		if(strcmp(argv[1],"basicblock")==0)
		{
			//test_hash_cpucycles();
			//test_aes_cpucycles();
			test_gen_psi_cpucycles();
			test_gen_a_cpucycles();
			test_poly_mul_cpucycles();
			test_poly_mul_speed();
		}
		printf("============================================\n");
	}

	ret = ecc_free();
	if (ret != 0)
	{
		printf("ecc_free failed\n");
		return -1;
	}

	return 0;
}
