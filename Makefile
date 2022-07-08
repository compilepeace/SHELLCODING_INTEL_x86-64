.PHONY:	clean

CFLAGS = -Wl,-N -nostdlib -static -g
all: msg_to_stdout setuid_reverse_shell reverse_shell exit chmod_symlink setuid_execve_binsh execve execve_binsh harness 

msg_to_stdout: msg_to_stdout.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf
	
setuid_reverse_shell: setuid_reverse_shell.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

reverse_shell: reverse_shell.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

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
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw
