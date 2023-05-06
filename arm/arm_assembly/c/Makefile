EMULATOR = qemu-arm-static
EFLAGS = -L /usr/arm-linux-gnueabi/
CC = arm-linux-gnueabi-gcc
CFLAGS = -g
all: scratch

scratch: scratch.c
	${CC} ${CFLAGS} $< -o $@.elf

run:
	${EMULATOR} ${EFLAGS} -g 1234 ./scratch.elf

clean:
	rm -rf ./*.o ./*.elf ./*.dis
