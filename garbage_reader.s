	# this program reads out garbage memory from
	# uninitilalized memory regions

	.section .bss
	.lcomm garbage, 100004

	.section .text
	.equ str_len, 100000
	.equ SYS_WRITE, 4
	.equ SYS_EXIT, 1
	.equ STDOUT, 1
	.equ INT_LINUX_CALL, 0x80
	.globl _start
_start:	
	movl $str_len, %edx	# the write length
	movl $SYS_WRITE, %eax	
	movl $STDOUT, %ebx	# the output file descriptor
	movl $garbage, %ecx	# buffer pointer
	int $INT_LINUX_CALL

	movl $SYS_EXIT, %eax
	int $INT_LINUX_CALL
