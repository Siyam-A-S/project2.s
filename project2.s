.data
	userInput: .space 1001			# to store user input (1000 characters maximum)
	invalid: .asciiz "Invalid input"	# label to store invalid input message
	openP: .asciiz "(" 			# label for opening parenthesis 
	closingP: asciiz ")"			# label for closing parenthesis
.text

main:	
	# calculate N and M
	# My Howard ID: 03043178
	# N = 26 + (3043178 % 11) = 32
	# M = 32-10 = 22
	# Range: 0-9, a-v, A-V

	# prompt user for input
	li $v0, 8 				# read string system call
	la $a0, userInput 			# load input buffer
	li $a1, 1001 				# maximum length (including null terminator) 
	syscall 				# execute
	
Output:	jal Translate				# to convert string input to decimal output
	beq $v1, -1, ErrorMsg			# print invalid message when input is invalid
	j Print					# print the value returned by subprogram

Print:	
	addi $t5, $v1, 0			# move the output to $t5
	li $v0, 1				# to print an integer
	addi $a0, $t5, 0			# move output from $t5 to $a0
	syscall					# execute print