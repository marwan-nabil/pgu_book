	# this file defines the following functions:
	# read_record(buffer address, file descriptor)
	# write_record(buffer address, file descriptor)
	# we follow the standard calling convention,
	# first argument is pushed last on the stack.

	.include "linux-defs.s"
	.include "record-defs.s"
	.section .data
	.equ ST_BUFF_ADDR, 8
	.equ ST_FD, 12
	
	.section .text
	.globl read_record
	.type read_record, @function
read_record:
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx
	movl ST_FD(%ebp), %ebx
	movl $ST_BUFF_ADDR, %ecx
	movl $R_LENGTH, %edx
	movl $SYS_READ, %eax
	int $SYS_TRAP
	popl %ebx

	movl %ebp, %esp
	popl %ebp
	ret

	.globl write_record
	.type write_record, @function
write_record:
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx
	movl ST_FD(%ebp), %ebx
	movl $ST_BUFF_ADDR, %ecx
	movl $4, %edx
	movl $SYS_WRITE, %eax
	int $SYS_TRAP
	popl %ebx

	movl %ebp, %esp
	popl %ebp
	ret

