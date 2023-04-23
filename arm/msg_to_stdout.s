/*

Author: Abhinav Thakur
File:   msg_to_stdout.s

PoE:
	Just prints a message to STDOUt and exits gracefully

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static msg_to_stdout.s -o ./msg_to_stdout.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=msg_to_stdout.raw ./msg_to_stdout.elf
Run            :
	$ ./msg_to_stdout.elf

~~ SYSCALL conventions for ARM32
move parameters into => r0, r1, r2, r3, r4, r5
move syscall number  => r7
find return value in => r0

*/

.global _start
_start:

	// To eliminate NULL bytes
	// - use thumb mode
	// - use placeholder 'X' in data string and replace it by 0 during runtime (via strb )

	// write(1, "compilepeace was here x_x\n", 26);
	.code 32			// standard ARM instructions
	add r3, pc, #1
	bx r3				// branch to thumb mode

	.code 16			// THUMB instructions start
	mov r7, #4			// syscall number
	mov r0, #1
	mov r2, #msg_len
	add r1, pc, #12		// error if immediate value is #6 instead of #8 (imm => powers of 2 ? )
	eor r3, r3, r3
	strh r3, [r1, #26]
	svc #1
	mov r3, r3
	
	// _exit(7)
	mov r0, #7
	mov r7, #1
	svc #1

msg:
.ascii "compilepeace was here x_x\nXX"
msg_end:
.set msg_len, msg_end-msg
.align

/*

// This program works fine, but generates NULL bytes (bad chars)

	// write (1, "compilepeace was here x_x\n", 26);
	mov r7, #4
	mov r0, #1
	mov r2, #msg_len
	ldr r1, =msg		// assembler performs PC relative addressing for us, check disassembly :)
	//add r1, pc, #12
	svc #0

	// void _exit(7) 
	mov r7, #1
	mov r0, #7
	svc #0

msg:
.asciz "compilepeace was here x_x\n"	// ask assembler to add a NULL byte @ endof data stream
msg_end:
.set msg_len, msg_end-msg				// stores the size of string
.align									// instrcut the assembler to align bytes as it pleases !

*/
