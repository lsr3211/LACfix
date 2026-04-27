objects = main.o test_correctness.o test_cpucycles.o test_speed.o \
          ake.o ke.o kem.o encrypt.o ecc.o bch.o bin-lwe.o rand.o rng.o

CC = gcc
OPENSSL_PREFIX ?= /opt/homebrew/opt/openssl@3
PROFILE ?= CT
//默认CT，要切换就make PROFILE=STD

BASE_CFLAGS = -O3 -Wall -DNDEBUG -DLAC_SIGNED_CHAR -I$(OPENSSL_PREFIX)/include
LDLIBS = -L$(OPENSSL_PREFIX)/lib -lcrypto -lz

ifeq ($(PROFILE),STD)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_STD
else ifeq ($(PROFILE),CT)
PROFILE_CFLAGS = -DLAC_CONFIG_PROFILE=LAC_PROFILE_CT
else
$(error Unsupported PROFILE '$(PROFILE)'. Use PROFILE=STD or PROFILE=CT)
endif

EXTRA_CFLAGS ?=
CFLAGS = $(BASE_CFLAGS) $(PROFILE_CFLAGS) $(EXTRA_CFLAGS)

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

clean:
	rm -f lac lac.exemak $(objects)


          
