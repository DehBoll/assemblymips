#include<stdio.h>
#//p1 = linha, p2 = coluna
#int jogar(int tabuleiro [3][3], int s){
#   int p1, p2, i, j;
#    do{
#        printf("Digite A Posicao Na Qual Vc Quer Jogar ");
#        scanf("%d %d", &p1, &p2);
#        if (tabuleiro[--p1][--p2] != 0){
#            printf("Posicao Invalida");
#            printf("%d", tabuleiro[p1][p2]);
#            i = 1;
#        }
#        else{
#            i = 0;
#        }
#    }while(i);

.data
    msg: .asciiz "Digite A Posicao Na Qual Vc Quer Jogar"
    invalido: .asciiz "Posicao Invalida"
.text
#.global main
	
	li $t0, 0 		#p1;
	li $t1, 0 		#p2; 
	li $t2, 0 		#i; 
	li $t3, 0 		#j;
	jal jogar		#chama a função 
	
	jogar: 
		loop:
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
			
			
			bne  		#if (tabuleiro[--p1][--p2] != 0){
			
			
			
		jr $ra		#realiza o salto da função 


 
		