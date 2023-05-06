.PHONY:	clean

# We choose GCC to assemble and link, but it can separately be done by invoking as & ld as below -
#$ arm-linux-gnueabi-as ./execve_binsh.s -o ./execve_binsh.o && arm-linux-gnueabi-ld -N ./execve_binsh.o -o ./execve_binsh.elf

CC = arm-linux-gnueabi-gcc
CFLAGS = -Wl,-N -nostdlib -static -g
OBJCOPY = arm-linux-gnueabi-objcopy
all: msg_to_stdout template harness execve_binsh setuid_execve_binsh bind_shell setuid_bind_shell reverse_shell setuid_reverse_shell execve chmod_symlink

msg_to_stdout: msg_to_stdout.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

template: template.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

execve_binsh: execve_binsh.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

setuid_execve_binsh: setuid_execve_binsh.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

bind_shell: bind_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

setuid_bind_shell: setuid_bind_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

reverse_shell: reverse_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

setuid_reverse_shell: setuid_reverse_shell.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

execve: execve.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

chmod_symlink: chmod_symlink.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

xxx: xxx.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf
	
	
# use emulator to RUN arm compiled binary
# $ qemu-arm-static -L "/usr/arm-linux-gnueabi/" ./harness.elf < ./msg_to_stdout.raw
harness: harness.c
	${CC} -g -z execstack -fno-stack-protector $< -o $@.elf
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw *.o
