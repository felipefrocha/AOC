.data
  vetor: .word      10 5 1 3 50 10 100 11 7 6 9 20 15 19 131 4 
         .word      2 19 18 17 12 0  
  tamanho: .asciiz  "Tamanho do vetor é de: "
  print: .asciiz    "\n"
  espaco: .asciiz    "\t"
  maior: .asciiz    "\n maior\n"
  menor: .asciiz    "\n menor\n"
  vectorTxt: .asciiz "\nVetor Ordenado é:\n"

.text
main:
  la $s5, vetor  

  jal sizeVector

  jal buble

exit:
  li    $v0,  10
  syscall

buble: 
  li    $s0,  0
mainLoop:
  bge   $s0,  $t0,  printVetorOrdenado
  li $s1, 0
  auxLoop:
    bge $s1, $t0, endMainLoop

    sll $t1, $s0, 2
    sll $t2, $s1, 2 

    add $t1, $s5, $t1
    add $t2, $s5, $t2

    lw $t3, ($t1)
    lw $t4, ($t2)
    
    blt $t3, $t4, swap

  addLoop:
    addi $s1, $s1, 1
    j auxLoop

    swap: 
      sw $t3, ($t2)
      sw $t4, ($t1)
      li $v0, 4
      la $a0, maior
      syscall
      li $v0, 1
      la $a0, 0($t1)
      syscall
      li $v0, 4
      la $a0, print
      syscall
      li $v0, 1
      la $a0, 0($t2)
      syscall
      j addLoop
      
      
      
  endMainLoop:
    addi $s0, $s0, 1
    j mainLoop





sizeVector:
 	addi  $sp,  $sp, -8
  sw    $s5,  0($sp)
  sw    $ra,  4($sp)
  whileVector:
    lw    $t9,  0($s5)
    beq   $t9,  $0, callPrintSize
    addi  $t0,  $t0, 1
    addi  $s5,  $s5, 4
    j   whileVector
  callPrintSize:
    jal printSize
    # lembra ultimo caminho
    lw    $ra,  4($sp)
    lw    $s5,  0($sp)
    jr    $ra

printSize:
  la $a0, tamanho
  li $v0, 4
  syscall
  la $a0, print
  syscall
  syscall
  la    $a0,  ($t0)
  li    $v0,  1
  syscall
  jr    $ra

printVetorOrdenado:
  li $s3, 0
  la $a0, vectorTxt
  li $v0, 4
  syscall
printVector:
  bge $s3, $t0, exit
  li    $v0,  4
  la $a0, print
  syscall
  la $a0, espaco
  syscall


  sll $t6, $s3, 2
  
  add $t6, $s5, $t6

  lw $t7, 0($t6)
  
  la $a0, ($t7)
  li    $v0,  1
  syscall
  
  addi $s3, $s3, 1
  j printVector
