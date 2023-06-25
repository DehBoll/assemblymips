.data
	tabuleiro:  .word   0, 0, 0, 0, 0, 0, 0, 0, 0      # Array de 3x3 para representar o tabuleiro
	msg: .asciiz "Digite A Posicao Na Qual Vc Quer Jogar"
	invalido: .asciiz "Posicao Invalida"
	coluna:     .asciiz "Coluna\n"
	venceu1:    .asciiz "Jogador 1 Venceu!!!\n"
	venceu2:    .asciiz "Jogador 2 Venceu!!!\n"
	empate:     .asciiz "Empate\n"
.text
.global main

#funções 
jogar:
testeLinha:
testeColuna:
testeDiag1:
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
  		  	beq $t0, $zero, endLoop  # Verifica se $t0 é igual a zero 
    			beq $t1, $zero, endLoop  # Verifica se $t1 é igual a zero 
    			li $v0, 5                # Ler um inteiro
    			syscall
			
		 # função exibirtabuleiro
   			 la $a0, tabuleiro        # Carrega a matriz
   			 jal exibirtabuleiro      # exibirtabuleiro

		#atribuindo novos valores as variáveis:
			li $t2, 0 		#i; 
			li $t3, 9 		#j;
		loop:
		# for(i = 0,j = 9;!i && j;)
			bne $t2, $zero, end	    # Se !i == 0 sai do loop
			beqz $t3, end		    # Se  j == 0, sai do loop
			
		# função jogar para o Jogador 1 #(???) 
    			la $a0, tabuleiro           # atribui valor ao tabuleiro 
    			li $a1, 1                   # Jogador 1 
    			jal jogar                   # Chamada para a função jogar

 		# função exibirtabuleiro - Atualizado
   			 la $a0, tabuleiro		    # Carrega a matriz
   			 jal exibirtabuleiro        # exibirtabuleiro

		# Decrementa j
   			 sub $t3, $t3, 1           # j-- OU PODE USAR addi com um valor negativo para decremetar 

			beq $t0, $zero, else
	    			move $t0, $t2           # i = jogar(tabuleiro, 2)
	    			jal exibirtabuleiro     # exibirtabuleiro(tabuleiro)
	   			sub $t3, $t3, 1         # j--

		j loop  # Retornando ao início do loop
		#Resultados 
			beq $t2, 1, venceu1
			beq $t2, 2, venceu2
			la $a0, empate     
			
		

 
		
