##############################################################
# Homework #5
# name: Chun_Hung_Li
# sbuid: 110807126
##############################################################

.text

# Important Details:
# - recursive function
# - $a0: string/char[]/DNA sequence
# 	* contains only letters in the DNA nucleotide pool (a, c, g, t, A, C, G, T)
#	* assume seq is always valid
# - $a1: string/char[]/DNA pattern
#	* contains only letters in the DNA nucleotide pool (a, c, g, t, A, C, G, T)
#	* may contain 0 or more *
#	* if contains just a *,return length of string
#	* if string is empty and pattern contains just a *, let $v0 contain 1 and $v1 contain 0
# - $v0: boolean
#	* returns 0 or 1
# - $v1: integer
#	* length of matched strings
#	* if $v0 is 0, then return X
# - examples
#	* match_glob("","*") -> (1,0)
#	* match_glob("ACGTTCAAGAGTACC","") -> (0,X)
#	* match_glob("ACGTTCAAGAGTACC","ACG*AcC") -> (1,9)
#	* match_glob("ACGTTCAAGAGTACC","ACG") -> (0,X)
#	* match_glob("ACGTTCAAGAGTACC","*GTA*") -> (1,12)
#	* match_glob("ACGTTCAAGAGTACC","*") -> (1,15)
match_glob:
	base_cases_match_glob:
		addi $sp, $sp, -12									# make space on stack
		sw $a0, 8($sp)										# store DNA sequence
		sw $a1, 4($sp)										# store DNA pattern
		sw $ra, 0($sp)										# store register address
		li $t1, 0
		li $t2, 0
		move $t3, $a0
		move $t4, $a1
		get_length_sequence_match_glob:
			lb $t0, 0($t3)
			beqz $t0, get_length_pattern_match_glob
			addi $t1, $t1, 1
			addi $t3, $t3, 1
			j get_length_sequence_match_glob
		get_length_pattern_match_glob:
			lb $t0, 0($t4)
			beqz $t0, first_base_case_match_glob
			addi $t2, $t2, 1
			addi $t4, $t4, 1
			j get_length_pattern_match_glob
		first_base_case_match_glob:							# if pattern is an asterisk
			bne $t2, 1, pre_second_base_case_match_glob			# if pattern length is not 1, false
			lb $t3, 0($a1)
			bne $t3, 42, pre_second_base_case_match_glob 		# if first base case is false, go to second
			li $v0, 1										# true
			move $v1, $t1									# sequence length
			j complete_match_glob
		pre_second_base_case_match_glob:
			move $t3, $a0
			move $t4, $a1
			loop_to_lower_match_glob:
				lbu $t5, 0($t3)
				beqz $t5, pre_loop_to_lower_2_match_glob
				blt $t5, 65, skip_lower 
				bgt $t5, 90, skip_lower
				addi $t5, $t5, 32
				sb $t5, 0($t3)
				skip_lower:
					addi $t3, $t3, 1
				j loop_to_lower_match_glob
			pre_loop_to_lower_2_match_glob:
				add $t3, $t3, $t1
			loop_to_lower_2_match_glob:
				lbu $t5, 0($t4)
				beqz $t5, pre_pre_second_base_case_match_glob
				blt $t5, 65, skip_lower_2 
				bgt $t5, 90, skip_lower_2
				addi $t5, $t5, 32
				sb $t5, 0($t4)
				skip_lower_2:
					addi $t4, $t4, 1
				j loop_to_lower_2_match_glob
			pre_pre_second_base_case_match_glob:
				add $t4, $t4, $t2
		second_base_case_match_glob:						# if sequence and pattern are identical
			bne $t1, $t2, third_base_case_match_glob		# if length of sequence and pattern are not equal, false
			move $t5, $t1									# copy length of sequence
			move $t6, $t2									# copy length of pattern
			loop_second_base_case_match_glob:
				beqz $t5, complete_loop_second_base_case_match_glob
				lb $t7, 0($t3)								# load first character of DNA sequence
				lb $t8, 0($t4)								# load first character of DNA pattern
				bne $t7, $t8, third_base_case_match_glob	# if the characters are not equal, false
				addi $t3, $t3, 1							# increment temp address of DNA sequence
				addi $t4, $t4, 1							# increment temp address of DNA pattern
				addi $t5, $t5, -1							# decrement length of sequence counter
				j loop_second_base_case_match_glob			# loop back
			complete_loop_second_base_case_match_glob:
				li $v0, 1									# true
				li $v1, 0									# zero
				j complete_match_glob						# complete
		third_base_case_match_glob:
			beqz $t1, XOR_third_base_case_match_glob		# if length of sequence is zero, check length of pattern
			bnez $t2, else_match_glob						# if length of sequence and pattern are not zero, proceed recursion
			li $v0, 0										# if length of sequence is not zero and pattern is zero then
			li $v1, 0										# false and zero
			j complete_match_glob							# complete
			XOR_third_base_case_match_glob:
				beqz $t2, else_match_glob					# if length of sequence and pattern is zero, proceed to recursion
				li $v0, 0									# if length of sequence is zero and pattern is not zero
				li $v1, 0									# false and zero
				j complete_match_glob						# complete
		complete_match_glob:
			lw $a0, 8($sp)
			lw $a1, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 12								# reset stack							
			jr $ra											
	else_match_glob:
		move $t3, $a0
		move $t4, $a1
		equal_characters_case_match_glob:
			lb $t7, 0($t3)
			lb $t8, 0($t4)
			bgt $t7, 65, skip_lower_3
			blt $t7, 90, skip_lower_3
			addi $t7, $t7, 32
			skip_lower_3:
			bgt $t8, 65, skip_lower_4
			blt $t8, 90, skip_lower_4
			addi $t8, $t8, 32
			skip_lower_4:
			bne $t7, $t8, asterisk_character_case_match_glob
			addi $a0, $a0, 1
			addi $a1, $a1, 1
			jal match_glob
			lw $a0, 8($sp)
			lw $a1, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 12
			jr $ra
		asterisk_character_case_match_glob: 
			bne $t8, 42, return_false_match_glob
			addi $a1, $a1, 1
			jal match_glob
			beq $v0, 0, no_match
			j skip_return_false_match_glob
			no_match:
				addi $a0, $a0, 1
				lw $a1, 4($sp)
				jal match_glob
				addi $v1, $v1, 1
				j skip_return_false_match_glob
		return_false_match_glob:
			li $v0, 0
			li $v1, 0
		skip_return_false_match_glob:
			lw $a0, 8($sp)
			lw $a1, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 12
			jr $ra
	# li $v0, -200
	# li $v1, -200
	jr $ra
	
