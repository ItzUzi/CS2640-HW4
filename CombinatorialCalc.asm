		.data
inptR:	.asciiz	"Enter value for r\n"
inptN:	.asciiz	"Enter value for n\n"
rqmtN:	.asciiz "n must be greater than r\n"
rqmtR:	.asciiz "r must be greater than 0\n"
rslt:	.asciiz "Result is: "
	.align	2
total:	.word	0
valR:	.word	0
valN:	.word	0
		.text

.globl main
main:
	jal	getR		# calls subroutine to get R from user
	jal	getN		# calls subroutine to get N from user
	lw	$a0, valN	# loads value N into $a0
	lw	$a1, valR	# loads value R into $a1
	jal	cmbint		# calls combinatorial routine
	j	done		# jumps to done

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
	li	$v0, 0			# result
comb:
	addiu	$sp, $sp, -12		# makes space on stack for 3 ints
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	
	beq	$a0, $a1, incr		#checks base case (n == r)
	beqz	$a1, incr		#checks base case (r == 0)
	
	sub	$a0, $a0, 1		# n - 1
		
	jal	comb			#(n-1, r)
cmd2:
	sub	$a1, $a1, 1		# r - 1
	jal	comb			#(n-1, r-1)
	j	cmdne
incr:
	addi	$v0, $v0, 1		# adds if base case
cmdne:
	lw	$ra, 0($sp)		#loads last iteration of stack
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	addiu	$sp, $sp, 12		# removes allocated space on stack
	jr	$ra
done:
	sw	$v0, total		# saves total onto glbl var
	# prints result string w/ sum
	la	$a0, rslt
	li	$v0, 4
	syscall
	lw	$a0, total
	li	$v0, 1
	syscall

	# gracefully exits program
	li	$v0, 10
	syscall
