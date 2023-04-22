.text
.global _start

_start:
    b hop

fucker:
    eor r1, r1
    mov r2, #1
    add r0, r1, r2, LSL #3 

	// exit(r0)
    mov r7, #1
    svc #0		// supervisor call : transition the CPU into supervisor mode
				// how ? by raising an exception

hop:
    b fucker