# Important Details:
# - helper function
# - saves seq ($a1) in character pairs seperated by hyphens to the address specified by dst
# - AT, TA, CG, GC
# - a newline character is saved at the end of the permutation
# - $a0: address 
# - $a1: string representing DNA sequence
#	* always valid
#	* only in capitals
# - $v0: address of the next byte after the newline char
# - examples
#	* save_perm("@@@@@@@@@@@@1234","ATGCCGTA") -> dst($a0): ("AT-GC-CG-TA\n1234") $v0 = address of byte after \n
#	* save_perm("@@@@@@@@@@@@1234","AT") -> dst($a0): ("AT\n@@@@@@@@@1234") $v0 = address of byte after \n
save_perm:
	lbu $t0, 0($a1)
	beq $t0, $zero, complete_loop_save_perm			# if the byte is zero, then end of sequence has been met
	li $t0, 45										# "-"
	loop_save_perm:									
		lbu $t1, 0($a1)								# load first half of pair from sequence
		sb $t1, 0($a0)								# store first half of pair into destination
		addi $a0, $a0, 1							# increment address of destination
		addi $a1, $a1, 1							# incredment address of sequence
		lbu $t1, 0($a1)								# load first half of pair from sequence
		sb $t1, 0($a0)								# store first half of pair into destination
		addi $a0, $a0, 1							# increment address of destination
		addi $a1, $a1, 1							# incredment address of sequence
		lbu $t1, 0($a1)								# load following byte of sequence
		beq $t1, $zero, complete_loop_save_perm		# if the byte is zero, then end of sequence has been met
		sb $t0, 0($a0)								# if not, store the hyphen into the destination
		addi $a0, $a0, 1							# increment address of destination
		j loop_save_perm							# loop back
	complete_loop_save_perm:
		move $t0, $zero								# "\n"
		sb $t0, 0($a0)								# store the newline into the destination
		addi $a0, $a0, 1							# increment address of destination
		move $v0, $a0								# return the address of destination
	jr $ra

