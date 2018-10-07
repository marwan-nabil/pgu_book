	# this function takes the address of a string
	# and returns its count in %eax

	.type count_chars, @function
	.globl count_chars

	.equ ST_STR_ADDR, 8
	
	.section .text
count_chars:
	pushl %ebp
	movl %esp, %ebp

	movl ST_STR_ADDR(%ebp), %edx
	movl $0, %ecx

count_loop:
	movb (%edx), %al
	cmpb $0, %al
	je end_loop

	# increment count and char pointer
	incl %edx
	incl %ecx
	jmp count_loop

end_loop:
	movl %ecx, %eax
	movl %ebp, %esp
	popl %ebp
	ret
