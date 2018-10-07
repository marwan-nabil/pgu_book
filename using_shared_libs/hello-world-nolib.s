	# this program writes out the "hello world string"
	# using only system calls
	.include "linux-defs.s"

	.section .data
hw:
	.ascii "Hello wrold\n\0"
hw_end:

	.equ hw_length, hw_end - hw

	.section .text
	.globl _start
_start:
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $hw, %ecx
	movl $hw_length, %edx
	int $SYS_TRAP

	movl $0, %ebx
	movl $SYS_EXIT, %eax
	int $SYS_TRAP
