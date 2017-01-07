# file: Makefile
#
# To compile semia from the sources in this directory, type 'make'.

CC = g++
CFLAGS = -I/usr/openwin/include -I/usr/include -DMAIN
LDFLAGS = -L/usr/openwin/lib -L/usr/local/lib -L/usr/lib -L/usr/X11R6/lib
LIBS = -lm -lwfdb -lnsl -lxview -lolgx -lX11
OBJS = semia_ui.o semia_stubs.o

# General rule for making foo.o from foo.cc
.cc.o:
	$(CC) $(CFLAGS) -c $< -o $@

semia:		$(OBJS)
	$(CC) -o semia $(OBJS) $(LDFLAGS) $(LIBS)

clean:
	rm -f semia $(OBJS) *~
