.data
	newline:		.asciiz			"\n"	#putchar('\n')
	space:			.asciiz			" "		#putchar(' ')
	temp_char:		.space			1		#char
	temp_char_arr:	.space			32		#char[32]
	int_arr:		.space			40		#int[10]

.global	main

.text




	#*****************************************************************************
	#main function starts from here
	#*****************************************************************************



	main:			init_read_int_arr:
					li		$t5,	0							#idx
					li		$t6,	10							#total read 10 ints
					la		$t7,	int_arr
					
					read_int_arr:
					beq		$t5,	$t6,	sort				#idx == length, goto sort
					sll		$t8,	$t5,	2					#$t8 = 4*$t5 to read int
					add		$t8,	$t7,	$t8					#$t8 = addr + i
					jal		read_int							#read an int and store in $v1
					sw		$v0,	($t8)						#store in adrr[i]
					addi	$t5,	$t5,	1					#++i
					b		read_int_arr			
					
	
					
					sort:
					li		$t3,	9							#bubble sort: i < len - 1
		
					loop_i:

					init_i:	
					li		$t1,	0							#i = 0
					
					check_i:
					bge		$t1,	$t3,	init_write_int_arr			#i >= len - 1, end loop_i

					loop_j:

					init_j:	
					move	$t2,	$t1
					addi	$t2,	$t2,	1					#j = i + 1

					check_j:
					bge		$t2,	$t6,	increase_i			#j >= len, end loop_j
					addi	$sp,	$sp,	-8					#sorry, I am too stupid to implement it with 9 regs,
																#so I have to ask for more space TAT
			
					major_part:
					sll		$t5,	$t1,	2
					add		$t5,	$t7,	$t5
					sw		$t5,	($sp)						#store arr + i
					lw		$t5,	($t5)						#t5 = arr[i]

					sll		$t8,	$t2,	2
					add		$t8,	$t7,	$t8
					sw		$t8,	4($sp)						#store arr + j
					lw		$t8,	($t8)						#t8 = arr[j]

					ble		$t5,	$t8,	increase_j			#arr[i] <= arr[j], do not swap
					#swap
					move	$t9,	$t5
					lw		$t5,	($sp)
					sw		$t8,	($t5)
					lw		$t8,	4($sp)
					sw		$t9,	($t8)

					increase_j:
					addi	$t2,	$t2,	1
					addi	$sp,	$sp,	8
					b		check_j								#j++, and then check j if >= len

					increase_i:
					addi	$t1,	$t1,	1
					b		check_i								#i++, and the check i if >= len - 1


	
					init_write_int_arr:

					li		$t5,	0							#idx

					write_int_arr:

					beq		$t5,	$t6,	exit				#idx == length, goto exit
					sll		$t8,	$t5,	2					#$t8 = 4*$t5 to read int
					add		$t8,	$t7,	$t8					#$t8 = addr + i
					lw		$a0,	($t8)						#load addr[i] into a0(parameter0)
					jal		write_int
					jal		print_space
					addi	$t5,	$t5,	1					#++i
					b		write_int_arr				


					exit:
					jal		print_newline
					li		$v0,	4001
					syscall










	#*****************************************************************************
	#self defined functions start from here
	#*****************************************************************************



	read_int:		addi	$sp,	$sp,	-44
					sw		$a0,	($sp)
					sw		$a1,	4($sp)
					sw		$a2,	8($sp)
					sw		$a3,	12($sp)
					sw		$t0,	16($sp)
					sw		$t1,	20($sp)
					sw		$t2,	24($sp)
					sw		$t3,	28($sp)
					sw		$t4,	32($sp)
					sw		$t5,	36($sp)
					sw		$ra,	40($sp)

					ignore_space:

					li		$v0,	4003
					li		$a0,	0
					la		$a1,	temp_char
					li		$a2,	1
					syscall
					lb		$t0,	temp_char				#t0 stores temp
					li		$t1,	' '
					beq		$t0,	$t1,	ignore_space	#go next inst if not ' ' else go to head
					li		$t1,	'\n'
					beq		$t0,	$t1,	ignore_space	#go next inst if not '\n' else go to head
					
					li		$t5,	0						#t5 temporarily stores the return value
					li		$t2,	10						#base
					li		$t3,	'0'						#char to num

					keep_reading_num:

					li		$t1,	'0'
					blt		$t0,	$t1,	return_back		#less than 0, not a num
					li		$t1,	'9'
					bgt		$t0,	$t1,	return_back		#greater than 9, not a num
					
					mul		$t5,	$t5,	$t2				#t5 *= 10
					sub		$t4,	$t0,	$t3				#t4 stores temp - '0'
					add		$t5,	$t5,	$t4				#t5 = t5 + temp
						
					li		$v0,	4003
					li		$a0,	0
					la		$a1,	temp_char
					li		$a2,	1
					syscall
				
					lb		$t0,	temp_char
					b		keep_reading_num

					return_back:
					move	$v0,	$t5

					#reset	regs
					lw		$a0,	($sp)
					lw		$a1,	4($sp)
					lw		$a2,	8($sp)
					lw		$a3,	12($sp)
					lw		$t0,	16($sp)
					lw		$t1,	20($sp)
					lw		$t2,	24($sp)
					lw		$t3,	28($sp)
					lw		$t4,	32($sp)
					lw		$t5,	36($sp)
					lw		$ra,	40($sp)

					#reset stack pointer
					addi	$sp,	$sp,	44
					
					jr		$ra				#return back



	
		
	write_int:		
					addi	$sp,	$sp,	-52
					sw		$a0,	($sp)
					sw		$a1,	4($sp)
					sw		$a2,	8($sp)
					sw		$a3,	12($sp)
					sw		$t0,	16($sp)
					sw		$t1,	20($sp)
					sw		$t2,	24($sp)
					sw		$t3,	28($sp)
					sw		$t4,	32($sp)
					sw		$t5,	36($sp)
					sw		$t6,	40($sp)
					sw		$t7,	44($sp)
					sw		$ra,	48($sp)


					la		$t0,	temp_char_arr		#address of arr
					li		$t1,	0					#length
					li		$t2,	0					#index
					li		$t3,	10					#divisor
				
					loop:

					div		$a0,	$t3					#quotient in lo, remainder in hi
					mflo	$a0							#a0 /= 10
					mfhi	$t5							#t5 = a0 % 10
					addi	$t5,	'0'					#num to char
					add		$t4,	$t0,	$t1			#t4 = t0+i
					addi	$t1,	1					#++i
					sb		$t5,	($t4)				#save remainder in a0+i
					beqz	$a0,	init_reverse		#finish decomposing the integer
					b		loop


					init_reverse:

					srl		$t5,	$t1,	1			#t5 = length / 2
					addi	$t1,	$t1,	-1			#--t1 for convenience

					reverse_arr:

					bge		$t2,	$t5,	print_arr	#if idx >= length / 2, goto print_arr
					sub		$t3,	$t1,	$t2			#t3 = length - 1 - idx
					move	$t4,	$t2					#save idx

					add		$t2,	$t0,	$t2			#t2 = addr + idx
					add		$t3,	$t0,	$t3			#t3 = addr + length - 1 - idx

					lb		$t6,	($t2)				#temp1 = arr[i]
					lb		$t7,	($t3)				#temp2 = arr[j]
					sb		$t7,	($t2)				#arr[i] = temp2
					sb		$t6,	($t3)				#arr[j] = temp1

					move	$t2,	$t4
					addi	$t2,	$t2,	1			#++idx
					b		reverse_arr

					
					print_arr:
					addi	$t1,	$t1,	1			#reset $t1 to length
					li		$v0,	4004
					li		$a0,	1
					move	$a1,	$t0
					move	$a2,	$t1
					syscall

					#reset regs
					lw		$a0,	($sp)
					lw		$a1,	4($sp)
					lw		$a2,	8($sp)
					lw		$a3,	12($sp)
					lw		$t0,	16($sp)
					lw		$t1,	20($sp)
					lw		$t2,	24($sp)
					lw		$t3,	28($sp)
					lw		$t4,	32($sp)
					lw		$t5,	36($sp)
					lw		$t6,	40($sp)
					lw		$t7,	44($sp)
					lw		$ra,	48($sp)

					#reset stack pointer
					addi	$sp,	$sp,	52
					#return
					jr		$ra



		

	print_space:	addi	$sp,	$sp,	-24
					sw		$v0,	($sp)
					sw		$a0,	4($sp)
					sw		$a1,	8($sp)
					sw		$a2,	12($sp)
					sw		$a3,	16($sp)
					sw		$ra,	20($sp)

					li		$v0,	4004
					li		$a0,	1
					la		$a1,	space
					li		$a2,	1
					syscall
					
					#reset	regs
					lw		$v0,	($sp)
					lw		$a0,	4($sp)
					lw		$a1,	8($sp)
					lw		$a2,	12($sp)
					lw		$a3,	16($sp)
					lw		$ra,	20($sp)

					#reset stack pointer
					addi	$sp,	$sp,	24
					jr		$ra






	print_newline:	addi	$sp,	$sp,	-24
					sw		$v0,	($sp)
					sw		$a0,	4($sp)
					sw		$a1,	8($sp)
					sw		$a2,	12($sp)
					sw		$a3,	16($sp)
					sw		$ra,	20($sp)

					li		$v0,	4004
					li		$a0,	1
					la		$a1,	newline
					li		$a2,	1
					syscall
					
					#reset	regs
					lw		$v0,	($sp)
					lw		$a0,	4($sp)
					lw		$a1,	8($sp)
					lw		$a2,	12($sp)
					lw		$a3,	16($sp)
					lw		$ra,	20($sp)

					#reset stack pointer
					addi	$sp,	$sp,	24
					jr		$ra
