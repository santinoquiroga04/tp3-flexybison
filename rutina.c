#include <stdio.h>
#include <string.h>
#include "rutina.h"

int symbol_count = 0;
Variable symbol_table[MAX_SYMBOLS]; 

int lookup_variable(char *name) {
    printf("Buscando variable: %s\n", name);
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            printf("Variable encontrada: %s\n", name);
            return 1; // La variable existe
        }
    }
    printf("Variable no encontrada: %s\n", name);
    return 0; // No encontrada
}

void add_variable(char *name, int value) {
    printf("Aniadiendo variable '%s' con valor: %d\n", name, value);
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].value = value;
    symbol_count++;
}

void print_error(const char *error, int line) {
    printf("Error en la linea %d: %s\n", line, error);
}
