	# this program opens a text file into a buffer
	# then converts the text to upper case
	# and finally writes it to another file
	# input and output files are given as command line arguments
	.section .data
	# system calls
	.equ SYS_OPEN, 5
	.equ SYS_CLOSE, 6
	.equ SYS_READ, 3
	.equ SYS_WRITE, 4
	.equ SYS_EXIT, 1

	# linux system call interrupt number
	.equ INT_LINUX_CALL, 0x80

	# standard files given to a process
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2
	
	# file opening options
	.equ O_READ_ONLY, 0
	.equ O_CREATE_WRONLY_TRUNCATE, 03101

	# end of file indicator
	.equ EOF, 0

	# command line arguments count
	.equ ARGC, 2

	.section .bss
	# storage reserved but not initialized
	.equ BUFF_SIZE, 500
	.lcomm BUFFER, BUFF_SIZE 		# allocating a 500 bytes buffer

	.section .text
	# stack positions at program start (relative to the base pointer %ebp)
	.equ ST_RESERVED, 8		# to be reserved for local variables
	.equ ST_ARGC, 0			# argument count is the top of stack when program starts
	.equ ST_ARG1, 4			# first argument: name of the program
	.equ ST_ARG2, 8			# second argument: input file
	.equ ST_ARG3, 12		# third argument: output file
	.equ ST_FD_IN, -4		# local variable 1: file descriptor for input file
	.equ ST_FD_OUT, -8		# local variable 2: file descriptor for output file

	.global _start			# entry point
_start:	
	# stack management
	movl %esp, %ebp
	subl $ST_RESERVED, %esp		# reserve space for local variables on stack

open_files:				# open the files and store their FDs
open_in:
	movl $SYS_OPEN, %eax
	movl ST_ARG2(%ebp), %ebx
	movl $O_READ_ONLY, %ecx
	movl $0666, %edx
	int $INT_LINUX_CALL
store_in_fd:
	movl %eax, ST_FD_IN(%ebp)

open_out:
	movl $SYS_OPEN, %eax
	movl ST_ARG3(%ebp), %ebx
	movl $O_CREATE_WRONLY_TRUNCATE, %ecx
	movl $0666, %edx
	int $INT_LINUX_CALL
store_fd_out:
	movl %eax, ST_FD_OUT(%ebp)

	# we now have both input and output files open and
	# their file descriptors as local variables on the
	# stack, we now begin the READ->to_upper->WRITE loop

loop_begin:
read_into_buffer:	
	movl $SYS_READ, %eax
	movl ST_FD_IN(%ebp), %ebx
	movl $BUFFER, %ecx
	movl $BUFF_SIZE, %edx
	int $INT_LINUX_CALL
check_EOF:			# check the read length (in %eax) against EOF or errors
	cmpl $EOF, %eax
	jle end_loop
call_to_upper:			# preparing the to_upper(bufferLength, bufferAddress) call
	pushl $BUFFER
	pushl %eax		# contains the read length
	call to_upper		# do the conversion on the buffer
	popl %eax		# get the size back to %eax
	addl $4, %esp		# restore the stack (pop off $BUFFER)
write_to_file:
	movl %eax, %edx		# the write length
	movl $SYS_WRITE, %eax	
	movl ST_FD_OUT(%ebp), %ebx	# the output file descriptor
	movl $BUFFER, %ecx	# buffer pointer
	int $INT_LINUX_CALL
	jmp loop_begin		# restart the loop again


end_loop:
close_files:
	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $INT_LINUX_CALL
	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $INT_LINUX_CALL
exit:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $INT_LINUX_CALL

	########### to_upper() #################
	########################################
	.type to_upper, @function
	.global to_upper
	# constants
	.equ LOWER_A, 'a'
	.equ LOWER_Z, 'z'
	.equ UPPER_CONVERSION, 'A' - 'a'
	# stack adjustment
	.equ buff_size, 8
	.equ BUFF, 12
to_upper:
	pushl %ebp
	movl %esp, %ebp
	# set up local variables
	movl buff_size(%ebp), %ebx	# buffer length
	movl BUFF(%ebp), %eax		# buffer pointer
	movl $0, %edi			# an index into the buffer
check_buffer_size:			# end if the buffer is empty
	cmpl $0, %ebx
	je end_to_upper
	
to_upper_loop:				# loop and convert on the buffer
	movb (%eax, %edi, 1), %cl
check_byte:				# skip a byte if it's not a lower case letter
	cmpb $LOWER_A, %cl
	jl skip_byte
	cmpb $LOWER_Z, %cl
	jg skip_byte
convert_to_upper:
	addb $UPPER_CONVERSION, %cl
	movb %cl, (%eax, %edi, 1)	# store back at the same location
skip_byte:	
	incl %edi
	cmpl %edi, %ebx			# check if we've reached the buffer end or continue loop
	jne to_upper_loop

end_to_upper:
	movl %ebp, %esp
	popl %ebp
	ret
