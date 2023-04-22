.PHONY:	clean

CC = gcc
CFLAGS = -Wl,-N -nostdlib -static -g
OBJCOPY = objcopy
all: msg_to_stdout setuid_reverse_shell reverse_shell exit chmod_symlink setuid_execve_binsh execve execve_binsh harness 

msg_to_stdout: msg_to_stdout.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf
	
setuid_reverse_shell: setuid_reverse_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

reverse_shell: reverse_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

exit: exit.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

chmod_symlink: chmod_symlink.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

setuid_execve_binsh: setuid_execve_binsh.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

execve: execve.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

execve_binsh: execve_binsh.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf


harness: harness.c
	${CC} -g -z execstack -fno-stack-protector $< -o $@.elf
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw *.o