# Important Details:
# - helper function
# - constructs the next possible candidate for the next character in the permutation
# - if the next character is the start of a new pair, it can be any nucleotide
# - if the next character is the continuation of a new pair, it must be the complement
# - $a0: cand; space to store the candidates for the next character of the permutation
#	* space is declared in the helper function
# - $a1: seq; character array representing the current state of the permutation
# -	* you can assume it is always valid
# - * not always going to be null terminated
# - $a2: integer describing the location of the character to be filled in the seq array
# - $v0: returns the number of candidates that are present
# -	* max is 4
# - examples
#	* construct_candidate("@@@@!!!!","AT","2") -> cand: "ACGT!!!!", $v0 = 4
#	* construct_candidate("@@@@!!!!","ATC","3") -> cand: "G@@@!!!!", $v0 = 1
#	* construct_candidate("@@@@!!!!","ATCGGCTAAB@!PQTRSHIR.,@TAAG","9") -> cand: "T@@@!!!!", $v0 = 1
construct_candidates:
	li $t0, 2												# divisor
	div $a2, $t0											# divide location by 2
	mfhi $t0												# get remainder
	bnez $t0, complete_pair_construct_candidates 			# if remainder is not equal to zero, determine pair
	new_pair_construct_candidates:
		li $v0, 4											# if remainder is equal to zero, possible characters are 4
		li $t0, 65											# A
		sb $t0, 0($a0)										# store A into candidate space
		li $t0, 67											# C
		sb $t0, 1($a0)										# store C into candidate space
		li $t0, 71											# G
		sb $t0, 2($a0)										# store G into candidate space
		li $t0, 84											# T
		sb $t0, 3($a0)										# store T into candidate space
		j complete_construct_candidates						# complete
	complete_pair_construct_candidates:
		li $v0, 1											# remainder is non zero, possible characters is 1
		addi $a2, $a2, -1									# decrement n by 1
		loop_construct_candidates:
			beqz $a2, determine_candidates					# if equal zero, proceed to determine the candidates
			addi $a1, $a1, 1								# next character
			addi $a2, $a2, -1								# decrement n
			j loop_construct_candidates						# loop_construct_candidates
		determine_candidates:
			lb $t0, 0($a1)									# load incomplete pair
			check_A_construct_candidates:
				bne $t0, 65, check_T_construct_candidates	# check if incomplete pair is A
				li $t0, 84									# load T character
				sb $t0, 0($a0)								# store T into candidate space
				j complete_construct_candidates				# complete
			check_T_construct_candidates:
				bne $t0, 84, check_C_construct_candidates	# check if incomplete pair is T
				li $t0, 65									# load A character
				sb $t0, 0($a0)								# store A into candidate space
				j complete_construct_candidates				# complete
			check_C_construct_candidates:					
				bne $t0, 67, check_G_construct_candidates	# check if incomplete pair is C
				li $t0, 71									# load G character		
				sb $t0, 0($a0)								# store G into candidate space
				j complete_construct_candidates				# complete
			check_G_construct_candidates:
				li $t0, 67									# load C character
				sb $t0, 0($a0)								# store C into candidate space
				j complete_construct_candidates				# complete
				
	complete_construct_candidates:
	jr $ra

