%{
#include <stdlib.h>
#define to_reg(str) ( str[1] - '0' ) /* レジスタ番号への変換 */
#define to_num(str) ( atof(str) )    /* 倍精度浮動小数点数への変換 */
%}

register        R[0-9]
number          "0"|[1-9][0-9]*|[0-9]+"."[0-9]*
operator        [",""\n"]

print           PRINT
neg             NEG
add             ADD
set             SET

%%
{register}      { yylval.reg = to_reg(yytext); return REGISTER; }
{number}        { yylval.val = to_num(yytext); return NUMBER; }
{operator}      { return yytext[0]; }

{print}         { return PRINT; }
{neg}           { return NEG; }
{add}           { return ADD; }
{set}           { return SET; }

[" ""\t"]+      /* skip */
.               { printf("error: '%c'\n", yytext[0]); exit(1); }
%%
