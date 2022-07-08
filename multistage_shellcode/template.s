/*

Author: Abhinav Thakur
File:   XXX.s
Compile:        $ gcc -Wl,-N -nostdlib -static XXX.s -o ./XXX.elf
Dump shellcode :$ objcopy --dump-section .text=XXX.raw ./XXX.elf
Run            :$ ./XXX.elf

*/

.global _start
_start:
.intel_syntax noprefix

	/*  */
