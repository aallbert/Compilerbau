// symbol_table.h

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>

#define MAX_SYMBOLS 100

// Symboltypen
typedef enum {
    SYM_PREDICATE,
    SYM_FUNCTION,
    SYM_VARIABLE
} SymbolType;

// Symbolstruktur
typedef struct {
    char *name;
    SymbolType type;
    union {
        int arity;           // für Prädikate und Funktionen
        char *var_type;      // für Variablen
    } info;
} Symbol;

// Symboltabelle als Array
typedef struct {
    Symbol symbols[MAX_SYMBOLS];
    int count;
} SymbolTable;

// Funktionen
void symtab_init(SymbolTable *tab);
int symtab_add_entry(SymbolTable *tab, const char *name, SymbolType type, const void *info);
Symbol *symtab_lookup(SymbolTable *tab, const char *name);
Symbol *symtab_get_entry(SymbolTable *tab, const char *name, SymbolType type);
void symtab_destroy(SymbolTable *tab);

#endif // SYMBOL_TABLE_H
