	# this program wirtes the contents of a records file
	# into STDOUT in a human readable format
	.include "linux-defs.s"
	.include "record-defs.s"

	.section .data
filename:
	.ascii "test.dat\0"

	.section .bss
	.lcomm record_buffer, R_LENGTH

	.section .text
	.globl _start
_start:
	.equ ST_IN_FD, -4
	.equ ST_OUT_FD, -8

	movl %esp, %ebp

	subl $8, %esp
	movl $SYS_OPEN, %eax
	movl $filename, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $SYS_TRAP

	movl %eax, ST_IN_FD(%ebp)
	movl $STDOUT, ST_OUT_FD(%ebp)

read_record_loop:
	pushl ST_IN_FD(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp

	# end if EOF is reached: this is indicated by non identical values for %eax and R_LENGTH
	cmpl $R_LENGTH, %eax
	jne finish

	# print first name
	pushl $R_FIRSTNAME + record_buffer
	call count_chars
	addl $4, %esp
	# record th length of the firstname into %edx
	movl %eax, %edx
	movl ST_OUT_FD(%ebp), %ebx
	movl $SYS_WRITE, %eax
	movl $R_FIRSTNAME + record_buffer, %ecx
	int $SYS_TRAP

	pushl ST_OUT_FD(%ebp)
	call write_newline
	addl $4, %esp

	jmp read_record_loop

finish:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYS_TRAP
	
	
