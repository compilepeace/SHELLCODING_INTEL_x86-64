/*

Filename: asm_using_libc_functions.s

Compile
$ arm-linux-gnueabi-gcc ./asm_using_libc_functions.s

Run
$ QEMU_LD_PREFIX=/usr/arm-linux-gnueabi/ ./a.out
Hello Hell (printf string): 0x100
printf returned: 34

OR

$ qemu-arm -L /usr/arm-linux-gnueabi/ ./a.out
Hello Hell (printf string): 0x100
printf returned: 34
$ 

*/

// DATA segment starts
.data
msg:
	.asciz "Hello Hell (printf string): 0x%x\n"
msg2:
	.asciz "printf returned: %d\n"

// TEXT segment starts
.text
.global main

// main() starts
main:

	push {fp, lr}		// prologue: saving return pointer

	// printf ("Hello Hell (printf string): 0x%x\n", 0xd3ad);
	ldr r0, =msg		// assembler statement; translated into: 'ldr r0, [pc,#<off>]'
	mov r1, #256		// 0xd3ad
	bl printf

	// printf ("printf retuned: %d\n", r0);
	mov r1, r0
	ldr r0, =msg2
	bl printf

	pop {fp, pc}		// epilogue: restoring return pointer
