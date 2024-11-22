%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rutina.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;
extern int yyleng;
extern char *yytext;

void yyerror(const char *s);
int lookup_variable(char *name);
void add_variable(char *name, int value);
void print_error(const char *error, int line);

%}
%union{
   char* cadena;
   int num;
} 
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN LEER ESCRIBIR COMA
%token <cadena> ID
%token <num> CONSTANTE
%type <num> lista_expresiones
%type <cadena> leer escribir lista_ids
%type <num> asignacion expresion
%%
programa:INICIO sentencias FIN
;
sentencias: sentencias sentencia 
|sentencia
;
sentencia: asignacion 
| leer
| escribir
;
asignacion:  ID ASIGNACION expresion PYCOMA  {
    if (lookup_variable($1)) {
            print_error("Variable ya declarada", yylineno);
        } else {
            add_variable($1, $3);
        }
    }
;
leer: LEER PARENIZQUIERDO lista_ids PARENDERECHO PYCOMA 
;
escribir: ESCRIBIR PARENIZQUIERDO lista_expresiones PARENDERECHO PYCOMA
;
expresion: primaria 
|expresion operadorAditivo primaria 
; 
primaria: ID
|CONSTANTE {printf("valores %d %d",atoi(yytext),$1); }
|PARENIZQUIERDO expresion PARENDERECHO
;
operadorAditivo: SUMA 
| RESTA
;
lista_ids: lista_ids COMA ID
| ID
;
lista_expresiones: lista_expresiones COMA expresion
| expresion
;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    printf("Iniciando el programa...\n");
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "No se puede abrir el archivo: %s\n", argv[1]);
            return 1;
        }
        yyin = file;
        printf("Archivo de entrada cargado: %s\n", argv[1]);
    } else {
        printf("Leyendo de la entrada estándar (stdin)...\n");
    }
    yyparse();
    printf("Parseo finalizado.\n");
    return 0;
}