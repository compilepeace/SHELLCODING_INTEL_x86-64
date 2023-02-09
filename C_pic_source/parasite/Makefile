.PHONY:	clean

CFLAGS = -g -Wl,-N -static -nostdlib
all: parasite

parasite: parasite.c x_syscall.c
	gcc ${CFLAGS} $^ -o $@.elf

clean:
	rm -f *.elf 
