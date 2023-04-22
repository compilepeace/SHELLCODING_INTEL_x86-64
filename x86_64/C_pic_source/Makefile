.PHONY:	clean

CFLAGS = -g -nostdlib -static
all: pic_test #inline_syscalls #reverse_shell

pic_test: pic_test.c
	gcc ${CFLAGS} $< -o @.elf

inline_syscalls: inline_syscalls.c
	gcc ${CFLAGS} $< -o $@.elf

reverse_shell: reverse_shell.c
	gcc -g $< -o $@.elf

clean:
	rm -f *.elf 
