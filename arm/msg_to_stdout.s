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

SYSCALL conventions for ARM
syscall number => r7
parameters     => r0, r1, r2, r3, r4, r5
return value   => r0

*/

.global _start
_start:

	/* write (1, "compilepeace was here x_x\n", 26);  */
	mov r7, #4
	mov r0, #1
	mov r2, #26
	ldr r1, =msg		// assembler performs PC relative addressing for us, check disassembly :)
	//add r1, pc, #12
	svc #0

	/* void _exit(7) */
	mov r7, #1
	mov r0, #7
	svc #0

msg:
.asciz "compilepeace was here x_x\n"
.align									// instrcut the assembler to align bytes as it pleases !
