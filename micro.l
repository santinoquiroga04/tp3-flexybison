%{
	#include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
	#include "y.tab.h"
%}
DIGITO [0-9]

LETRA [a-zA-Z]

IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*

constEntera {DIGITO}({DIGITO})*
%option yylineno
%%
"inicio" {return INICIO;}
"fin" {return FIN;}
"escribir" {return ESCRIBIR;}
"leer" {return LEER;}
":=" {return ASIGNACION;}
{constEntera} {yylval.num=atoi(yytext);return CONSTANTE;}
{IDENTIFICADOR} {yylval.cadena = strdup(yytext); return ID;}
";" {return PYCOMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {yylval.cadena = strdup(yytext); return SUMA;}
"-" {yylval.cadena = strdup(yytext); return RESTA;}
"," {return COMA;}
[ \t\n]+ { /* No hacer nada */ }
. {
    if(yytext != ' '){
    fprintf(stderr, "Error lexico: Caracter no reconocido '%s' en la linea %d\n", yytext, yylineno);
    exit(1); // Finaliza el programa si hay un error léxico
    }
}
%%

int yywrap() {
    return 1;
}
