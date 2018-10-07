	# this program writes 3 hard coded records into a file
	# the program first opens the file, writes the records
	# then closes the file
	.include "linux-defs.s"
	.include "record-defs.s"

	.section .data
	# 3 records, properly padded
record_1:
	.ascii "Fredrick\0"
	.rept 31
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
	.byte 0
	.endr
	.long 23
record_2:
	.ascii "Marwan\0"
	.rept 33
	.byte 0
	.endr
	.ascii "Nabil\0"
	.rept 34
	.byte 0
	.endr
	.ascii "alexandria, Egypt.\0"
	.rept 221
	.byte 0
	.endr
	.long 23
record_3:
	.ascii "Marwan\0"
	.rept 33
	.byte 0
	.endr
	.ascii "Nabil\0"
	.rept 34
	.byte 0
	.endr
	.ascii "alexandria, Egypt.\0"
	.rept 221
	.byte 0
	.endr
	.long 23

file_name:
	.ascii "test.dat\0"

	.equ ST_FD, -4
	.section .text
	.globl _start
_start:
	movl %esp, %ebp
	subl $4, %esp
	
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
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
