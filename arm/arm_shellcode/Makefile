
all: gcc_generated as_ld_generated

as_ld_generated: asm.s
	arm-linux-gnueabi-as $< -o $@.o 
	arm-linux-gnueabi-ld $@.o -o $@.elf

gcc_generated: asm.s
	arm-linux-gnueabi-gcc -g -Wl,-N -nostdlib -static $< -o $@.elf


clean:
	rm ./*.o ./*.elf
