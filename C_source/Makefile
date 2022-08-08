.PHONY:	clean

CFLAGS = -g -nostdlib -static
all: inline_syscalls reverse_shell

inline_syscalls: inline_syscalls.c
	gcc ${CFLAGS} $< -o $@.elf

reverse_shell: reverse_shell.c
	gcc -g $< -o $@.elf

clean:
	rm -f *.elf 
