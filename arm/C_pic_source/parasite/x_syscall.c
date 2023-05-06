/*
    steps to build :
    $ gcc -g -Wl,-N -static -nostdlib x_syscall.c parasite.c

*/
#include "x_syscall.h"

int x_open (const char *pathname, int flags, mode_t mode)
{
    int fd;
    asm (
        "push $2\n"
        "pop %%rax\n"
        "syscall\n"
        "mov %%eax, %0\n"
        : "=r"(fd)
    );
    return fd;
} 

void x_exit (int status)
{
    asm (
        "push $60\n"
        "pop %rax\n"                // syscall number 60
        "syscall\n");
}

ssize_t x_read (int fd, void *buf, size_t count)
{
    long ret;
    asm (
        "xor %%rax, %%rax\n"
        "syscall\n"
        "mov %%rax, %0\n"           // syscall number #0
        : "=r"(ret)
    );
    return ret;
}

/*
    As per function calling conventions used by GCC, args to functions
    are passed in following registers:
        RDI, RSI, RDX, RCX, R8, R9 -- rest pushed on stack (opposite direction)
    
    Whereas, according to system call conventions (by x86-64 ABI), args to
    functions are passed in following registers:
        RDI, RSI, RDX, R10, R8, R9 -- rest pushed on stack (opposite direction)

    To perform syscall, only the 4th argument needs be copied from reg RCX->R10.
    Rest all arguments are already in appropriate registers to invoke syscall.
*/
ssize_t x_write (int fd, const void *buf, size_t count)
{
    long ret;
    /*
        since we do not use any local variable inside asm();
        scope, a register can be referred in a usual manner
        via single '%' prefix. 
    */
    asm (
        "push $1\n"
        "pop %rax\n"        // syscall number #1
        "syscall\n"
    );

    /*
        since we are using local variables inside assembly,
        we need to refer to RAX via double '%' prefix and refer
        local variable via single '%' prefix inside asm(); scope.  
    */
    asm(
        "mov %%rax, %0\n"
        : "=r"(ret)
    );
    return ret;
}