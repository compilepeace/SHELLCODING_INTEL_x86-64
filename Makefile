.PHONY:	clean

CFLAGS = -Wl,-N -nostdlib -static -g
all: exit chmod_symlink setuid_execve_binsh execve execve_binsh harness 

exit: exit.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

chmod_symlink: chmod_symlink.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

setuid_execve_binsh: setuid_execve_binsh.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

execve: execve.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

execve_binsh: execve_binsh.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf


harness: harness.c
	gcc -z execstack -fno-stack-protector $< -o $@.elf
	
clean:
	rm -f *.elf *.raw
