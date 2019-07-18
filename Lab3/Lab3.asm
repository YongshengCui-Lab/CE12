##########################################################################
# Created by: Yongsheng Cui
#              yocui
#              15 February 2018
#
# Assignment:  Lab 3: MIPSLoopingASCIIArt
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2018
#
# Description: This program prints ¡®Triangle¡¯ to the screen.
#
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################
.data
	TriLength: .asciiz "Enter the length of one of the triangle legs:"
	TriNumber: .asciiz  "Enter the number of triangles to print:"
	Space: .asciiz "\n"
.text
	li $t0, 0  	#set t0 = 0
	li $t1, 0  	#set t1 = 0
	li $t2, 0  	#set t2 = 0
	
	#Read and Store data from user	
	li $v0, 4		
	la $a0, TriLength
	syscall
	
	li $v0 5
	syscall
	move $s0 $v0
	
	li $v0 4
	la $a0,TriNumber
	syscall
	
	li $v0 5
	syscall
	move $s1 $v0
		 
	 loop1:
	 	beq $t1 $t0 loop2	#if t1 == t0, go to loop2
	 	addi $t1 $t1 1		#t1++
	 	li $v0 11		#print character
	 	la $a0 32		#print ' '
	 	syscall
	 	j loop1			#return
	 	
	 loop2:
	 	beq $t0 $s0,temp	# if t0 == s0, go to temp
	 	addi $t0 $t0 1		#increase t0 by 1
	 	li $t1, 0		#t1 = 0
	 	li $v0 11		#print character
	 	la $a0 92		#print '\'
	 	syscall
	 	blt $t0 $s0 Target	#branch to target if #t0 < $s0
	 	j loop1	
	 	
	 	temp:
		 li $v0, 4		#print string
	 	 la $a0, Space		#print Space
		 syscall
	 	
	 	Target:
	 	li $v0,4		#print string
	 	la $a0, Space		#print ' '
	 	syscall
	 	j loop1			#jump to loop1
	 		 	
	 	addi $t4 $t0 -1
	 	
	 loop3:
	 	beq $t2 $s1 end		#t2 == s1, we are done
		addi $t2 $t2 1		#increase by 1
	 	li $t0, 0
	 	j loop2			#jump to loop2
	 	
	 loop4:	 	
	 	beqz $t4 loop3		#branch to loop1 if t4 == 0
	 	addi $t4, $t4, -1	#t4- -
	 	addi $t3 $t4 0		#t3 = t4
	 	j loop5
	 	
	 loop5:
	 	beqz $t3 out		#branch here if t3 == 0
	 	addi $t3 $t3 -1		#t3- -
	 	li $v0 11		#print character
	 	la $a0 32		#print ' '
	 	syscall
	 	j loop4
	 		
	 	out:
	 	li $v0 11		#print character
	 	la $a0 47		#print '/'
	 	syscall
	 	li $v0, 4		#print string
	 	la $a0, Space		#print ' '
	 	syscall
	 	j loop4			#jump to loop4
	 		
	 	end:
	 	li $v0,10		#exit
	 	syscall
	 	
	 
	 
	
	
	
