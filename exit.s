# a simple immediately exiting program
# it calls the exit() linux system call
# and passes some exit status to it in %ebx

	.section .data		# empty data section
	
	.section .text		# start of the text section
	.globl _start
_start:
	movl $1, %eax 		# the system call number
	movl $4, %ebx		# the parameter to be passed to the sys call, here the exit status
	int $0x80		# software interrupt to the kernel ISR
