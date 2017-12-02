%{
#include <stdio.h>
#include <stdlib.h>
#include "stack_interface.h"
extern int   linenum;           /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char  buf[8192];         /* declared in lex.l */

extern int yylex(void);
int yyerror(char *);

table_stack_ptr stack_table = NULL;
vec_string_ptr id_list = NULL;
union attr empty_attr;
%}


%union {
    float 	float_;
    int 	integer_;
	char*   string_;
}
						
/* symbols */
%token KWBEGIN END ASSIGN PRINT READ DEF
%token WHILE DO FOR RETURN IF THEN ELSE
%token ARRAY OF TO VAR TYPE		   
%token INT OCTAL
%token FLOAT
%token SCI IDENT STRING
%token LE GE NE NOT AND OR MOD TRUE FALSE
						
%left PARENTHESES
%left NEG
%left '*' '/'
%left '+' '-'
%left '>' '<'
%left NOT
%left AND
%left OR

%type <string_> WHILE DO FOR RETURN IF THEN ELSE ARRAY OF TO VAR TYPE IDENT STRING SCI
%type <integer_> INT OCTAL
%type <float_> FLOAT

%type <string_> identifier programname 
%type <integer_> int_constant
%type <string_> identifier_list identifier_list_ext
						
%%

program							: programname ';' programbody END programname
								{
									entry_ptr entry = new_entry($1, K_PROGRAM, /* level */ 0, "void", empty_attr);
									table_ptr table = table_stack_top(stack_table);
									table_push(table, entry);
                				}

programname						: identifier {
								    $$ = $1;
								};

identifier						: IDENT {
           						    $$ = $1;
           						};

programbody						: varible_list function_list compound
                                ;


/* basic blocks */
identifier_list					: /* empty */
                                | identifier_list_ext
				                ;

identifier_list_ext				: identifier_list_ext ',' identifier {
				                	vec_string_push_back(id_list, $3);
                                }
                                | identifier {
                                    vec_string_push_back(id_list, $1);
                                }
                                ;

literal_constant				: number
                                | STRING
                                | bool_constant
                                ;

bool_constant					: TRUE
                                | FALSE
                                ;

int_constant					: INT
                                ;

number							: INT
                                | SCI
                                | FLOAT
                                | OCTAL
                                ;


/* varible list */
varible_list					: /* empty */
                                | varible_list_ext {
								    table_print(table_stack_top(stack_table));
								}
                                ;

varible_list_ext				: varible_list_ext varible_declare
                                | varible_declare
                                ;

varible_declare					: varible_declare_pod
                                | varible_declare_array
                                | varible_declare_constant
                                ;

varible_declare_pod             : VAR identifier_list ':' TYPE ';'
                                {
                                    table_ptr table = table_stack_top(stack_table);
                                    int i;
                                    for(i = 0; i < vec_string_size(id_list); i++)
                                    {
                                        entry_ptr p = new_entry(vec_string_at(id_list, i), K_VARIABLE, table_get_level(table), $4, empty_attr);
                                        table_push(table, p);
                                    }
                                    vec_string_clear(id_list);
                                };

varible_declare_array           : VAR identifier_list ':' ARRAY int_constant TO int_constant OF array_types ';'
                                ;

varible_declare_constant        : VAR identifier_list ':' literal_constant ';'
                                ;

array_types						: ARRAY int_constant TO int_constant OF array_types
                                | TYPE
                                ;


/* function */
function_list					: /* empty */
                                | function_list_ext
                                ;

function_list_ext				: function function_list_ext
                                | function
                                ;

function						: function_name '(' arguments ')' ':' TYPE ';' function_body END identifier
                                | function_name '(' arguments ')' ';' function_body END identifier
                                ;

function_body					: compound
                                ;

function_name					: identifier
                                ;

arguments						: /* empty */
                                | arguments_ext
                                ;

arguments_ext					: identifier_list ':' TYPE ';' arguments_ext
                                | identifier_list ':' TYPE
                                ;

statements						: statements_ext
                                | /* empty */
                                ;

statements_ext   				: statements_ext statement
                                | statement
                                ;

statement						: compound
                                | simple
                                | expressions
                                | conditional
                                | while
                                | for
                                | return
                                | function_invocation ';'
                                ;


/* compound statements */
compound						: KWBEGIN varible_list statements END
                                ;

simple							: varible_reference ASSIGN expressions ';'
                                | PRINT varible_reference ';'
                                | PRINT expressions ';'
                                | READ varible_reference ';'
                                ;

array_reference					: identifier array_reference_list
                                ;

array_reference_list			: /* empty */
                                | '[' integer_expression ']' array_reference_list
                                ;

varible_reference				: array_reference
                                ;

expressions						: expression
                                | integer_expression
                                | bool_expression
                                ;

expression						: '-' expression %prec NEG
                                | expression '+' expression
                                | expression '-' expression
                                | expression '*' expression
                                | expression '/' expression
                                | expression MOD expression %prec '*'
                                | '(' expression ')' %prec PARENTHESES
                                | number
                                | identifier
                                | function_invocation
                                | STRING
                                ;

integer_expression				: int_constant
                                | identifier
                                ;

bool_expression					: expression '>' expression
                                | expression '<' expression
                                | expression LE  expression %prec '>'
                                | expression GE  expression %prec '>'
                                | expression '=' expression
                                | expression NE  expression %prec '>'
                                | expression AND expression %prec AND
                                | expression OR  expression %prec OR
                                | NOT expression %prec NOT
                                | bool_constant
                                | identifier
                                | function_invocation
                                ;

function_invocation				: identifier '(' expression_list ')'
                                ;

expression_list					: /* empty */
                                | expression
                                | expression_list ',' expression
                                ;

conditional						: IF bool_expression THEN conditional_body END IF
                                ;

conditional_body				: statements
                                | statements ELSE statements

while							: WHILE bool_expression DO statements END DO
                                ;

for								: FOR identifier ASSIGN int_constant TO int_constant DO statements END DO
                                ;

return							: RETURN expressions ';'
                                ;

%%

int yyerror(char *msg)
{
	fprintf(stderr, "\n|--------------------------------------------------------------------------\n");
	fprintf(stderr, "| Error found in Line #%d: %s\n", linenum, buf);
	fprintf(stderr, "|\n");
	fprintf(stderr, "| Unmatched token: %s\n", yytext);
	fprintf(stderr, "|--------------------------------------------------------------------------\n");
	exit(-1);
}

int  main( int argc, char **argv )
{
	if( argc != 2 )
	{
		fprintf(stdout, "Usage: ./parser [filename]\n");
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );

	if( fp == NULL )
	{
		fprintf(stdout, "Open file error\n");
		exit(-1);
	}

	yyin = fp;

	empty_attr.val = 0;
	stack_table = new_table_stack();
	table_ptr t = new_table(0);
	table_stack_push(stack_table, t);
	id_list = new_vec_string();

	yyparse();

	delete_vec_string(id_list);
	table_stack_pop(stack_table);
	delete_table_stack(stack_table);
	
	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fclose(fp);
	exit(0);
}
