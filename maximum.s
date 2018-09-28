	# finds the largest number in a dataset
	.section .data
data_items:
	.long 34,23,55,5,3,24,6,6,765,765,8,34,23,1,7,99,3,0

	.section .text
	.globl _start
_start:
	movl $0, %edi			# initialize array index
	movl data_items(,%edi,4), %eax  # store the first item into accumulator
	movl %eax, %ebx			# store the first item into the largest number variable
start_loop:
	cmpl $0, %eax			# compare the current item with zero
	je loop_exit			# end the loop if it's zero
	incl %edi			# increment array index
	movl data_items(,%edi,4), %eax  # store next element
	cmpl %ebx, %eax			# compare this element with the biggest element
	jle start_loop			# continue the loop if this element %eax is not bigger than the biggest %ebx
	movl %eax, %ebx			# store this element otherwise (if it's the biggest thus far)
	jmp start_loop
loop_exit:
	movl $1, %eax			# prepare the exit() system call, %ebx stores the biggest number
					# and is also the exit status here
	int $0x80
