	# this program prints "hello world" string
	# with the aid of the c standard library
	# it would be dynamically linked with libc.so
	.section .data
hw:
	.ascii "hello world\n\0"

	.section .text
	.globl _start
_start:
	pushl $hw
	call printf

	pushl $0
	call exit
