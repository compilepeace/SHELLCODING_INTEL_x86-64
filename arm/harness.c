/*

Author: Abhinav Thakur
File:   harness.c
Compile:
	$ gcc -g -z execstack -fno-stack-protector $< -o $@.elf
	$ sudo chown root $@.elf
	$ sudo chmod u+s  $@.elf
Run:
	$ (cat ./execve_binsh.raw; cat) | ./harness.elf
	$ ./harness.elf < ./setuid_reverse_shell.raw
OR
	$ qemu-arm-static -L /usr/arm-linux-gnueabi ./harness.elf < ./msg_to_stdout.raw 

*/

#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

/*
__asm__ ( 
			"movq $0xaabbccddaabbccdd, %rax\t\n"
			"movq $0xaabbccddaabbccdd, %rdi\t\n"
			"movq $0xaabbccddaabbccdd, %rsi\t\n"
			"movq $0xaabbccddaabbccdd, %rdx\t\n"
			"movq $0xaabbccddaabbccdd, %r10\t\n"
			"movq $0xaabbccddaabbccdd, %r8\t\n"
			"movq $0xaabbccddaabbccdd, %r9\t\n"
			"movq $0xaabbccddaabbccdd, %rbx\t\n"
			"movq $0xaabbccddaabbccdd, %rcx\t\n"
);
*/


// do not try to check for string sequence, it will fail because of implicit presence of NULL char,
// which increases sizeof 'findSequence' by 1. Use a byte array instead. Eg: bytes[] = {'h', 'i'};
bool searchByteSequence (unsigned char *, int , unsigned char *, int );

// $ xxd -i ./clobber.raw
unsigned char clobberContext[] = {
};

int main (int argc, char **argv) 
{
	fprintf (stdout, "\nUsage: %s < <pic.raw>\n\n", argv[0]);


	// Map 2 pages of memory (0x2000 bytes) @ 0x1337000 with RWX permissions 
	void *code = mmap(	(void *)0x1337000, 0x2000, 
					PROT_READ|PROT_WRITE|PROT_EXEC, 
					MAP_PRIVATE|MAP_ANON, 0, 0);

	// copy assembled instructions to clobber CPU state @ code 
	memcpy (code, clobberContext, sizeof(clobberContext));	

	// read shellcode from STDIN and place it after clobber instructions 
	size_t read_bytes = read(0, code+sizeof(clobberContext), 0x1000);

	// check for bad characters
	unsigned char badChar[] = {0x00};
	if (searchByteSequence(code+sizeof(clobberContext), read_bytes, badChar, sizeof(badChar))){
		fprintf (stderr, "[-] Bad characters detected, eliminate them and try again !\n");
		return 1;
	}

	fprintf (stdout, "Shellcode (%ld) base @: %p\n", 
					read_bytes, code+sizeof(clobberContext));

	pid_t pid = fork();
	if (pid < 0){
		// error handling
		fprintf (stderr, "[-] unable to fork() child process, exiting...\n");
		return 1;
	}
	if (pid == 0){
		// child block: execute shellcode
		fprintf (stdout, "[+] child block executing shellcode, pid: %d\n", getpid());
		fprintf (stdout, "\n-x-x-x-x-x-x- Executing shellcode as child process -x-x-x-x-x-x-\n\n");
		((void(*)())code)();
	}
	else {
		// parent block: get shellcode exit status
		fprintf (stdout, "[+] parent patiently waiting for child to finish, pid: %d\n", getpid());
		int wstatus;
		if (waitpid(pid, &wstatus, 0) < 0){
			fprintf (stdout, "[-] failed to wait on child process, exiting...\n");
			return 1;
		}
		fprintf (stdout, "\n-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-\n\n");
		if (WIFEXITED(wstatus)){
			fprintf (stdout, "[+] shellcode returned: %d\n", WEXITSTATUS(wstatus));
		}
		else{
			fprintf (stdout, "[-] shellcode terminated abruptly, i.e. didn't invoke _exit(2)!\n");
		}
	}

	return 0;
}


bool searchByteSequence (unsigned char *haystack, int hsize, unsigned char *findSequence, int fsize)
{
	bool found = false;
	const unsigned char *ptr = haystack;

	for (int i = 0; i < hsize; ++i) 
	{
		int j = 0;
		
		// found first byte of 'findSequence' ?
		if (haystack[i] == findSequence[j])
		{
			// does other bytes of 'findSequence' match too ?
			while (++j < fsize){
				if (haystack[i+j] != findSequence[j]){
					break;
				}
			}
			if (j == fsize){		// if every character of 'findSequence' found in haystack
				found = true;
				fprintf (stderr, "Matched a byte sequence @ index : %d of haystack\n", i);
			}
		}
	}
	return found;
}
