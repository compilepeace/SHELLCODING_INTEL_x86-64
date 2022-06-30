/*

Author: Abhinav Thakur
File:   execve.s
Compile:        $ gcc -Wl,-N -nostdlib -static execve.s -o ./execve.elf
Dump shellcode :$ objcopy --dump-section .text=execve.raw ./execve.elf
Run            :$ ./execve.elf

*/

.global _start
_start:
.intel_syntax noprefix

	/* execve ("a", NULL, NULL)  */
	xor esi, esi	/* argv = NULL */
	xor edx, edx	/* envp = NULL */
	push 'a'
	push rsp
	pop rdi			/* prog = "a" */
	push 59			/* syscall number */
	pop rax
	syscall
