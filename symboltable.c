/*
 * symbol_table.c (vereinfachte Version)
 *
 * Symboltabelle für Prädikate, Funktionen und Variablen
 * Implementierung mit einfachem Array
 */

#include "symbol_table.h"
#include <string.h>
#include <stdlib.h>

// Initialisiere Tabelle
void symtab_init(SymbolTable *tab) {
    tab->count = 0;
}

// Eintrag hinzufügen (vereint Prädikat, Funktion, Variable)
int symtab_add_entry(SymbolTable *tab, const char *name, SymbolType type, const void *info) {
    for (int i = 0; i < tab->count; ++i) {
        if (strcmp(tab->symbols[i].name, name) == 0 && tab->symbols[i].type == type)
            return 0; // Bereits vorhanden
    }
    if (tab->count >= MAX_SYMBOLS) return -1;

    tab->symbols[tab->count].name = strdup(name);
    tab->symbols[tab->count].type = type;

    switch (type) {
        case SYM_PREDICATE:
        case SYM_FUNCTION:
            tab->symbols[tab->count].info.arity = *(int *)info;
            break;
        case SYM_VARIABLE:
            tab->symbols[tab->count].info.var_type = strdup((const char *)info);
            break;
    }

    tab->count++;
    return 1;
}

// Suche Symbol nach Name und Typ (optional)
Symbol *symtab_lookup(SymbolTable *tab, const char *name) {
    for (int i = 0; i < tab->count; ++i) {
        if (strcmp(tab->symbols[i].name, name) == 0)
            return &tab->symbols[i];
    }
    return NULL;
}

Symbol *symtab_get_entry(SymbolTable *tab, const char *name, SymbolType type) {
    for (int i = 0; i < tab->count; ++i) {
        if (strcmp(tab->symbols[i].name, name) == 0 && tab->symbols[i].type == type)
            return &tab->symbols[i];
    }
    return NULL;
}

// Freigeben
void symtab_destroy(SymbolTable *tab) {
    for (int i = 0; i < tab->count; ++i) {
        free(tab->symbols[i].name);
        if (tab->symbols[i].type == SYM_VARIABLE)
            free(tab->symbols[i].info.var_type);
    }
}

// Beispiel-Nutzung
#ifdef DEMO
int main() {
    SymbolTable tab;
    symtab_init(&tab);

    int ar2 = 2;
    int ar1 = 1;
    int ar0 = 0;

    symtab_add_entry(&tab, "Kauft", SYM_PREDICATE, &ar2);
    symtab_add_entry(&tab, "Kuerbis", SYM_PREDICATE, &ar1);
    symtab_add_entry(&tab, "Kind", SYM_PREDICATE, &ar1);
    symtab_add_entry(&tab, "Isst", SYM_PREDICATE, &ar2);
    symtab_add_entry(&tab, "Schnitzt", SYM_PREDICATE, &ar2);

    symtab_add_entry(&tab, "Tim", SYM_FUNCTION, &ar0);

    symtab_add_entry(&tab, "x", SYM_VARIABLE, "int");
    symtab_add_entry(&tab, "y", SYM_VARIABLE, "int");

    Symbol *s = symtab_lookup(&tab, "Isst");
    if (s) printf("Gefunden: %s (Arity=%d)\n", s->name, s->info.arity);

    symtab_destroy(&tab);
    return 0;
}
#endif
