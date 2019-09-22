.data 
	meio : .float 0.5
	cnst : .float 0.166667 
	dois: .float 2.0
	x0: .float 0.0
	x : .float 2.0
	y : .float 1.0
	h : .float 0.02


.text
	#Rotina main segue boas práticas de programação
	main:
		la $a0, x0
		la $a1, y
		la $a2, x
		la $a3, h
		jal RK4
		mtc1 $v0, $f12
		jal printOut
	exit:
		# Saida do código como padrão
		li $v0, 10
		syscall
	printOut:
		li $v0, 2
		syscall
		jr $ra

	RK4:
		lwc1 $f1, ($a0) 		# x0
		lwc1 $f2, ($a1) 		# y0 
		lwc1 $f3, ($a2)		# x
		lwc1 $f4, ($a3)		# h 
				
		# Elmentos de configuração de Runge Kutta
		# Armazena caminho chamou a função de RK4
		sub $sp, $sp , 4
		sw $ra, ($sp)
				
		sub.s $f10, $f3, $f1	
		div.s $f10, $f10, $f4	# n

		cvt.w.s 	$f10, $f10		# n = (int) (x0-x)/h
		mfc1 $s3, $f10

		add.s $f13, $f2, $f0			# y = y0
		#FOR  
		move $s0, $zero     		# i = 0 ($s0 é i)  
		LOOP:      
			# configurações do FOR      
			slt $t0, $s0, $s3      # t0 = 0 se $s0 >= $s3 ( i >= n), t0 = 1 caso contrário
			beq $t0, $zero, BREAK   # se $s0 >= $s3 ( i >= n) vá para BREAK      7

			
			# k1
			mfc1 $a0, $f1  			# x0
			mfc1 $a1, $f13 			# y
			jal derivative 
			mtc1 $v0, $f31			# dxdy x0, y
			mul.s $f5, $f4, $f31 		# k1 = h*dxdy(x0,y)
			# k2
			lwc1 $f30, meio
			mul.s $f14, $f30, $f4
			add.s $f14, $f14, $f1 	# x0 + h*0.5
			mfc1 $a0, $f14 			
			mul.s $f15, $f30, $f5
			add.s $f15, $f15, $f13 	# y + k1*.5
			mfc1 $a1, $f15			
			jal derivative 
			mtc1 $v0, $f31		
			mul.s $f6, $f4, $f31	# k2 = 
			# k2
			mfc1 $a0, $f14 			
			mul.s $f15, $f30, $f6
			add.s $f15, $f15, $f13 	# y + k2*.5
			mfc1 $a1, $f15			
			jal derivative 	
			mtc1 $v0, $f31			
			mul.s $f7, $f4, $f31	# k3 = 
			# k4
			add.s $f14, $f4, $f1 	# x0 + h
			mfc1 $a0, $f14 			
			add.s $f15, $f7, $f13 	# y + k3
			mfc1 $a1, $f15			
			jal derivative 
			mtc1 $v0, $f31				
			mul.s $f8, $f4, $f31 # k4 = 

			
			# Atualiza valor de y
			lwc1 $f25, cnst
			lwc1, $f24, dois
			mul.s $f26, $f25, $f6
			mul.s $f7, $f7, $f24
			mul.s $f26, $f26, $f7
			mul.s $f8, $f8, $f24
			mul.s $f26, $f26, $f8
			mul.s $f26, $f26, $f25
			add.s $f13, $f26, $f13
			# atualiza valor x
			add.s $f1, $f1, $f4
			addi $s0, $s0, 1       # $s0 = $s0 + 1 (ou i = i + 1) é o contador      
			j LOOP                 # volta para o LOOP  
		BREAK:    
	# configurações do procedimento    
		mfc1 $v0, $f13 # retorna para quem chamou.
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
		
	derivative:
		mtc1 $a0, $f28
		mtc1 $a1, $f29

		sub.s $f28, $f28, $f29
		mfc1  $v0, $f29
		jr $ra
		 
