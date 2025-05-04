%{
#include <stdio.h>
#include <stdlib.h>

// Token-Definitionen aus dem Flex-Scanner
extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

// Hier definieren wir einen Union-Typ für den Wert von Tokens


%}
%union {
    int num;
    char str[101];
}

%type <str> program declarations statement_list statement expression declaration
%token <str> STRING
%token <num> NUMBER
%token DECLARE PREDICATE FUNCTION VARIABLE EXIST ALL LBRACK RBRACK LPAREN RPAREN AND ARROW COMMA SEMICOLON COLON OR NEGATION

%%

// Der Startpunkt der Grammatik
program:
    declarations statement_list
    {
        fprintf(stderr, "Program parsed: declarations and statement list.\n");
    }
    ;

declarations:
    declaration
    {
        fprintf(stderr, "Parsed a declaration:");
    }
    | declarations declaration
    {
        fprintf(stderr, "Parsed multiple declarations.");
    }
    ;

declaration:
    DECLARE PREDICATE STRING COLON NUMBER
    {
        fprintf(stderr, "Parsed a predicate declaration: -%s- arity: %d\n", $3, $5);
    }
    | DECLARE FUNCTION STRING COLON NUMBER
    {
        fprintf(stderr, "Parsed a function declaration: -%s- arity: %d\n", $3, $5);
    }
    | DECLARE VARIABLE STRING COLON STRING
    {
        fprintf(stderr, "Parsed a variable declaration: -%s- type: %s\n", $3, $5);
    }
    ;

statement_list:
    statement
    {
        fprintf(stderr, "Parsed a single statement: %s\n", $1);
    }
    | statement_list statement
    {
        fprintf(stderr, "Parsed multiple statements.\n");
    }
    ;

statement:
    expression SEMICOLON
    {
        fprintf(stderr, "Parsed a statement with expression: %s\n", $1);
    }
    ;

expression:
    predicate
    | LPAREN expression RPAREN
    | expression AND expression
    {
        fprintf(stderr, "Parsed an AND expression\n");
    }
    | expression OR expression
    {
        fprintf(stderr, "Parsed an OR expression\n");
    }
    | expression ARROW expression
    {
        fprintf(stderr, "Parsed an IMPLICATION expression\n");
    }
    | NEGATION expression
    {
        fprintf(stderr, "Parsed a NEGATION expression\n");
    }
    | EXIST LBRACK STRING RBRACK expression
    {
        fprintf(stderr, "Parsed an EXIST expression: %s\n", $3);
    }
    | ALL LBRACK STRING RBRACK expression
    {
        fprintf(stderr, "Parsed an ALL expression: %s\n", $3);
    }
    ;


predicate:
    STRING LPAREN predicateinput RPAREN
    {
        fprintf(stderr, "Parsed a predicate with name -%s-\n", $1);
    }
    ;






predicateinput:
    STRING
    {
        fprintf(stderr, "Parsed an input: -%s-\n", $1);
    }
    | predicateinput COMMA STRING
    {
        fprintf(stderr, "Parsed multiple inputs, added: -%s-\n", $3);
    }
    ;

%%

// Fehlerbehandlung
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    ++argv, --argc;  /* skip over program name */

    if (argc > 0) {
        yyin = fopen(argv[0], "r");
        if (!yyin) {
            perror("Fehler beim Öffnen der Datei");
            return 1;
        }
    } else {
        yyin = stdin;
    }

    int result = yyparse();
    fprintf(stderr, "%d\n", result);

    if (yyin != stdin) fclose(yyin);  // Close file if not stdin

    return 0;

}
