

.PHONY:	clean payload runpayload


FILE=test_shellcode


all: exit.o	message.o message_stack_method.o message_rip_relative_addressing.o execve_stack_method.o execve_jmpcallpop.o


exit.o: exit.asm
	nasm -f elf64 $< -o $@ 


message.o: message.asm
	nasm -f elf64 $< -o $@


message_stack_method.o: message_stack_method.asm
	nasm -f elf64 $< -o $@

message_rip_relative_addressing.o: message_rip_relative_addressing.asm
	nasm -f elf64 $< -o $@

execve_stack_method.o: execve_stack_method.asm
	nasm -f elf64 $< -o $@

execve_jmpcallpop.o: execve_jmpcallpop.asm
	nasm -f elf64 $< -o $@


clean:
	rm exit.o message.o message_stack_method.o message_rip_relative_addressing.o execve_stack_method.o execve_jmpcallpop.o $(FILE) 


payload:
	gcc -fno-stack-protector -z execstack $(FILE).c -o $(FILE)


runpayload:
	./$(FILE)
