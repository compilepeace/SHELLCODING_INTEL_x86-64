/*

Author: Abhinav Thakur
File:   exit.s
Compile:        $ gcc -Wl,-N -nostdlib -static exit.s -o ./exit.elf
Dump shellcode :$ objcopy --dump-section .text=exit.raw ./exit.elf
Run            :$ ./exit.elf

*/

.global _start
_start:
.intel_syntax noprefix

	/* exit(7) */
	push 60
	pop rax
	push 7
	pop rdi
	syscall	
