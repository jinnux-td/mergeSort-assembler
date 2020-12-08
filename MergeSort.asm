.data
iArray: .word 33  -90   14   44  -34  -58  -85    9  -52  -26  -67  -16   43   75  -81   85   56   62  -57   40
iLeft: .word 0:19
iRight: .word 0:19
size: .word 20
space: .asciiz " "
linebreak: .asciiz "\n"

##E End declaring
.text
main:
la $a0 iArray #address of first element
la $t0 size
lw $a1 0($t0) #a1 = 20

jal mergeSort

j terminate

###### END
mergeSort:
#a0 la dia chi bat dau
#a1 la so luong  phan tu

addi $sp $sp -16
sw $ra, 12($sp)
sw $a0, 8($sp)	 # Start array
sw $a1, 4($sp)  # Kích thuoc mang
		#0(sp) là vi trí middle + 1
		
sub $t1, $a1, 1
blez $t1, mergeReturn	
srl $t1, $t1, 1		
add $t1, $t1, 1
sw $t1, 0($sp)

lw $a1, 0($sp)		#a1 = middle + 1

#Tai day a1 la middle + 1, a0 la dau mang

jal mergeSort		#sort the first half

lw $a1, 0($sp)		
lw $t2, 4($sp)		
sub $a1, $t2, $a1	# a1 is size of the right half

lw $a0, 8($sp)		
lw $t2, 0($sp)		
sll $t2, $t2, 2
add $a0, $a0, $t2	#a0 la dia chi arr[mid + 1]

jal mergeSort

### Start MERGING
lw $a0, 8($sp)		#start

lw $a1, 0($sp)		
sub $a1, $a1, 1		
sll $a1, $a1, 2
add $a1, $a1, $a0	#arr[middle]

lw $a2, 4($sp)
sub $a2, $a2, 1
sll $a2, $a2, 2
add $a2, $a0, $a2	#a2 is [end]

### merge
jal merge

###PRINT ARRAY AFTER MERGE
jal printArray

#Ket thuc goi ham, tra thanh ghi sp ve dieu kien truoc do

mergeReturn:
lw $a1 4($sp)
lw $a0 8($sp)
lw $ra 12($sp)
addi $sp $sp 16
jr $ra

#######
#a0 = left, a1 = mid , a2 = right
printArray: 
addi $sp $sp -16
sw $ra, 12($sp)
sw $a0, 8($sp)		
sw $a1, 4($sp)		
sw $a2, 0($sp)		

#la $a0 iArray
sub $t0 $a2 $a0
srl $t0 $t0 2
addi $a1 $t0 1

addi $t0 $0 0 #count
addi $t1 $a0 0 #temporary
loop:
bne $t0 $a1 label

li $v0, 4
la $a0, linebreak
syscall

lw $a2, 0($sp)
lw $a1, 4($sp)
lw $a0, 8($sp)
lw $ra, 12($sp)
addi $sp $sp 16
jr $ra

label:
#print interger
lw $t2 0($t1)
move $a0 $t2
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $t1 $t1 4
addi $t0 $t0 1
j loop


#######
merge: 
addi $sp $sp -16 #start merge
sw $ra, 12($sp)
sw $a0, 8($sp)		#left
sw $a1, 4($sp)		#middle
sw $a2, 0($sp)		#right

sub $t0 $a1 $a0	
addi $t0 $t0 4
srl $t0 $t0 2 	#n1

sub $t1 $a2 $a1	
srl $t1 $t1 2 	#n2

la $t2 iLeft		#L[n1]
la $t3 iRight		#R[n2]

li $t5, 0 #i

loadL:

bge $t5 $t0 endloop1
sll $t6, $t5, 2
add $t6, $a0, $t6
lw $t4, 0($t6)
sw $t4, 0($t2)
addi $t2, $t2, 4
addi $t5, $t5, 1
j loadL

endloop1:

li $t5, 0 #i

loadR:

bge $t5 $t1 endloop2
sll $t6, $t5, 2
add $t6, $a1, $t6
lw $t4, 4($t6)
sw $t4, 0($t3)

addi $t3, $t3, 4
addi $t5, $t5, 1
j loadR

endloop2:

li $t4 0	#i
li $t5 0	#j
li $t6 0	#k

la $s0, iLeft
la $s1, iRight
# From here we use s0 and s1 for iLeft and iRight

loopMerge:
bge $t4, $t0, jump	#t0 is n1
bge $t5, $t1, jump	#t1 is n2
 #if
lw $t2 0($s0)	#L[i]
lw $t3, 0($s1)	#R[j]

sll $s2, $t6, 2
add $s2, $s2, $a0	#left[k]
ble $t2, $t3, leftCase

sw $t3, 0($s2)
addi $t5, $t5, 1
addi $t6, $t6, 1
addi $s1, $s1, 4
j loopMerge
leftCase:
sw $t2, 0($s2)
addi $t4, $t4, 1
addi $t6, $t6, 1
addi $s0, $s0, 4
j loopMerge

jump: #end loopMerge
li $s3, 0 #Bien kiem tra xem loop2 co duoc chay hay khong

loopaf1: #t6 = k, t4 = i
bge $t4, $t0, endloopaf1
li $s3, 1
lw $t2 0($s0)		#L[i]

sll $s2, $t6, 2
add $s2, $s2, $a0	#left[k]

sw $t2, 0($s2)

addi $t4, $t4, 1	#i++
addi $t6, $t6, 1	#k++
addi $s0, $s0, 4	# Nhay sang dia chi L ke tiep

j loopaf1
endloopaf1:

#Tai day neu loop1 da duoc chay thi khong chay doan loop2
beq $s3, 0, skip

loopaf2: #t6 = k, t5 = j
bge $t5, $t1, endloopaf2

lw $t2 0($s1)		#R[j]

sll $s2, $t6, 2
add $s2, $s2, $a0	#left[k]

sw $t2, 0($s2)

addi $t5, $t5, 1	#j++
addi $t6, $t6, 1	#k++
addi $s1, $s1, 4	#nhay sang dia chi R ke tiep
j loopaf2
endloopaf2:

skip:
lw $a1 4($sp)
lw $a0 8($sp)
lw $ra 12($sp)
addi $sp $sp 16
jr $ra

terminate:
