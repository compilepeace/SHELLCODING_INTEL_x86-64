.text
.global _start

_start:
	mov r1, #4
	add r0, r1, #4		// r0 = 4+4 = 8
    //add r0, r1, r2, LSL #3 

	// exit(r0)
    mov r7, #1
    svc #0		// supervisor call : transition the CPU into supervisor mode
				// how ? by raising an exception
