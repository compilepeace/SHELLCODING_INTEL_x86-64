
.global _start
_start:

	mov r4, #10
	mov r5, #20
	cmp r4, r5
	blt return_small
	mov r0, r5
	b bye

return_small:
	mov r0, r4

bye:
	// exit syscall
	mov r7, #1
	svc #0			// supervisor call (transitions CPU into supervisor mode)
