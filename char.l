%{

#include <math.h>
#define INTEGER      1  
#define OPERATOR     2  
#define PARENTHESES  3  
#define FUNCTION     4
#define REAL         5
#define CHAR         6

%}

integer     "0"|[1-9][0-9]*
operator    "+"|"-"|"*"|"/"
parentheses "("|")"
function    "sin"|"cos"|"tan"|"log"|"sqrt"
real        [0-9]+\.[0-9]+
char        [_a-zA-Z]*

%%

{integer}     { return INTEGER; }      
{operator}    { return OPERATOR; }     
{parentheses} { return PARENTHESES; }  
{function}    { return FUNCTION; }
{real}        { return REAL; }
{char}        { return CHAR; }
"\n"          { return 0; }            
[" ""\t"]+                             
.           { printf("Error: '%c'\n", yytext[0]); exit(1); }

%%

int main()
{
        int tag;          
        int line_num = 0; 

        while (tag = yylex()) {
                printf("[%2d] ", ++line_num);
                printf("tag = %2d, ", tag);
                printf("text = %s\n", yytext);
        }
        return 0;
}
