%{
#include "micro.tab.h"
%}

%%

[ \t\n]+         ; // Ignorar espacios, tabulaciones y saltos de línea
"int"            { return INT; }
"float"          { return FLOAT; }
"print"          { return PRINT; }
"="              { return ASSIGN; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MULTIPLY; }
"/"              { return DIVIDE; }
"("              { return LPAREN; }
")"              { return RPAREN; }
";"              { return SEMICOLON; }
[0-9]+           { yylval.intval = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }

.                { printf("Caracter no reconocido: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
