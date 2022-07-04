.PHONY:	clean

CFLAGS = -g 
all: reverse_shell

reverse_shell: reverse_shell.c
	gcc ${CFLAGS} $< -o $@.elf

clean:
	rm -f *.elf 
