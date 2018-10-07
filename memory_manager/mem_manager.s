	# this program provides malloc(), free() functionality
	# it organizes allocated blocks of memory as follows:
	# /-----------------------------------------------------------------------------\
	# |				 |		 |				|
	# | available\unavailable marker | size of block | block data			|
	# |				 |    		 |				|
	# \-----------------------------------------------------------------------------/
	#						 ^--- pointer returned to user
	.section .data
	########### global variables
heap_begin:
	.long 0
break:
	.long 0

	########### block structure
	.equ HEADER_SIZE, 8
	.equ HEADER_MAEKER_OFFSET, 0
	.equ HEADER_SIZE_OFFSET, 4

	########### constants
	.equ UNAVAILABLE, 0
	.equ AVAILABLE, 1
	.equ SYS_BRK, 45
	.equ SYS_TRAP, 0x80

	.section .text
	########################### functions
	
	########### function allocate_init():
	.globl allocate_init
	.type allocate_init, @function
allocate_init:
	pushl %ebp
	movl %esp, %ebp

	# get the current system break
	movl $0, %ebx
	movl $SYS_BRK, %eax
	int $SYS_TRAP

	# the current system break is actually %eax + 1
	incl %eax
	movl %eax, break
	movl %eax, heap_begin

	movl %ebp, %esp
	popl %ebp
	ret
	
	########### function allocate(size in bytes) -> address of allocated memory in %eax
	# variables: %ecx : size of requested memory
	#	     %eax : memory region being examined
	#	     %ebx : current break position
	# 	     %edx : size of current memory region
	# this function goes through all the heap from the beggining to the end
	# looking for an available block of memory that is of sufficient size
	# when it finds one, it marks it as unavailable and returns a pointer to its
	# data field, when it can't find any suitable block, it allocates more memory by
	# calling BRK system call, moving the system break further
	.globl allocate
	.type allocate, @function
	.equ ST_MEM_SIZE, 8
allocate:
	pushl %ebp
	movl %esp, %ebp

	# initializing local variables
	movl ST_MEM_SIZE(%ebp), %ecx
	movl heap_begin, %eax
	movl break, %ebx

allocate_loop:
	# check if we've reached the end of the heap
	cmpl %eax, %ebx
	jle move_brk

	# check the location's availability
	movl HEADER_SIZE_OFFSET(%eax), %edx
	cmpl $UNAVAILABLE, HEADER_MAEKER_OFFSET(%eax)
	je next_location

	# check the size of the location
	cmpl %edx ,%ecx
	jle allocate_here
	
next_location:	
	# go to the next location
	addl $HEADER_SIZE, %eax
	addl %edx, %eax
	jmp allocate_loop

	# allocate in this block and return
allocate_here:
	movl $UNAVAILABLE, HEADER_MAEKER_OFFSET(%eax)
	addl $HEADER_SIZE, %eax

	movl %ebp, %esp
	popl %ebp
	ret

	# allocate more memory to the heap
move_brk:
	# move up the break point to fit the new block + its header
	addl $HEADER_SIZE, %ebx
	addl %ecx, %ebx

	# save needed regs
	pushl %eax
	pushl %ebx
	pushl %ecx

	# make the BRK syscall
	movl $SYS_BRK, %eax
	int $SYS_TRAP

	# check for error
	cmpl $0, %eax
	jl error_brk

	# restore saved regs
	popl %ecx
	popl %ebx
	popl %eax

	# fill in the new block header
	movl $UNAVAILABLE, HEADER_MAEKER_OFFSET(%eax)
	movl %ecx, HEADER_SIZE_OFFSET(%eax)

	# make %eax point to the start of data field, to return to caller
	addl $HEADER_SIZE, %eax

	# save the new system break
	movl %ebx, break

	movl %ebp, %esp
	popl %ebp
	ret

error_brk:
	movl $0, %eax
	movl %ebp, %esp
	popl %ebp
	ret

	########### function deallocate(pointer to memory block) -> void
	# this function marks a block as available, effectively freeing it for other subsequent allocations
	.globl deallocate
	.type deallocate, @function
	.equ ST_MEM_LOC, 8
deallocate:
	pushl %ebp
	movl %esp, %ebp

	movl ST_MEM_LOC(%ebp), %eax
	subl $HEADER_SIZE, %eax
	movl $AVAILABLE, HEADER_MAEKER_OFFSET(%eax)

	movl %ebp, %esp
	popl %ebp
	ret
