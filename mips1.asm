.data
	tabuleiro:  .word   0, 0, 0, 0, 0, 0, 0, 0, 0      # Array de 3x3 para representar o tabuleiro
	p1: .word 0   # p1 
	p2: .word 0   # p2 
	j: .word 0    # j 
	i: .word 1    # i com o valor 1
	msg: .asciiz "Digite A Posicao Na Qual Vc Quer Jogar"
	invalido: .asciiz "Posicao Invalida"
	coluna: .asciiz "Coluna"
	venceu1: .asciiz "Jogador 1 Venceu!!!"
	venceu2: .asciiz "Jogador 2 Venceu!!!"
	empate: .asciiz "Empate"
	dd: .asciiz "Diag1 ee Diag2"
	dig: .asciiz "Diag1"
	dig2: .asciiz "Diag2"
	linha: .asciiz "\n"
	espaco: .asciiz " "
	x: .asciiz "X"
	o: .asciiz "O"
	traco: .asciiz "|"
	
.text
.global main

#funcao
jogar:
		lw $t0, p1    
    		lw $t1, p2    
    		lw $t2, j    
		lw $t3, i     
	whileloop:
		lw $t3, i     		
		beqz $t3, endwhile 	# Se i == 0, sair do loop
	#printf("Digite A Posicao Na Qual Vc Quer Jogar ");
	#scanf("%d %d", &p1, &p2);
		la $a0, msg     	#atribuição da string 
		li $v0, 4       	#impressão da string 
		syscall         	#Executa
			
		li $v0, 5 		#Ler p1
		syscall			#executa
		move $t0, $v0 		#move o valor de $v0 para $t0  ou seja p1 = valor;
			
		li $v0, 5 		#Ler p2
		syscall			#executa
		move $t1, $v0 		#move o valor de $v0 para $t1 ou seja p2 = valor;

		sub $t0, $t0, 1         # --p1
		sub $t1, $t1, 1         # --p2

		sll $t2, $t0, 2   	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, $t1 	# Adiciona o deslocamento p2
		sll $t2, $t2, 2   	# Multiplicar p2 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, tabuleiro # Calcula o endereço de tabuleiro[p1][p2]
		lw $t3, 0($t2)    	# Carrega o valor de tabuleiro[p1][p2] em $t3

		beqz $t3, invalid  	# Se tabuleiro[p1][p2] == 0, vá para invalid
		
		li $v0, 4               # Imprimir "Posicao Invalida"
    		la $a0, invalido    	# Carrega a mensagem em $a0
    		syscall                 #executa

    		li $v0, 1              # Imprimir o valor de tabuleiro[p1][p2]
    		lw $a0, 0($t2)         # Carrega o valor de tabuleiro[p1][p2] em $a0
    		syscall                #executa

		li $t4, 1              # Carrega o valor 1 em $t4
   		sw $t4, i              # Atribui 1 a i
    		j endif                # final do bloco if-else
	invalid: 
		li $t4, 0             # Carrega o valor 0 em $t4
  		move $s0, $t4         # Move o valor de $t4 para $s0 (variável i)
	endif:
	j whileloop  	 		# Volta para o início do loop
		#tabuleiro[p1][p2] = s;
		lw $t5, 0($t5) 		# s em $t5
		sll $t6, $t0, 2         # Multiplicar p1 pela potência de 2 para o deslocamento em bytes
    		add $t6, $t6, $t1       # Adiciona o deslocamento de p2
		sll $t6, $t6, 2         # Multiplicar p1 pela potência de 2 para o deslocamento em bytes
    		add $t6, $t6, tabuleiro # Calcula o tabuleiro[p1][p2]
		sw $t5, 0($t6) 		#gurda o valor
	 # Chamar a função testeLinha
		move $a0, tabuleiro 
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeLinha      # Chamar a função testeLinha

	 	beqz $v0, else 		 #Retorna zero ou s
		move $v0, $t5            #Retorna o valor de s 
    		j endLinha               #Vai para o fim da função
	else:
    		move $v0, $zero     # retorna zero
	endLinha:
