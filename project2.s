.data
	userInput: .space 1001		#to store user input (1000 characters maximum)
	invalid: .asciiz "Invalid input"	#label to store invalid input message
.text

main:	
	# calculate N and M
	# My Howard ID: 03043178
	# N = 26 + (3043178 % 11) = 32
	# M = 32-10 = 22
	# Range: 0-9, a-v, A-V