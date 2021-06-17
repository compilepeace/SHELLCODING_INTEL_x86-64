

.PHONY:	clean payload runpayload


OBJ_PATH=./OBJECT_FILES/
FILE=test_shellcode


all: exit.o	message.o stack_method_message.o message_rip_relative_addressing.o stack_method_execve.o jmp-call-pop_execve.o xor_decoder_execve.o not_decoder_execve.o insertion_decoder_execve.o mmx-xordecoder.o


exit.o: exit.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@ 


message.o: message.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@


stack_method_message.o: stack_method_message.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

message_rip_relative_addressing.o: message_rip_relative_addressing.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

stack_method_execve.o: stack_method_execve.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

jmp-call-pop_execve.o: jmp-call-pop_execve.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

xor_decoder_execve.o: ./XOR_ENCODER_DECODER/xor_decoder_execve.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

not_decoder_execve.o: ./NOT_ENCODER_DECODER/not_decoder_execve.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

insertion_decoder_execve.o: ./INSERTION_ENCODER_DECODER/insertion_decoder_execve.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@

mmx-xordecoder.o: ./MMX-XOR-ENCODER-DECODER/mmx-xordecoder.asm
	nasm -f elf64 $< -o $(OBJ_PATH)$@


clean:
	rm $(OBJ_PATH)exit.o $(OBJ_PATH)message.o $(OBJ_PATH)stack_method_message.o $(OBJ_PATH)message_rip_relative_addressing.o $(OBJ_PATH)stack_method_execve.o $(OBJ_PATH)jmp-call-pop_execve.o $(OBJ_PATH)xor_decoder_execve.o $(OBJ_PATH)not_decoder_execve.o $(OBJ_PATH)insertion_decoder_execve.o $(OBJ_PATH)mmx-xordecoder.o $(FILE) 


payload:
	gcc -fno-stack-protector -z execstack $(FILE).c -o $(FILE)


runpayload:
	./$(FILE)
