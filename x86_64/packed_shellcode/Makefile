.PHONY:	clean

CFLAGS = -Wl,-N -nostdlib -static -g
all: xor_encoder xor_decoder_stub harness_filter


xor_decoder_stub: xor_decoder_stub.s
	gcc ${CFLAGS} $< -o $@.elf
	objcopy --dump-section .text=$@.raw $@.elf

xor_encoder: xor_encoder.c
	gcc $< -o $@.elf

harness_filter: harness_filter.c
	# compile into object code
	gcc -z execstack -fno-stack-protector $< -o $@.elf
	sudo chown root $@.elf
	sudo chmod u+s  $@.elf
	
clean:
	rm -f *.elf *.raw *.o
