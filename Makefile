PREFIX=/usr/local/

LIB=librf24-sunxi
LIBNAME=$(LIB).so.1.0
OBJDIR=obj/
LIBDIR=lib/

CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard

all:librf24-sun7i

librf24-sun7i:${OBJDIR}spi.o ${OBJDIR}gpio_sun7i.o ${OBJDIR}RF24_SUN7I.o
	g++ -shared -Wl,-soname,$@.so.1 ${CCFLAGS} -o ${LIBDIR}${LIBNAME} $^

librf24-sun4i:${OBJDIR}spi.o ${OBJDIR}gpio_sun4i.o ${OBJDIR}RF24_SUN4I.o
	g++ -shared -Wl,-soname,$@.so.1 ${CCFLAGS} -o ${LIBDIR}${LIBNAME} $^

${OBJDIR}spi.o:src/spi.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

${OBJDIR}gpio_sun7i.o:src/gpio_sun7i.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

${OBJDIR}gpio_sun4i.o:src/gpio_sun4i.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^ -o $@

${OBJDIR}RF24_SUN7I.o:src/RF24.cpp
	g++ -Wall -fPIC ${CCFLAGS} -DGPIO_SUN7I -c $^ -o $@
${OBJDIR}RF24_SUN4I.o:src/RF24.cpp
	g++ -Wall -fPIC ${CCFLAGS} -DGPIO_SUN4I -c $^ -o $@

clean:
	rm -rf ${OBJDIR}*.o ${LIBDIR}${LIBNAME}

install:
	@echo "[Install]"
	@if ( test ! -d ${PREFIX}lib ) ; then mkdir -p ${PREFIX}lib ; fi
	@install -m 0755 ${LIBDIR}${LIBNAME} ${PREFIX}${LIBDIR}
	@ln -sf ${LIBDIR}${LIBNAME} ${PREFIX}${LIBDIR}${LIB}.so.1
	@ln -sf ${PREFIX}${LIBDIR}${LIB}.so.1 ${PREFIX}${LIBDIR}${LIB}.so
	@ldconfig
