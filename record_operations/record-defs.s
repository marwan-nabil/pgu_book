	# this file defines the offsets of the many fields in
	# the record, we will access the record using base
	# pointer + offset addressing
	.equ R_FIRSTNAME, 0
	.equ R_LASTNAME, 40
	.equ R_ADDRESS, 80
	.equ R_AGE, 320
	.equ R_LENGTH, 324		# record length
