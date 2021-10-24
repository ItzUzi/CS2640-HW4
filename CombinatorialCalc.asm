		.data
inptR:	.asciiz	"Enter value for r\n"
inptN:	.asciiz	"Enter value for n\n"
rqmtN:	.asciiz "n must be greater than r\n"
rqmtR:	.asciiz "r must be greater than 0\n"
rslt:	.asciiz "Result is: "
	.align	2
sum:	.word	0
valR:	.word	0
valN:	.word	0
		.text

.globl main
main:
	jal	getR
	jal	getN
	lw	$a0, valN
	lw	$a1, valR
	jal	cmbint
	j	done

getR:	
	# prints out prompt and requirment for r
	li 	$v0, 4
	la	$a0, inptR
	syscall
	la	$a0, rqmtR
	syscall
	
	# takes value of r
	li	$v0, 5
	syscall
	blez	$v0, getR	# if r <= 0, loop again
	sw	$v0, valR	# saves r onto global var
	jr	$ra		#jumps back to method caller
	
getN:	
	# prints out prompt and requirement for n
	li	$v0, 4
	la	$a0, inptN
	syscall
	la	$a0, rqmtN
	syscall
	
	lw	$t0, valR	# temp var for R
	
	# takes vale of n
	li	$v0, 5
	syscall
	ble	$v0, $t0, getN	# if n <= r loop again
	sw	$v0, valN	# saves n onto global var
	jr	$ra		#jumps back to method caller
##############################################################
#	0($sp)	hold return address
#	4($sp)	hold r
#	8($sp)	hold n
cmbint:
	li	$v1, 0			# result
	move	$s0, $a0
	move	$s1, $a1
comb:
	addiu	$sp, $sp, -12		# makes space on stack for 3 ints
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	
	beq	$s0, $s1, incr
	beqz	$s1, incr
	
	sub	$s0, $s0, 1		# n - 1
		
	jal	comb			#(n-1, r)
cmd2:
	sub	$s1, $s1, 1		# r - 1
	jal	comb			#(n-1, r-1)
	j	cmdne
incr:
	addi	$v1, $v1, 1		# adds if (n-1, r-1) is base case
cmdne:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra
done:
	sw	$v1, sum
	# prints result string w/ sum
	la	$a0, rslt
	li	$v0, 4
	syscall
	lw	$a0, sum
	li	$v0, 1
	syscall

	# gracefully exits program
	li	$v0, 10
	syscall
