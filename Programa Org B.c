#include<stdio.h>
//p1 = linha, p2 = coluna
int jogar(int tabuleiro [3][3], int s){
    int p1, p2, i, j;
    do{
        printf("Digite A Posicao Na Qual Vc Quer Jogar ");
        scanf("%d %d", &p1, &p2);
        if (tabuleiro[--p1][--p2] != 0){
            printf("Posicao Invalida");
            printf("%d", tabuleiro[p1][p2]);
            i = 1;
        }
        else{
            i = 0;
        }
    }while(i);
    tabuleiro[p1][p2] = s;
    if(testeLinha(tabuleiro, s,p1,p2)){
        return s;
    }
    if(testeColuna(tabuleiro, s, p1, p2)){
        printf("Coluna");
        return s;
    }
    if(p1 == 1 && p2 == 1){
      if(testeDiag1(tabuleiro, s, p1, p2) || testeDiag2(tabuleiro, s, p1, p2)){
        printf("Diag1 ee Diag2");
        return s;
      }
    }
    if(p1 == p2){
        if(testeDiag1(tabuleiro, s, p1, p2)){
            printf("Diag1");
            return s;
        }
    }
    if((p1 == 2 && p2 == 0) || (p2 == 2 && p1 ==0)){
        if(testeDiag2(tabuleiro, s, p1, p2)){
            printf("Diag2");
            return s;
        }
    }
    return 0;
}

int testeLinha(int tabuleiro [3][3], int s, int p1, int p2){
    int i;
    i = p2;
    p2 = p1;
    if (--p1 == -1){
        p1 = 2;
    }
    if (++p2 == 3){
        p2 = 0;
    }
    if(tabuleiro[p1][i] == tabuleiro[p2][i] && tabuleiro[p2][i] == s){
        return s;
    }
    return 0;
}

int testeColuna(int tabuleiro [3][3], int s, int p1, int p2){
    int i;
    i = p1;
    p1 = p2;
    if (--p1 == -1){
        p1 = 2;
    }
    if (++p2 == 3){
        p2 = 0;
    }
    if(tabuleiro[i][p1] == tabuleiro[i][p2] && tabuleiro[i][p2] == s){
        return s;
    }
    return 0;
}

int testeDiag1(int tabuleiro [3][3], int s, int p1, int p2){
    if (--p1 == -1){
        p1 = 2;
    }
    if (++p2 == 3){
        p2 = 0;
    }
    if(tabuleiro[p2][p2] == tabuleiro[p1][p1] && tabuleiro[p1][p1] == s){
        return s;
    }
    return 0;
}

int testeDiag2(int tabuleiro [3][3], int s, int p1, int p2){
    int i, j;
    i = p1;
    j = p2;
    if(p1+1 == 3){
        i = -1;
        j = 3;
    }
    if(p2+1 == 3){
        p1 = 3;
        p2 = -1;
    }
    if(tabuleiro[i+1][j-1] == tabuleiro[p1-1][p2+1] && tabuleiro[p1-1][p2+1] == s){
        return s;
    }
    return 0;

}
void exibirtabuleiro (int tabuleiro[3][3]){
    int i, j;
    for(i = 0;i < 3;i++){
        printf("\n");
        printf(" ");
        for(j = 0; j < 3; j++){
            switch(tabuleiro[i][j]){
            case 1:
                printf("X");
                break;
            case 2:
                printf("O");
                break;
            default:
                printf(" ");
            }
            if (j < 2){
                printf(" | ");
            }
        }
    }
    printf("\n");

}


main (){
    int tabuleiro[3][3];
    int i, j;
    int input;
    for(i = 0;i < 3;i++){
        for(j = 0; j < 3; j++){
            tabuleiro[i][j] = 0;
        }
    }
    exibirtabuleiro(tabuleiro);
    for(i = 0,j = 9;!i && j;){
        i = jogar(tabuleiro, 1);
        exibirtabuleiro(tabuleiro);
        j--;
        if(!i){
            i = jogar(tabuleiro, 2);
            exibirtabuleiro(tabuleiro);
            j--;
        }
    }
    if(i == 1){
        printf("Jogador 1 Venceu!!!");
    }
    else if(i == 2){
        printf("Jogador 2 Venceu!!!");
    }
    else{
        printf("Empate");
    }
}
