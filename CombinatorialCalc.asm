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
	jal	comb1
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
comb1:
	addiu	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)	# value of n
	sw	$a1, 8($sp)	# value of r
	
	# base case 1 n == r
	beq	$a0, $a1, cmbdne
	
	move	$s0, $a0
	move	$s0, $a1
	sub	$a0, $a0, 1
	bne	$a0, $a1, comb1
	
	addi	$v0, $v0, 1
	
	jal	comb2
	# base case 2 r == 0
	beqz	$a1, cmbdne
	
comb2:
	addiu	$sp, $sp, 12	#store 2 val, $ra, n, and r
	sw	$ra, 0($sp)	# store $ra
	sw	$a0, 4($sp)	# store n
	sw	$a1, 8($sp)	# store r
	
	jal	comb1
	jr	$ra
cmbdne:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra
done:
	sw	$v0, sum
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
