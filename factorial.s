	# the program calculates the factorial of a number and
	# adds it to the factorial of another then returns the
	# result as exit status
	.section .data
	.section .text
	.globl _start
_start:
	pushl $5
	call factorial
	addl $4, %esp
	pushl %eax
	pushl $3
	call factorial
	addl $4, %esp
	pushl %eax
	call add_last_two
	movl %eax, %ebx
	movl $1, %eax
	int $0x80

	.type add_last_two, @function
add_last_two:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	addl 12(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret

	.type factorial, @function
factorial:
	pushl %ebp			# store the old base pointer
	movl %esp, %ebp			# make a new stack frame
	subl $4, %esp			# reserve space on the stack for the local variable
	movl 8(%ebp), %eax		# put the operand to factorial into the local variable
	movl %eax, -4(%ebp)		# put the operand to %eax also for processing
	cmpl $1, %eax			# check if the operand is $1 (the base case for recursion)
	je return_factorial		# return if the base case holds
	decl %eax			# decrement the operand 
	pushl %eax			# push (operand - 1) onto the stack
	call factorial			# recursively call factorial on (operand - 1)
	imull -4(%ebp), %eax		# multiply operand by factorial(operand - 1) and put in %eax
	movl %eax, -4(%ebp)		# store the result in the local variable
	jmp return_factorial
	
return_factorial:
	movl -4(%ebp), %eax		# put the end result in %eax
	movl %ebp, %esp			# returning conventions
	popl %ebp
	ret
