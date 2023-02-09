#ifndef _X_SYSCALL
#define _X_SYSCALL

#include <unistd.h>
#include <stdlib.h>         // using syscall declarations from standard C library
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int x_open (const char *pathname, int flags, mode_t mode);
void x_exit (int status);
ssize_t x_read (int fd, void *buf, size_t count);
ssize_t x_write (int fd, const void *buf, size_t count);

#endif  /* _X_SYSCALL */