# Chamar a função testeColuna
		move $a0, tabuleiro # if(testeColuna(tabuleiro, s, p1, p2))
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeColuna     # Chamar a função testeColuna

	 	beqz $v0, else 		 #Retorna zero ou s
		la $a0, coluna   	 #Inmpressao da "coluna" 
    		li $v0, 4          	 
   		syscall             	 # executa

		move $v0, $t5            #Retorna o valor de s 
    		j endColuna              #Vai para o fim da função
	else:
    		move $v0, $zero     # retorna zero
	endColuna:

	#if(p1 == 1 && p2 == 1)
		beq $t0, 1, label		# p1 == 1
   		j end                   # pula para o fim da função
	label:
    		beq $t1, 1, diag1	     #p2 == 1
    		j end                        	     # fim da função
	diag1:
	# Chame a função testeDiag1 e testeDiag2
		move $a0, tabuleiro # if(testeDiag1(tabuleiro, s, p1, p2))
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeDiag1      # Chamar a função testeDiag1
		move $t6, $v0       # Armazenar resultado em $t6
		bne $t6, $zero, diagonal  #teste
		move $a0, tabuleiro # if(testeDiag2(tabuleiro, s, p1, p2))
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeDiag2      # Chamar a função testeDiag2
		move $t6, $v0       # Armazenar resultado em $t6
		bne $t6, $zero, diagonal #teste

		j falso 	#se for falso 

	diagonal: 
		la $a0, dd
   		li $v0, 4
    		syscall

		move $v0, $t5            #Retorna o valor de s 
    		j enddiagonal              #Vai para o fim da função

	else:
    		move $v0, $zero     # retorna zero
	enddiagonal:
	#chama função testeDiag1
		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
		beq $t0, $t1, Igual  #Compara
		j finaL              # Salta para o final do código
	Igual: 
		move $a0, tabuleiro # if(testeDiag1(tabuleiro, s, p1, p2))
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeDiag1      # Chamar a função testeDiag1

		beq $v0, IguaL  #Compara

		la $a0, dig   
    		li $v0, 4        
    		syscall   

		move $v0, $t5            #Retorna o valor de s 
    		j endDiag1               #Vai para o fim da função

	else:
    		move $v0, $zero     # retorna zero

	finaL:
		#if((p1 == 2 && p2 == 0) || (p2 == 2 && p1 ==0)){
		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
		li $t7, 2
		li $t8, 0
		beq $t0, $t7, cond1 # p1 == 2
		j cond2
	cond1: 
		beq $t1, $t8, cond1e2True # p2 == 0
		j Conde2
	Conde2: 
		beq $t1, $t2, cond2True # p2 == 2
		j endcond	
	Conde2: 
		beq $t0, $t7, cond1e2True # p1 == 0
		j endcond
	cond2True: # if(testeDiag2(tabuleiro, s, p1, p2))
		move $a0, tabuleiro # if(testeDiag2(tabuleiro, s, p1, p2))
   		move $a1, $t5       # valor de s 
    		move $a2, $t0       # valor de p1 
    		move $a3, $t1       # valor de p2 
    		jal testeDiag2      # Chamar a função testeDiag2
		beqz $v0, endcond	# Se zero

		la $a0, dig2   
    		li $v0, 4        
    		syscall  
		move $v0, $t5            #Retorna o valor de s 
    		j endDiag2               #Vai para o fim da função
	else:
    		move $v0, $zero     # retorna zero
	endDiag2:
testeLinha: 
		lw $t7, i     # Carrega o endereço de i em $t3
		move $s0, $s2    # $s0 = $s2 (i = p2) 
		move $s2, $s1    # $s2 = $s1 (p2 = p1)
		sub $s2, $s2, -1         # --p1 
		li $t0, -1        # $t0 = -1
		beq $s1, $t0, endlinha  # Se p1 != -1, salta para o endLinha
		li $s1, 2   # p1 = 2
	endlinha:
		addi $s2, $s2, 1  # ++p2
		li $t0, 3        # $t0 = 3
		beq $s2, $t0, endLinha  # Se p2 == 3
		li $s2, 0      # p2 = 0
	endLinha:
		la $t1, tabuleiro 	 # Endereço base do tabuleiro
		sll $t2, $p1, 2    	 # Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, $t1  	 # Adicionar o deslocamento ao endereço base
		add $t2, $tabuleiro, $t2 # Calcula o endereço de tabuleiro[p1][i]
		lw $t4, ($t2)		 #tabuleiro[p1][i]
		sll $t3, $p3, 2    	 # Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t3, $t3, $t2  	 # Adicionar o deslocamento ao endereço base
		add $t3, $tabuleiro, $t3 # Calcula o endereço de tabuleiro[p2][i]
		lw $t5, ($t3)		#tabuleiro[p2][i]

		beq $t4, $t5, check_s	#Comparação de tabuleiro[p1][i] e tabuleiro[p2][i] #O rótulo check_s é usado em conjunto com as instruções beq (branch equal) e j (jump).
		j return_zero:
	check_s:
		li $t6, s		#verifica se tabuleiro[p2][i] é igual a s.
		beq $t5, $t6, true
		j exit
	true:
		move $v0, $t6 		#Sendo verdadeira, retornar s
		j exit
	return_zero:
		li $v0, 0		#Sendo falsa, retornar 0
		j exit
	exit:

