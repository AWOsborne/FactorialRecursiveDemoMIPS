.data
	###########
	# Purpose: Demo of recusion in MIPS
	###########
	greet1:		.asciiz		"This program does factorial recursively.\n"
	prompt:		.asciiz		"Enter a number: "
	result:		.asciiz		"Factorial is: "

	n:			.word		1
	nfact:		.word		1

.text
	############
	#Procedure: _end_program
	#Purpose: ends the program
	#Arguments: none
	#Returned values: none
	##############
	_end_program:
		li $v0, 10
		syscall

		jr $ra

	############
	#Procedure: print_string
	#Purpose: prints string to the console
	#Arguments: $a0 -> the addrress of the string to print
	#Returned values: none
	##############
	_print_string:
		li $v0, 4	#load sys call for printing a string.
		syscall

		jr $ra 		#return to procedure.

	############
	#Procedure: print_int
	#Purpose: prints int to the console
	#Arguments: $a0 -> the addrress of the int to print
	#Returned values: none
	##############
	_print_int:
		li $v0, 1	#load sys call for printing a string.
		syscall

		jr $ra 		#return to procedure.

	############
	#Procedure: get_int
	#Purpose: gets an int from the console
	#Arguments: none
	#Returned values: $v0 -> the int
	##############
	_get_int:
		li $v0, 5
		syscall

		jr $ra

	############
	#Procedure: factorial
	#Purpose: Calculates the factorial of a number recursively.
	#Arguments: $a0 - the integer.
	#Returned values: $v0 - the factorial result.
	##############
	_factorial:
		subu $sp, $sp, 8		#Make room for $ra and $a0
		sw $ra, 4($sp)			#push return address $ra onto the stack
		sw $a0, 0($sp)			#push $a0 onto the stack

		#Check base case
		sle $t0, $a0, 1
		bne $t0, $zero, if1
		j else1
	if1:	#base case
		addi $v0, $zero, 1		#return a 1
		j end_if1
	else1:
		sub $a0, $a0, 1			#n = n - 1
		jal _factorial			#compute fact on n-1
		lw $a0, 0($sp)			#get old n
		mul $v0, $v0, $a0		#compute n * factorial (n-1)
	end_if1:
		#manage stack
		lw $ra, 4($sp)			#pop $ra from stack
		addu $sp, $sp, 8		#reset pointer
		jr $ra

	############
	#Procedure: main
	#Purpose: prints intro prompts, prompts user, calls factorial, etc.
	#Arguments: none
	#Returned values: none
	##############
	main:

		la $a0, greet1
		jal _print_string

		la $a0, prompt
		jal _print_string

		jal _get_int
		sw $v0, n

		lw $a0, n
		jal _factorial
		sw $v0, nfact

		la $a0, result
		jal _print_string

		lw $a0, nfact
		jal _print_int

		jal _end_program