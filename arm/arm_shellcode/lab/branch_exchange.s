
.global _start
_start:
	
// standard ARM mode
.ARM
	mov r0, #7
	//add r4, pc, #1
	//bx r4	
	//bx thumb_mode
	mov r4, pc
	bx r4

.byte 0xff
//.align 0xff

thumb_mode:
.THUMB
	mov r7, #1
	svc #0
