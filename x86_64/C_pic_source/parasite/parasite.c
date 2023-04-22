/*
    steps to build :
    $ gcc -g -Wl,-N -static -nostdlib x_syscall.c main.c
*/
#include "x_syscall.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

//void exit(int status);

asm(".global _start\n"
    "_start:\n"
    /*
        save context
    */
    "call main\n"
    /*
        restore context
    */
);

void main()
{
    /*
        Infection : do things
    */
   char welcome[] = "Enter your name: ";
   x_write (1, welcome, 17);
   char name[1000];
   x_read (1, name, 1000);
   x_write (1, name, 1000);
   

   const char target[] = "/etc/passwd";
   int fd = x_open(target, O_RDONLY, 0);
   
	char passwd[100000];
   x_read (fd, passwd, 100000);
   x_write (1, passwd, 100000);
   
   x_exit(5);
}
