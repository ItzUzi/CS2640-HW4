		.data
inptR:	.asciiz	"Enter value for r\n"
inptN:	.asciiz	"Enter value for n\n"
rqmtN:	.asciiz "n must be greater than r\n"
rqmtR:	.asciiz "r must be greater than 0\n"
rslt:	.asciiz "Result is: "
		.align 2
		.text
		
#	0($sp) 	-- return address
#	4($sp) 	-- value of r
#	8($sp) 	-- value of n
#	12($sp)	-- value of sum
#	$a1	-- value of initial r
#	$t0	-- val of r
#	$t1	-- val of n


init:	
	addiu	$sp, $sp, -12	#allocates space on stack
tkeR:	
	li 	$v0, 4		#syscall to print String
	la 	$a0, inptR	#asks for input for R
	syscall
	la 	$a0, rqmtR	# asks rqmt for R
	syscall
	li 	$v0, 5		# takes int for r
	syscall
	move	$t0, $v0	# if user input is less than 0
	blez	$t0, tkeR	# loop back to tkeR:
	move	$a1, $t1	#saves r in a1
tkeN:	
	li	$v0, 4
	la	$a0, inptN	#asks for value for n
	syscall
	la	$a0, rqmtN	#prints rqmt for n
	syscall
	li	$v0, 5		# takes int for n
	syscall
	move	$t1, $v0
	blt	$t1, $t0, tkeN	# if n is less than R
				# asks for N again
	sw	$t0, 4($sp)	# stores val of r in stack
	sw	$t1, 8($sp)	# stores val of n in stack
	move	$v0, $t0
	move	$v1, $t1

comb:	
	jal	bsecse
	jal	comb1
	lw	$v0, 4($sp)	# copies r into $v0
	lw 	$v1, 8($sp)	# copies n into $v1
	jal	comb2
	lw	$v0, 4($sp)
	lw	$v1, 8($sp)
	addiu	$v0, $v0, -1
	addiu	$v1, $v1, -1
	sw	$v0, 4($sp)
	sw	$v1, 8($sp)
	jal	check
	j	comb
comb1:
	sw	$ra, 0($sp)
	addi	$v1, $v1, -1
	move	$v0, $a1
	jal	bsecse
	la	$a0, 0($sp)
	jr	$a0
comb2:
	sw	$ra, 0($sp)
	addi	$v1, $v1, -1
	addi	$v0, $v0, -1
	jal	bsecse
	la	$a0, 0($sp)
	jr	$a0
bsecse:
	beqz	$v0, incm
	beq	$v0, $v1, incm	
	jr	$ra
incm:	
	lw	$t0, 12($sp)	#adds 1 to result
	addi 	$t0, $t0, 1	
	sw	$t0, 12($sp)
	lw	$t0, 8($sp)
	beqz	$t0, done
check:
	lw	$v0, 4($sp)
	lw	$v1, 8($sp)
	beqz	$v0, done
	beq	$v0, $v1, done
	jr	$ra
done:	
	la	$a0, rslt
	li	$v0, 4
	syscall
	lw	$a0, 12($sp)
	li	$v0, 1
	syscall
	addiu	$sp, $sp, 12	# clears stack
	li $v0, 10	
	syscall
