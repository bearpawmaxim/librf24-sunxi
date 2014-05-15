LIBNAME=rf24-sunxi
LIBDIR=../lib/

all:pingtest scanner

pingtest:
	g++ pingtest.cpp -I../src/ -L${LIBDIR} -l${LIBNAME} -o pingtest

scanner:
	g++ scanner.cpp -I../src/ -L${LIBDIR} -l${LIBNAME} -o scanner

clean:
	rm -f scanner pingtest
