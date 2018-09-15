PROG=segvan
CFLAGS+=-O2 -std=c11
LDFLAGS+=-L./secp256k1/.libs
LDADD=-lgmp -lsecp256k1 -lcrypto

all: gsegvan

gsegvan: secp256k1/.libs/libsecp256k1.a

secp256k1/.libs/libsecp256k1.a:
	if [ ! -f $@ ] ; then \
		(cd secp256k1 && ./configure --enable-static --disable-shared) ; \
		make -C secp256k1 ; \
	fi
	test -f $@

gsegvan: $(PROG).o segwit_addr.o sph_groestl.o groestl.o
	cc $(LDFLAGS) -o $@ $(PROG).o segwit_addr.o sph_groestl.o groestl.o $(LDADD)

install:
	install $(PROG) /usr/local/bin
	install $(PROG).$(MANSEC) /usr/local/man/man1