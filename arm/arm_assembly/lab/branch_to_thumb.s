
.global _start
_start:
	
	// since the thumb code needs to be at an address having LSB == 1
	add r4, pc, #1	// r4 = pc + 1
	bx r4

// specifying .thumb directive to assember is mandatory
.thumb
	// exit syscall
	mov r0, #7
	mov r7, #1
	svc #0			// supervisor call
