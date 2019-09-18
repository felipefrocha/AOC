.data
  vetor: .word      10 5 1 3 50 10 100
  print: .asciiz    "\n"
  espaco: .asciiz    "\t"
  maior: .asciiz    "\n maior\n"
  menor: .asciiz    "\n menor\n"
.text


main:
  la    $s1,  vetor         # s1 ponteiro vetor
  li    $s0,  0         # s0 indice for
  j LOOP
      
LOOP:
  beq   $s0,  6, EXIT       # index i 
  add   $t1,  $s0, $s0      # 2*i
  add   $t1,  $t1, $t1      # 4*i -> numero bytes por word vs index i
  add   $t1,  $t1, $s1      # pointer *(a+i) 
  lw    $t0,  0($t1)        # value a[i] valor na posição do ponteiro
  li    $s2, 0
  j LOOP1
  break:
  addi  $s0,  $s0,  1
  j LOOP

bge	

LOOP1:
    beq   $s2,  6, break       # index j 
    add   $t3,  $s2, $s2      # 2*j
    add   $t3,  $t3, $t3      # 4*j -> numero bytes por word vs index i
    add   $t3,  $t3, $s1      # pointer *(a+j) 
    lw    $t2,  0($t3)
    slt   $t8,  $t0, $t2      # t2 > t0
    beq   $t8,  1,  lessThen
    j greatThen
    lessThen:
      la $a0, menor
      li $v0, 4 
      syscall
      sw 	$t2,  0($t1)
      sw  $t0,  0($t3)
      j break1
    greatThen:
      la $a0, maior
      li $v0, 4 
      syscall
      sw  $t0,  0($t3)        # vec[j] = vec[i]
      sw  $t2,  0($t1)        # vec[i] = aux
      j break1
    break1:
      la $a0, ($t0)
      li $v0, 1
      syscall
      la $a0, print
      li $v0, 4 
      syscall
      la $a0, ($t2)
      li $v0, 1
      syscall
      la $a0, print
      li $v0, 4 
      syscall
    # end for condition
    addi  $s2,  $s2,  1
    j LOOP1
EXIT: 
  li $s0, 0
printVetor:
  beq   $s0,  6, finalizaPrograma      # index i 
  add   $t1,  $s0, $s0      # 2*i
  add   $t1,  $t1, $t1      # 4*i -> numero bytes por word vs index i
  add   $t1,  $t1, $s1      # pointer *(a+i) 
  lw    $t0,  0($t1)
 la $a0, ($t0)
  li $v0, 1
  syscall
  la $a0, espaco
  li $v0, 4
  syscall 
  syscall 
  # end for condition
  addi  $s0,  $s0,  1
  j printVetor
finalizaPrograma:



