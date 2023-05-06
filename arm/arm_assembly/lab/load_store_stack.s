
.data		// data segment
.text		// text segment

.global _start
_start:

	mov r1, #10
	mov r2, #20


	// EXPERIMENTING with ADDRESSING MODES
	//str r1, [sp]
	//str r2, [sp, #4]	// simple store
	//str r2, [sp, #4]!	// pre-index addressing (update SP, i.e. store calculated address in SP)
	str r1, [sp, #4]	// *(sp+4) = r1 
	str r2, [sp], #4	// *sp = r2 && sp += 4  <-- post-addressing

	ldr r0, [sp]		// r0 = 10

	// exit syscall
	mov r7, #1
	svc #0

