#ifndef RUTINA_H
#define RUTINA_H

#define MAX_SYMBOLS 100

typedef struct {
    char *name;
    int value;
} Variable;

extern int symbol_count;
extern Variable symbol_table[MAX_SYMBOLS];

void add_variable(char *name, int value);
int lookup_variable(char *name);
void print_error(const char *error, int line);

#endif // RUTINA_H