testeColuna:
		move $s0, $s2    # $s0 = $s2 (i = p2) 
		move $s2, $s1    # $s2 = $s1 (p2 = p1)
		sub $s2, $s2, -1         # --p1 
		li $t0, -1        # $t0 = -1
		beq $s1, $t0, endcoluna  # Se p1 != -1, salta para o endLinha
		li $s1, 2   # p1 = 2
	endcoluna:
		addi $s2, $s2, 1  # ++p2
		li $t0, 3        # $t0 = 3
		beq $s2, $t0, endColuna  # Se p2 == 3
		li $s2, 0      # p2 = 0
	endColuna:
		la $t1, tabuleiro  	# Endereço base do tabuleiro
		sll $t2, $p1, 2   	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, $t1  	# Adicionar o deslocamento ao endereço base
		sll $t2, $p1, 2   	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, $t1  	# Adicionar o deslocamento ao endereço base
		lw $t4, ($t2)		#tabuleiro[p1][i]

		sll $t3, $p3, 2    	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t3, $t3, $t2  	# Adicionar o deslocamento ao endereço base
		sll $t3, $p3, 2    	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t3, $t3, $t2  	# Adicionar o deslocamento ao endereço base

		
		
		lw $t5, ($t3)		#tabuleiro[p2][i]
		beq $t4, $t5, check_s	#Comparação de tabuleiro[p1][i] e tabuleiro[p2][i] #O rótulo check_s é usado em conjunto com as instruções beq (branch equal) e j (jump).
		j exit
	check_s:
		li $t6, s		#verifica se tabuleiro[p2][i] é igual a s.
		beq $t5, $t6, true
		j return_zero:
	true:
		move $v0, $t6 		#Sendo verdadeira, retornar s
		j exit
	return_zero:
		li $v0, 0		#Sendo falsa, retornar 0
		j exit
	exit:
testeDiag1:
		li $t0, -1        # $t0 = -1
		beq $s1, $t0, endDiag1  # Se p1 != -1, salta para o endLinha
		li $s1, 2   # p1 = 2
	endDiag1:
		addi $s2, $s2, 1  # ++p2
		li $t0, 3        # $t0 = 3
		beq $s2, $t0, enddiag1  # Se p2 == 3
		li $s2, 0      # p2 = 0
	enddiag1:
		la $t1, tabuleiro  	# Endereço base do tabuleiro
		sll $t2, $p1, 2   	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t2, $t2, $t1  	# Adicionar o deslocamento ao endereço base
		sll $t3, $p3, 2    	# Multiplicar p1 pela potência de 2 para o deslocamento em bytes
		add $t3, $t3, $t2  	# Adicionar o deslocamento ao endereço base
