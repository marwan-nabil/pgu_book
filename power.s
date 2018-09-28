	# uses a function call to calculate the power
	# the function takes two parameters:
	# 	1- the base.
	# 	2- the power.
	# and returns the result as usual in %eax
	.section .data
	.section .text

	.globl _start
_start:
	pushl $0		# pushing parameters in reverse
	pushl $2
	call power		# calling the function
	addl $8, %esp		# moving back the stack pointer after the call, effectively removing
				# all function call arguments from the caller's stack
	pushl %eax		# save the result of the first call to power
		
	pushl $3
	pushl $2
	call power
	addl $8, %esp
	popl %ebx
	addl %eax, %ebx
	movl $1, %eax		# prepare for the exit() call
	int $0x80		# trap to linux

	# function power(base, exponent)
	# base 	   -> %ebx
	# exponent -> %ecx
	# local variable -> -4(%ebp)
	# base must be >= 1
	.type power, @function
power:
	pushl  %ebp		# push old base pointer
	movl %esp, %ebp		# the new base pointer for this stack frame
	subl $4, %esp		# reserve space on the stack for the local variable
	movl 8(%ebp), %ebx	# store first arg (base)
	movl 12(%ebp), %ecx	# store second arg (exponent)
	movl %ebx, -4(%ebp)	# store the current result in the local variable
	cmpl $0, %ecx
	je zero_power
power_loop_start:
	cmpl $1, %ecx		# end loop when the exponent is 1
	je end_power
	movl -4(%ebp), %eax	# move current result to %eax
	imull %ebx, %eax	# multiply by the base one time
	movl %eax, -4(%ebp)	# move the result back
	decl %ecx
	jmp power_loop_start
zero_power:
	mov $1, %eax
end_power:
	movl -4(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret
