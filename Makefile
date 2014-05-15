PREFIX=/usr/local/

LIB=librf24-sunxi
LIBNAME=$(LIB).so.1.0
OBJDIR=obj/
LIBDIR=lib/

CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard

all:librf24-sun7i

librf24-sun7i:${OBJDIR}spi.o ${OBJDIR}gpio.o ${OBJDIR}RF24.o
	g++ -shared -Wl,-soname,$@.so.1 ${CCFLAGS} -o ${LIBDIR}${LIBNAME} $^

${OBJDIR}spi.o:src/spi.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

${OBJDIR}gpio.o:src/gpio.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

${OBJDIR}RF24.o:src/RF24.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

clean:
	rm -rf ${OBJDIR}*.o ${LIBDIR}${LIBNAME}

install:
	@echo "[Install]"
	@if ( test ! -d ${PREFIX}lib ) ; then mkdir -p ${PREFIX}lib ; fi
	@install -m 0755 ${LIBDIR}${LIBNAME} ${PREFIX}${LIBDIR}
	@ln -sf ${LIBDIR}${LIBNAME} ${PREFIX}${LIBDIR}${LIB}.so.1
	@ln -sf ${PREFIX}${LIBDIR}${LIB}.so.1 ${PREFIX}${LIBDIR}${LIB}.so
	@ldconfig
