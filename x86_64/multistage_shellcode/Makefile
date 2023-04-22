.PHONY:	clean

CFLAGS = -Wl,-N -nostdlib -static -g
all: firststage multistage harness_multistage 

firststage: firststage.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

multistage: multistage.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

harness_multistage: harness_multistage.c
	gcc -z execstack -fno-stack-protector $< -o $@.elf
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw *.o
