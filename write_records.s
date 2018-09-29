	# this program writes 3 hard coded records into a file
	# the program first opens the file, writes the records
	# then closes the file
	.include "linux-defs.s"
	.include "record-defs.s"

	.section .data
	# 3 records, properly padded
record_1:
record_2:
record_3:
	.ascii "aaaa"
	/* record_1:
	.ascii "Marwan"
	.rept 34
	.byte 0
	.endr
	.ascii "Nabil"
	.rept 35
	.byte 0
	.endr
	.ascii "alexandria, Egypt."
	.rept 222
	.byte 0
	.endr
	.long 23
record_2:
	.ascii "Marwan"
	.rept 34
	.byte 0
	.endr
	.ascii "Nabil"
	.rept 35
	.byte 0
	.endr
	.ascii "alexandria, Egypt."
	.rept 222
	.byte 0
	.endr
	.long 23
record_3:
	.ascii "Marwan"
	.rept 34
	.byte 0
	.endr
	.ascii "Nabil"
	.rept 35
	.byte 0
	.endr
	.ascii "alexandria, Egypt."
	.rept 222
	.byte 0
	.endr
	.long 23
*/
	# stack positions
	.equ ST_ARGC, 0			# argument count is the top of stack when program starts
	.equ ST_ARG1, 4			# first argument: name of the program
	.equ ST_ARG2, 8			# second argument: file name
	.equ ST_FD, -4

	.section .text
	.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp
	
	movl $SYS_OPEN, %eax
	movl ST_ARG2(%ebp), %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $SYS_TRAP

	movl %eax, ST_FD(%ebp)
	pushl ST_FD(%ebp)
	pushl $record_1
	call write_record
	addl $8, %esp

	pushl ST_FD(%ebp)
	pushl $record_2
	call write_record
	addl $8, %esp

	pushl ST_FD(%ebp)
	pushl $record_3
	call write_record
	addl $8, %esp

	movl $SYS_CLOSE, %eax
	movl ST_FD(%ebp), %ebx
	int $SYS_TRAP

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYS_TRAP
