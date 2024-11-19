%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rutina.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
int lookup_variable(char *name);
void add_variable(char *name, int value);
void print_error(const char *error, int line);

%}

%union {
    int intval;
    char *sval;
}

%token <sval> IDENTIFIER
%token <intval> NUMBER
%token INT FLOAT PRINT
%token ASSIGN PLUS MINUS MULTIPLY DIVIDE
%token LPAREN RPAREN SEMICOLON

%type <intval> expression term factor

%%

program:
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
    type IDENTIFIER ASSIGN expression SEMICOLON {
        if (lookup_variable($2)) {
            print_error("Variable ya declarada", yylineno);
        } else {
            add_variable($2, $4);
        }
    }
    | PRINT expression SEMICOLON {
        printf("Resultado: %d\n", $2);
    }
    ;

type:
    INT
    | FLOAT
    ;

expression:
    expression PLUS term {
        $$ = $1 + $3;
    }
    | expression MINUS term {
        $$ = $1 - $3;
    }
    | term
    ;

term:
    term MULTIPLY factor {
        $$ = $1 * $3;
    }
    | term DIVIDE factor {
        if ($3 == 0) {
            print_error("Division por cero", yylineno);
        } else {
            $$ = $1 / $3;
        }
    }
    | factor
    ;

factor:
    NUMBER {
        $$ = $1;
    }
    | IDENTIFIER {
        if (!lookup_variable($1)) {
            print_error("Variable no declarada", yylineno);
        } else {
            // Busca y asigna el valor de la variable
            for (int i = 0; i < symbol_count; i++) {
                if (strcmp(symbol_table[i].name, $1) == 0) {
                    $$ = symbol_table[i].value;
                    break;
                }
            }
        }
    }
    | LPAREN expression RPAREN {
        $$ = $2;
    }
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
