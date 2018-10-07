	# this programs reads records from an input file
	# then increments the age of every entry, then writes
	# these modified records to an output file
	.include "linux-defs.s"
	.include "record-defs.s"

	.section .data
input_file_name:
	.ascii "test.dat\0"
output_file_name:
	.ascii "test_out.dat\0"

	.section .bss
	.lcomm record_buffer, R_LENGTH

	.section .text
	.equ ST_IN_FD, -4
	.equ ST_OUT_FD, -8
	.globl _start
_start:
	movl %esp, %ebp
	subl $8, %esp

	movl $SYS_OPEN, %eax
	movl $input_file_name, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $SYS_TRAP
	movl %eax, ST_IN_FD(%ebp)

	# checking the open call for error
	cmpl $0, %eax
	jl error_condition
	
	movl $SYS_OPEN, %eax
	movl $output_file_name, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $SYS_TRAP

	movl %eax, ST_OUT_FD(%ebp)
	# we now have two files open, one for reading and one for writitng

begin_loop:
	pushl ST_IN_FD(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp

	# detect error or EOF by comparing %eax with R_LENGTH
	cmpl $R_LENGTH, %eax
	jne end_loop

	# modify the age field in the memory record buffer
	incl record_buffer + R_AGE

	pushl ST_OUT_FD(%ebp)
	pushl $record_buffer
	call write_record
	addl $8, %esp

	jmp begin_loop
end_loop:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYS_TRAP

error_condition:
	.section .data
no_open_file_code:
	.ascii "001: \0"
no_open_file_message:
	.ascii "Error, cannot open the Input file.\0"

	.section .text
	pushl $no_open_file_message
	pushl $no_open_file_code
	call error_exit
