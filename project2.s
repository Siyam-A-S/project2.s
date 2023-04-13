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
	
	li $v0, 4				# to print a string
	la $a0, openP				# load the open parenthesis
	syscall					# execute print

	li $v0, 1				# to print an integer
	addi $a0, $t9, 0			# move the length of input to $a0
	syscall					# execute print
	
	li $v0, 4				# to print a string
	la $a0, closingP			# load the closing parenthesis
	syscall					# execute print
	
	j Exit					# exit program

Errormsg:					# print invalid message when input is invalid
	li $v0, 4				# print a string
	la $a0, invalid				# load the invalid label
	syscall					# execute print

	j Exit					# exit program

Exit:	li $v0, 10				# exit the program
	syscall					# system call to exit
	
Translate:
	Leading:				# to skip leading spaces and tabs
	lb $t1, ($a0)				# loading the subsequent bit to $t1
	beq $t1, 0, Jump			# print the final value if end reached
	beq $t1, 10, Jump			# print the final value if line break found
	bne $t1, 32, Tab1			# check for leading space 
	j Skip1						# continue loop

	Tab1:	bne $t1, 9, LoopMain		# check for leading tab
	
	Skip1:	addi $a0, $a0, 1		# go to the next byte address
		j Leading			# loop to check for leading space/tab

	LoopMain:				# loop to process characters in input
	lb $t1, ($a0)				# loading the subsequent bit to $t1
	bgt $t7, 4, InvalMsg			# if length > 4, print invalid prompt
	beq $t1, 0, Jump			# print the final value if end reached
	beq $t1, 10, Jump			# print the final value if line break found
	beq $t1, 32, Trailing		# check for trailing spaces & tabs if a space found
	beq $t1, 9, Trailing		# check for trailing spaces & tabs if a tab found
	
	Numbers: bgt $t1, 57, Upper		# if character > 9 then jump to Upper
		blt $t1, 48, InvalMsg		# if character < 0 jump to InvalMsg
		li $t3, -48				# assign character's value to $t3
		j Calculations			# jump to calculate and update $t5
	
	Upper:	bgt $t1, 86, Lower		# if character > 'V' then jump to Lower
		blt $t1, 65, InvalMsg		# if character < 'A' jump to InvalMsg
		li $t3, -55				# assign character's value to $t3
		j Calculations			# jump to calculate and update $t5

	Lower:	bgt $t1, 118, InvalMsg		# if character > 'v' then jump to InvalMsg
		blt $t1, 97, InvalMsg		# if character < 'a' jump to InvalMsg
		li $t3, -87			# assign character's value to $t3

	Calculations:
		add $t2, $t1, $t3		# turn the character to its decimal value
		add $t4, $t4, $t2		# add that value to $t4 in every iteration
		mul $t4, $t4, 32		# multiply $t4 by 32 in every iteration	

	Next:	addi $a0, $a0, 1		# go to the next byte address
		addi $t7, $t7, 1		# increment by 1 the length counter of input
		j LoopMain			# jump to LoopMain
	
	Trailing:
	lb $t1, ($a0)				# loading the subsequent bit
	beq $t1, 0, Jump			# print the final value if end reached
	beq $t1, 10, Jump			# print the final value if line break found