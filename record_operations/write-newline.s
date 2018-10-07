	# this function writes a newline character to STDOUT
	.include "linux-defs.s"
	
	.section .data
	.equ ST_FD, 8
newline:
	.ascii "\n"

	.section .text
	.type write_newline, @function
	.globl write_newline
write_newline:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_WRITE, %eax
	movl ST_FD(%ebp), %ebx
	movl $newline, %ecx
	movl $1, %edx
	int $SYS_TRAP

	movl %ebp, %esp
	popl %ebp
	ret
	
