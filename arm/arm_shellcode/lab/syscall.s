
.global _start
_start:
	// int open(const char *pathname, int flags, mode_t mode);
	// r7 = 5

	// ssize_t write(int fd, const void *buf, size_t count);
	mov r7, #4		// syscall num = 4
	mov r0, #1		// fd = STDOUT_FILENO
	mov r2, #11		// count = 4
	add r1, pc, #8	// buf = (pc + 12) => "x_x\n"
	svc #0			// supervisor call
	// return value of write(2) gets stored in R0
	
	// void _exit(int status);
	mov r7, #1
	svc #0			// supervisor call

.ASCIZ "x_x fucker\n"			// assembler directive to define ASCII encoded data (string)
.align					// assembler directive that takes care of alignment

