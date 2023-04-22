.PHONY:	clean

CC = arm-linux-gnueabi-gcc
CFLAGS = -Wl,-N -nostdlib -static -g
OBJCOPY = arm-linux-gnueabi-objcopy
all: msg_to_stdout template #setuid_reverse_shell reverse_shell exit chmod_symlink setuid_execve_binsh execve execve_binsh harness 

msg_to_stdout: msg_to_stdout.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

template: template.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf

xxx: xxx.s
	${CC} ${CFLAGS} $< -o $@.elf
	${OBJCOPY} --dump-section .text=$@.raw $@.elf
	
	
harness: harness.c
	${CC} -g -z execstack -fno-stack-protector $< -o $@.elf
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw *.o
