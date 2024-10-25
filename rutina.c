#include <stdio.h>
#include <string.h>

typedef struct {
    char *name;
    int value;
} Variable;

Variable symbol_table[100];
int symbol_count = 0;

int lookup_variable(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return 1; // La variable existe
        }
    }
    return 0; // No encontrada
}

void add_variable(char *name) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_count++;
}

void print_error(const char *error, int line) {
    printf("Error en la línea %d: %s\n", line, error);
}
