/*

Author: Abhinav Thakur
File:   xxx.s

PoE:
	Exists because

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static xxx.s -o ./xxx.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=xxx.raw ./xxx.elf
Run            :
	$ ./xxx.elf

~~ SYSCALL conventions for ARM32
move parameters into => r0, r1, r2, r3, r4, r5
move syscall number  => r7
find return value in => r0

*/

.global _start
_start:

	/* write (1, "compilepeace was here x_x\n", 26);  */
	
	/* scramble all registers */
	mov r12, #0xff

/*
	mov r0, r12, lsl #24
	mov r1, #0x11223344
	mov r2, #0x11223344
	mov r3, #0x11223344
	mov r4, #0x11223344
	mov r5, #0x11223344
	mov r6, #0x11223344
	mov r7, #0x11223344
	mov r8, #0x11223344
	mov r9, #0x11223344
	mov r10, #0x11223344
	mov r11, #0x11223344
	mov r12, #0x11223344
*/
