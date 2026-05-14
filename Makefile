objects = main.o test_correctness.o test_cpucycles.o test_speed.o \
          ake.o ke.o kem.o encrypt.o ecc.o bch.o bin-lwe.o rand.o rng.o
generated = $(objects:.o=.i) $(objects:.o=.s)

CC = gcc
OPENSSL_PREFIX ?= /opt/homebrew/opt/openssl@3
PROFILE ?= CT
# 默认 CT，要切换就 make PROFILE=STD 或 make PROFILE=CTNEON
PARAM ?= LAC128
NEON ?= AUTO
CTESTS ?= 10000
BENCH_NTESTS ?= 10000
BCH_NTESTS ?= 1000

ifdef profile
PROFILE := $(profile)
endif

ifdef param
PARAM := $(param)
endif

BASE_CFLAGS = -O3 -Wall -DNDEBUG -DLAC_SIGNED_CHAR \
              -DCTESTS=$(CTESTS) -DNTESTS=$(BENCH_NTESTS) \
              -DBCH_NTESTS=$(BCH_NTESTS) -I$(OPENSSL_PREFIX)/include
LDLIBS = -L$(OPENSSL_PREFIX)/lib -lcrypto -lz

ifeq ($(PARAM),LAC128)
PARAM_CFLAGS = -DLAC128
else ifeq ($(PARAM),LAC192)
PARAM_CFLAGS = -DLAC192
else ifeq ($(PARAM),LAC256)
PARAM_CFLAGS = -DLAC256
else
$(error Unsupported PARAM '$(PARAM)'. Use PARAM=LAC128, PARAM=LAC192, or PARAM=LAC256)
endif

ifeq ($(PROFILE),STD)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_STD
else ifeq ($(PROFILE),CT)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_CT
else ifeq ($(PROFILE),CTNEON)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_CT_NEON
else ifeq ($(PROFILE),CT_NEON)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_CT_NEON
else
$(error Unsupported PROFILE '$(PROFILE)'. Use PROFILE=STD, PROFILE=CT, or PROFILE=CTNEON)
endif

ifeq ($(NEON),AUTO)
ifeq ($(PROFILE),CTNEON)
NEON_CFLAGS = -DLAC_CFG_CT_NEON=1
else ifeq ($(PROFILE),CT_NEON)
NEON_CFLAGS = -DLAC_CFG_CT_NEON=1
else
NEON_CFLAGS = -DLAC_CFG_CT_NEON=0
endif
else ifeq ($(NEON),ON)
ifeq ($(PROFILE),STD)
$(error NEON=ON requires PROFILE=CT or PROFILE=CTNEON)
endif
NEON_CFLAGS = -DLAC_CFG_CT_NEON=1
else ifeq ($(NEON),OFF)
NEON_CFLAGS = -DLAC_CFG_CT_NEON=0
else
$(error Unsupported NEON '$(NEON)'. Use NEON=AUTO, NEON=OFF, or NEON=ON)
endif

EXTRA_CFLAGS ?=
CFLAGS = $(BASE_CFLAGS) $(PARAM_CFLAGS) $(PROFILE_CFLAGS) $(NEON_CFLAGS) $(EXTRA_CFLAGS)

lac : $(objects)
	$(CC) -o lac $(objects) $(LDLIBS)

main.o: main.c test_correctness.h test_cpucycles.h test_speed.h api.h lac_param.h
	$(CC) -c main.c $(CFLAGS)

test_correctness.o: test_correctness.c api.h ecc.h rand.h lac_param.h
	$(CC) -c test_correctness.c $(CFLAGS)

test_cpucycles.o: test_cpucycles.c api.h rand.h ecc.h lac_param.h
	$(CC) -c test_cpucycles.c $(CFLAGS)

test_speed.o: test_speed.c api.h rand.h ecc.h lac_param.h
	$(CC) -c test_speed.c $(CFLAGS)

ake.o: ake.c api.h rand.h lac_param.h
	$(CC) -c ake.c $(CFLAGS)

ke.o: ke.c api.h rand.h lac_param.h
	$(CC) -c ke.c $(CFLAGS)

kem.o: kem.c api.h rand.h ecc.h bin-lwe.h lac_param.h
	$(CC) -c kem.c $(CFLAGS)

encrypt.o: encrypt.c api.h rand.h ecc.h bin-lwe.h lac_param.h 
	$(CC) -c encrypt.c $(CFLAGS)

ecc.o: ecc.c bch.h ecc.h lac_param.h bch128.h bch192.h bch256.h
	$(CC) -c ecc.c $(CFLAGS)

bch.o: bch.c bch.h compat.h
	$(CC) -c bch.c $(CFLAGS)

bin-lwe.o: bin-lwe.c lac_param.h rand.h bin-lwe.h 
	$(CC) -c bin-lwe.c $(CFLAGS)

rand.o: rand.c lac_param.h rand.h
	$(CC) -c rand.c $(CFLAGS) 

rng.o: rng.c rng.h
	$(CC) -c rng.c $(CFLAGS) 

.PHONY: clean
clean:
	rm -f lac lac.exe $(objects) $(generated) perf.data perf_kem.data


          
