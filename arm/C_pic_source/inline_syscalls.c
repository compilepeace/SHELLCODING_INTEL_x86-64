
/*
Author: Abhinav Thakur
File:   inline_syscalls.c
Compile : gcc -g -nostdlib -static ./inline_syscalls.c 

Description: Extract the final TEXT section of final 
program binary to get position independent program. 

*/

#include <sys/types.h>

/* prototypes for ASM inlined syscalls */
pid_t x_getpid (void);	/* rax = 39 */
int x_execve (const char *pathname, char *const argv[], char *const envp[]);	/* rax = 59 */
void x_exit (int status);	/* rax = 60 */

void _start()
{
	/* find auxiliary vector to access cmdline args */
	// main(argc, argv, envp)


	/* test syscalls */
	x_getpid();

	/* execve(2)*/
	char prog[] = {'/', 'u', 's', 'r', '/', 'b', 'i', 'n', '/', 'w', 'c', 0};
	char *argv[] = {prog, 0};
	x_execve(prog, argv, 0);

	x_exit(7);
}


/* rax = 39 */
pid_t x_getpid (void)
{
	pid_t ret;

	__asm__ volatile (
	"push $39\n"
	"pop %%rax\n"
	"syscall\n"
	"mov %%eax, %0": "=r"(ret));

	return (pid_t )ret;
}


/* rax = 59 */
int x_execve (const char *pathname, char *const argv[], char *const envp[])
{
	int ret;

	__asm__ volatile (
	"push %0\n"
	"pop %%rdi\n"
	"push %1\n"
	"pop %%rsi\n"
	"push %2\n"
	"pop %%rdx\n"
	"push $59\n"
	"pop %%rax\n"
	"syscall\n"
	:: "g"(pathname), "g"(argv), "g"(envp));	

	__asm__ volatile ("mov %%eax, %0" : "=r"(ret));
	return (int )ret;
}


/* rax = 60 */
void x_exit (int status) 
{
	__asm__ volatile (
	"push %0\n"
	"pop %%rdi\n"
	"push $60\n"
	"pop %%rax\n"
	"syscall\n"
	:: "g"(status));
}
