.data
	tabuleiro:  .word   0, 0, 0, 0, 0, 0, 0, 0, 0      # Array de 3x3 para representar o tabuleiro
	msg: .asciiz "Digite A Posicao Na Qual Vc Quer Jogar"
	invalido: .asciiz "Posicao Invalida"
	coluna: .asciiz "Coluna\n"
	venceu1: .asciiz "Jogador 1 Venceu!!!\n"
	venceu2: .asciiz "Jogador 2 Venceu!!!\n"
	empate: .asciiz "Empate\n"
.text
.global main

#funcao
jogar:
testeLinha: 
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
	????
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
	????
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
	????
testeDiag2:
exibirtabuleiro:

#main
	li $t0, 0 		#p1;
	li $t1, 0 		#p2; 
	li $t2, 0 		#i; 
	li $t3, 0 		#j;
	jal jogar		#chama a função 
	
	jogar: 
		#printf("Digite A Posicao Na Qual Vc Quer Jogar ");
		#scanf("%d %d", &p1, &p2);
			la $a0, msg     #atribuição da string 
			li $v0, 4       #impressão da string 
			syscall         #Executa
			
			li $v0, 5 	#ler o valor interiro do comando anterior
			syscall		#executa
			move $t0, $v0 	#move o valor de $v0 para $t0  ou seja p1 = valor;
			
			li $v0, 5 	#ler o segundo valor interiro do comando anterior
			syscall		#executa
			move $t1, $v0 	#move o valor de $v0 para $t1 ou seja p2 = valor;
			
		loop:
  		  	beq $t0, $zero, endLoop  # Verifica se $t0 é igual a zero   for(i = 0;i < 3;i++){
    			beq $t1, $zero, endLoop  # Verifica se $t1 é igual a zero   for(j = 0; j < 3; j++){
    			li $v0, 5                # Ler um inteiro
			#tabuleiro[i][j] = 0; falta esta parte
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
			
		

 
		
