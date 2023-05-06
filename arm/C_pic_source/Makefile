.PHONY:	clean

CC = arm-linux-gnueabi-gcc
CFLAGS = -g -nostdlib -static
all: bind_shell reverse_shell #pic_test inline_syscalls 

#pic_test: pic_test.c
#	${CC} ${CFLAGS} $< -o @.elf

inline_syscalls: inline_syscalls.c
	${CC} ${CFLAGS} $< -o $@.elf

reverse_shell: reverse_shell.c
	${CC} -g $< -o $@.elf

bind_shell: bind_shell.c
	${CC} -g $< -o $@.elf

clean:
	rm -f *.elf 