testeDiag2:
		move $s0, $s1 # $s0 = $s1 (i = p1)
		move $s3, $s2 # $s3 = $s2 (j = p2)
		add $s1, $s1, 1 # p1+1
		bne $s1, 3, diag21 # se p1 != 3 jump to diag21
		li $s0, -1 #  i = -1
		li $s3, 3 #  j = 3
	diag21:
		sub $s1, $s1, 1 # remove o +1 do p1
		add $s2, $s2, 1 # p2+1
		bne $s2, 3, diag22 #se p2 != 3 jump to diag21
		li $s1, 3  # p1 = 3
		li $s2, -1 # p2 = -1
		j exit # jump to exit
	diag22:
		sub $s2, $s2, 1 # remove o +1 do p2
		#if(tabuleiro[i+1][j-1] == tabuleiro[p1-1][p2+1] && tabuleiro[p1-1][p2+1] == s){
		la $t1, tabuleiro  	# Endereço base do tabuleiro
		add $s0, $s0, 1		#i+1
		sub $s3, $s3, 1		#j-1
		sub $s1, $s1, 1		#p1-1
		add $s2, $s2, 1		#p2+1
		add $s4, $s0, $s3	# tabuleiro[i+1][j-1]
		lw $t4, 0($t4)          # $t4 = tabuleiro[i+1][j-1]

		sub $s5, $s0, 1		#i-1
		add $s6, $s3, 1		#j+1
		add $s7, $s1, 1		#p1+1
		sub $s8, $s2, 1		#p2-1
		add $s8, $s0, $s3	# tabuleiro[i+1][j-1]
		lw $t8, 0($t8)          # $t8 = tabuleiro[p1-1][p2+1]

		beq $t4, $t8, Compa
		j fiM
	Compa:
		beq $t4, $s, return_s
		j fiM
	return_s:
		add $v0, $s, $zero       # $v0 = s 
		j end       
	fiM:
		add $v0, $zero, 0       # $v0 = 0
	end:
	exibirtabuleiro:
		li $t2, 0 		#Iniciando i em 0 
		li $t3, 0 		#Iniciando j em 0 

		beq $t2, 3, FIM		# se i == 3 encerra
		addi $t2, $t2, 1  	# i++

		la $a0, linha
   		li $v0, 4         
    		syscall

		la $a0, espaco
   		li $v0, 4         
    		syscall

		beq $t3, 3, FIM		# se j == 3 encerra
		addi $t3, $t3, 1  	# j++

	#switch(tabuleiro[i][j]){
		beq $t0, 1, case_1
		beq $t0, 2, case_2
		j default
	case_1:
		la $a0, x
	    	li $v0, 4
    		syscall
    		j end_switch
	case_2:
		la $a0, o
	    	li $v0, 4
    		syscall
    		j end_switch
	default:
		la $a0, espaco
		li $v0, 4
		syscall
		j end_switch
	end_switch:
	#if (j < 2){
		li $t8, 2
		slt $t9, $t3, $t8  #$t3 = j, $t8 = 2  -> j < 2
		beqz $t9, ELSE 		# condução falsa

		la $a0, traco
	    	li $v0, 4
    		syscall

	ELSE:
		la $a0, traco
	    	li $v0, 4
    		syscall
	FIM:
#main
	li $t0, 0 		#p1;
	li $t1, 0 		#p2; 
	li $t2, 0 		#i; 
	li $t3, 0 		#j;
	jal jogar		#chama a função 
			
		loop:
  		  	beq $t0, $zero, endLoop  # Verifica se $t0 é igual a zero   for(i = 0;i < 3;i++){
    			beq $t1, $zero, endLoop  # Verifica se $t1 é igual a zero   for(j = 0; j < 3; j++){
    			li $v0, 5                # Ler um inteiro
			#tabuleiro[i][j] = 0; 
    			syscall
			j loop
		endLoop
		 # função exibirtabuleiro(tabuleiro);
   			 la $a0, tabuleiro        # Carrega a matriz
   			 jal exibirtabuleiro      # exibirtabuleiro

		for:
		# for(i = 0,j = 9;!i && j;)
			bne $t2, $zero, end	    # Se !i == 0 sai do loop
			beq $t3, end		    # Se  j == 0, sai do loop
		# função jogar para o Jogador 1 
    			la $a0, tabuleiro           # atribui valor ao tabuleiro 
    			li $a1, 1                   # Jogador 1 
    			jal jogar                   # Chamada para a função jogar
 		# função exibirtabuleiro - Atualizado
   			 la $a0, tabuleiro		    # Carrega a matriz
   			 jal exibirtabuleiro        # exibirtabuleiro
		# Decrementa j
   			sub $t3, $t3, 1           # j-- OU PODE USAR addi com um valor negativo para decremetar 
			beq $t0, $zero, else		# if(!i)
	    			move $t0, $t2           # i = jogar(tabuleiro, 2)
	    			jal exibirtabuleiro     # exibirtabuleiro(tabuleiro)
	   			sub $t3, $t3, 1         # j--
			j for # Retornando ao início do loop
		end:
		#Resultados 
			beq $t2, 1, venceu1 # if(i == 1)   printf("Jogador 1 Venceu!!!")
			beq $t2, 2, venceu2 # else if(i == 2){ printf("Jogador 2 Venceu!!!");
			la $a0, empate	#    else  printf("Empate");
