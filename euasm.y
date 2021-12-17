%{
#include <stdio.h>
#include <stdlib.h>

typedef enum { R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 } reg_id;
typedef double num_t; /* レジスタの値は倍精度浮動小数点数 */

/*** 仮想マシンのコード生成関数 ***/
void vm_PRINT(reg_id Rx);
void vm_NEG(reg_id Rx);
void vm_ADD(reg_id Rx, reg_id Ry);
void vm_SET(reg_id Rx, num_t n);
%}

%union { reg_id reg; num_t val; }

%token <reg> REGISTER
%token <val> NUMBER
%token       PRINT NEG ADD SET

%start script

%%
script: line;
script: script '\n' line;

line: /* empty */;
line: PRINT REGISTER            { vm_PRINT($2); };
line: NEG REGISTER              { vm_NEG($2); };
line: ADD REGISTER ',' REGISTER { vm_ADD($2, $4); };
line: SET REGISTER ',' NUMBER   { vm_SET($2, $4); };
%%

#include "lex.yy.c"

int yyerror(const char *s) { printf("%s\n", s); exit(1); }

int main() { return yyparse(); }

/*** 各機械語のオペコード ***/
#define op_PRINT 10
#define op_NEG   11
#define op_ADD   20
#define op_SET   30

void vm_PRINT(reg_id Rx)
{
        putchar(op_PRINT); /* PRINT のオペコード出力 */
        putchar(Rx);       /* レジスタ番号を出力 */
}

void vm_NEG(reg_id Rx)
{
        putchar(op_NEG); /* NEG のオペコード出力 */
        putchar(Rx);     /* x のレジスタ番号を出力 */
}

void vm_ADD(reg_id Rx, reg_id Ry)
{
        putchar(op_ADD); /* ADD のオペコード出力 */
        putchar(Rx);     /* Rx のレジスタ番号を出力 */
        putchar(Ry);     /* Ry のレジスタ番号を出力 */
}

void vm_SET(reg_id Rx, num_t n)
{
        putchar(op_SET);                  /* SET のオペコードを出力 */
        putchar(Rx);                      /* レジスタ番号を出力 */
        fwrite(&n, sizeof(n), 1, stdout); /* 数値の内部形式出力 */
}
