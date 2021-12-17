/*****************************************************************************
 *  C 言語インターフェイス宣言部
 *****************************************************************************/

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum { R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 } reg_id;

/*** アセンブリコード生成関数のプロトタイプ宣言 ***/
void   asm_PRINT(reg_id Rx);
reg_id asm_SET(char *n);
reg_id asm_ADD(reg_id Rx, reg_id Ry);
reg_id asm_MUL(reg_id Rx, reg_id Ry);

/*** [追加ニーモニック] 例えば，このように追加する ***/
reg_id asm_NEG(reg_id Rx);

%}

/*****************************************************************************
 *  非終端記号(E,T,F)とその型および終端記号(NUM,'+','*','(',')'),
 *  開始記号(S)の定義
 *****************************************************************************/

%union { char *str; reg_id reg; } /* 構文解析の戻り値として文字列型とレジスタID型を扱う */
%type  <reg> E T F
%token <str> NUM
%token       '+' '*' '(' ')'
%start       S

/*****************************************************************************
 *  生成規則の定義
 *****************************************************************************/

%%

S: E               { asm_PRINT($1); };

E: T               { $$ = $1; };
E: E '+' T         { $$ = asm_ADD($1, $3); }; /* '+' は左結合 */

T: F               { $$ = $1; };
T: T '*' F         { $$ = asm_MUL($1, $3); }; /* '*' は左結合 */

F: NUM             { $$ = asm_SET($1); };
F: '(' E ')'       { $$ = $2; };

%%

/*****************************************************************************
 *  メインルーチンおよびサブルーチンの実装部分
 *****************************************************************************/

#include "lex.yy.c"

int yyerror(const char *s) { printf("%s\n", s); exit(1); }

int main() { return yyparse(); }

/*****************************************************************************/

reg_id reg_stack[] = { R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 }; /* レジスタスタック */

int reg_sp = 0; /* レジスタスタックポインタ */

/*** レジスタスタックから利用可能なレジスタを確保する関数 ***/
reg_id reg_alloc(void)
{
        return reg_stack[reg_sp++];
}

/*** レジスタスタックに使い終わったレジスタを戻す関数 ***/
void reg_free(reg_id r)
{
        reg_stack[--reg_sp] = r;
}

/*** PRINT ニーモニックを出力する ***/
void asm_PRINT(reg_id Rx)
{
        printf("PRINT R%d\n", Rx);
        reg_free(Rx);
}

/*** SET ニーモニックを出力する ***/
reg_id asm_SET(char *n)
{
        reg_id Rx = reg_alloc();
        printf("SET R%d,%s\n", Rx, n);
        free(n); /* 字句解析で strdup した領域の解放 */
        return Rx;
}

/*** ADD ニーモニックを出力する ***/
reg_id asm_ADD(reg_id Rx, reg_id Ry)
{
        printf("ADD R%d,R%d\n", Rx, Ry);
        reg_free(Ry);
        return Rx;
}

/*** MUL ニーモニックを出力する ***/
reg_id asm_MUL(reg_id Rx, reg_id Ry)
{
        printf("MUL R%d,R%d\n", Rx, Ry);
        reg_free(Ry);
        return Rx;
}

/*** [追加ニーモニック] NEG ニーモニックを出力する ***/
reg_id asm_NEG(reg_id Rx)
{
        printf("NEG R%d\n", Rx);
        return Rx;
}