# Important Details:
# - recursive function
# - will generate all possible permutations of desired length and store them into memory using save_perm
# - $a0: seq; buffer character array of size at least length + 1
# - $a1: n; continue creating permutations starting at the nth character (seq[n-1])
# - $a2: res; pointer of location to store the result when the permutation is complete (size == length)
#	* value will be updated as permutations are stored
# - $a3: length; total num characters for each permutations
# - $v0: 
#	* if length is invalid (odd or 0), -1
#	* otherwise return 0
# - $v1:
#	* returns pointer unless invalid length, then 0
# - examples
#	* permutations(buf, 0, 0x400, 3) -> (-1,0)
#	* permutations(buf, 0, 0x400, 0) -> (-1,0)
#	* permutations(buf, 0, 0x400, 4) -> (0,0x460)
#	* permutations(buf, 3, 0x400, 6) -> (0,0x424)
#	* if the above function is called when buf already contains "ATC":
#	* AT-CG-AT\nAT-CG-CG\nAT-CG-GC\nAT-CG-TA\n
permutations:
	base_cases_permutations:
		addi $sp, $sp, -20							# make room in stack
		sw $a0, 16($sp)								# store sequence
		sw $a1, 12($sp)								# store n
		sw $a2, 8($sp)								# store res
		sw $a3, 4($sp)								# store length
		sw $ra, 0($sp)								# store register address
		first_base_case_permuations:
			li $t0, 2								# load 2
			div $a3, $t0							# divide length by 2
			mfhi $t0								# get remainder
			beqz $a3, error_permutations			# if length equals 0, error
			bnez $t0, error_permutations			# if remainder equals 0, error
			j second_base_case_permutations
		second_base_case_permutations:
			bne $a1, $a3, recursion_permutations	# if n and length are not equal, proceed to recursion
			add $a0, $a0, $a3						# increment the sequence address by the length
			move $t1, $zero							# \n
			sb $t1, 0($a0)							# store the null character
			sub $a0, $a0, $a3						# restore original address
			move $a1, $a0							# move seq into $a1
			move $t6, $a0
			move $a0, $a2							# move res into $a0
			jal save_perm							# call save_perm
			move $v1, $v0
			move $v0, $zero
			move $a2, $a0
			move $a0, $t6
			lw $ra, 0($sp)
			lw $a3, 4($sp)
			lw $a1, 12($sp)
			addi $sp, $sp, 20
			jr $ra
		error_permutations:
			lw $a3, 4($sp)
			lw $a1, 12($sp)
			lw $a0, 16($sp)
			addi $sp, $sp, 20
			li $v0, -1
			move $v1, $zero
			jr $ra
	recursion_permutations:
		move $a2, $a1								# move n into $a2
		move $a1, $a0								# move sequence into $a1
		la $a0, candidates
		jal construct_candidates					# construct_candidates(dst, sequence, n)
		move $t9, $v0
		move $t7, $a0		
		lw $ra, 0($sp)
		lw $a2, 8($sp)
		lw $a1, 12($sp)
		lw $a0, 16($sp)
		loop_permutations:
			beq $s0, $t9, return_permutations
			add $a0, $a0, $a1
			add $t7, $t7, $s0
			lbu $t0, 0($t7)
			sb $t0, 0($a0)
			sub $t7, $t7, $s0
			sub $a0, $a0, $a1
			addi $a1, $a1, 1
			addi $s0, $s0, 1
			jal permutations
			#lw $ra, 0($sp)
			#lw $a3, 4($sp)
			#lw $a1, 12($sp)
			#lw $a0, 20($sp)
			#addi $sp, $sp, 20
			j loop_permutations
	return_permutations:
		 lw $ra, 0($sp)
		 lw $a3, 4($sp)
		 lw $a2, 8($sp)
		 lw $a0, 16($sp)
		 addi $sp, $sp, 20
		move $v0, $zero
		move $v1, $a2
	jr $ra

.data
candidates: .space 4