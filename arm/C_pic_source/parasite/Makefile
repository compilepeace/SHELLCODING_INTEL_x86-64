.PHONY:	clean

CFLAGS = -g -Wl,-N -static -nostdlib -fpic
all: parasite

# while compiling into final binary:
# the position of generated machine code ($objdump -d ./parasite.elf)
# depends on the order of *.c files. If parasite.c occurs prior to x_syscall.c
# then parasite.o (object code) will be placed before x_syscall.o's object code.
# Decide the position of function object code appropriately as the parasite
# code might need to replicate/copy its entire body which would require it
# to copy its own CODE segments (startLabel-to-endLabel)
parasite: parasite.c x_syscall.c
	gcc ${CFLAGS} $^ -o $@.elf

clean:
	rm -f *.elf 
