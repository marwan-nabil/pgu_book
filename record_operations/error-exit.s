	# this is an error handling function
	# it takes an error code and an error message as inputs
	# prints them and immediately exits the calling program
	.include "linux-defs.s"
	.equ ST_ERR_CODE, 8
	.equ ST_ERR_MSSG, 12

	.section .text
	.globl error_exit
	.type error_exit, @function
error_exit:
	pushl %ebp
	movl %esp, %ebp

	# write error code to STDOUT
	movl ST_ERR_CODE(%ebp), %ecx
	pushl %ecx
	call count_chars
	popl %ecx
	movl %eax, %edx
	movl $STDERR, %ebx
	movl $SYS_WRITE, %eax
	int $SYS_TRAP

	# write error message to STDOUT
	movl ST_ERR_MSSG(%ebp), %ecx
	pushl %ecx
	call count_chars
	popl %ecx
	movl %eax, %edx
	movl $STDERR, %ebx
	movl $SYS_WRITE, %eax
	int $SYS_TRAP

	pushl $STDERR
	call write_newline

	# exit with error status 1
	movl $1, %ebx
	movl $SYS_EXIT, %eax
	int $SYS_TRAP
