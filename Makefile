

.PHONY:	clean payload runpayload


FILE=test_shellcode


all: exit.o


exit.o: exit.asm
	nasm -f elf64 exit.asm -o exit.o 


clean:
	rm exit.o $(FILE)


payload:
	gcc -fno-stack-protector -z execstack $(FILE).c -o $(FILE)


runpayload:
	./$(FILE)
