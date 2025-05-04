%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.h" // Header-Datei von Bison
%}

%option noyywrap

CHAR [a-zA-Z]

%%

"/*"[^*]*"\*/"           { fprintf(stderr, "COMMENT: %s\n", yytext); }
"DECLARE"                { /* fprintf(stderr, "DECLARE\n"); */ return DECLARE; }
"PREDICATE"              { /* fprintf(stderr, "PREDICATE\n"); */ return PREDICATE; }
"FUNCTION"               { /* fprintf(stderr, "FUNCTION\n"); */ return FUNCTION; }
"VARIABLE"               { /* fprintf(stderr, "VARIABLE\n"); */ return VARIABLE; }
"EXIST"                  { /* fprintf(stderr, "EXIST\n"); */ return EXIST; }
"ALL"                    { /* fprintf(stderr, "ALL\n"); */ return ALL; }
"["                      { /* fprintf(stderr, "LBRACK\n"); */ return LBRACK; }
"]"                      { /* fprintf(stderr, "RBRACK\n"); */ return RBRACK; }
"->"                     { /* fprintf(stderr, "ARROW\n"); */ return ARROW; }
"("                      { /* fprintf(stderr, "LPAREN\n"); */ return LPAREN; }
")"                      { /* fprintf(stderr, "RPAREN\n"); */ return RPAREN; }
"&"                      { /* fprintf(stderr, "AND\n"); */ return AND; }
","                      { /* fprintf(stderr, "COMMA\n"); */ return COMMA; }
";"                      { /* fprintf(stderr, "SEMICOLON\n"); */ return SEMICOLON; }
":"                      { /* fprintf(stderr, "COLON\n"); */ return COLON; }
"|"                      { /* fprintf(stderr, "OR\n"); */ return OR; }
"~"                      { /* fprintf(stderr, "NEGATION\n"); */ return NEGATION; }
{CHAR}+                  { /* fprintf(stderr, "STRING\n"); */ strncpy(yylval.str, yytext, 100); return STRING; }
[0-9]+                   { /* fprintf(stderr, "INT\n"); */ yylval.num = atoi(yytext); return NUMBER; }
"."                      { return EOF; }

%%


/* int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Fehler beim Öffnen der Datei");
            return 1;
        }
    }

    yylex(); // Startet das Scannen
    fclose(yyin); // Schließt die Datei
    return 0;
} */