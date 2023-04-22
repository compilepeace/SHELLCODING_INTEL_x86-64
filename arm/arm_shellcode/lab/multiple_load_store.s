
.global _start
_start:

// 10 should be on top of stack while 40 should be on bottom (high address)
	mov r1, #10
	mov r2, #20
	mov r3, #30
	mov r4, #40
	//stmfd sp!, {r1,r2,r3,r4}	// store multiple full decrement
	//stmdb sp!, {r1,r2,r3,r4}  // store multiple decrement before (equivalent to stmfd)
	//push {r1, r2, r3, r4}
	push {r1-r4}

	ldr r0, [sp]	// load the value at stack top into r0

	// exit syscall
	mov r7, #1
	svc #0
