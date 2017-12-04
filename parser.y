%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "stack_interface.h"
extern int   linenum;           /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char  buf[8192];         /* declared in lex.l */
extern int   Opt_D;
extern int   yylex(void);
int yyerror(char *);

table_stack_ptr stack_table = NULL;
table_ptr parameter_table = NULL;
union attr empty_attr;
array_object_ptr array_construct = NULL;
int for_error = 0;
%}

%code requires {
	#include "stack_interface.h"
}
						

%union {
    float 	float_;
    int 	integer_;
	char*   string_;
	array_object_ptr arr_ptr_;
	const_type_ptr   const_ptr_;
	vec_string_ptr   str_ptr_;
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

%type <string_> identifier programname bool_constant
%type <integer_> int_constant

%type <string_> arguments_ext
%type <str_ptr_> identifier_list identifier_list_ext
%type <string_> array_types
%type <string_> function
%type <string_> arguments
%type <string_> function_name
%type <const_ptr_> number
%type <const_ptr_> literal_constant

						
%%

program							: programname ';' programbody
								{
	                                entry_ptr entry = new_entry($1, K_PROGRAM, /* level */ 0, "void", empty_attr, "");
									table_ptr table = table_stack_top(stack_table);
									table_push(table, entry);
                				} END programname {
	                                table_print(table_stack_top(stack_table));
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
identifier_list					: /* empty */ {$$ = new_vec_string();}
                                | identifier_list_ext {$$ = $1;}
				                ;

identifier_list_ext				: identifier_list_ext ',' identifier {
				                	vec_string_push_back($1, $3);
                                    $$ = $1;
                                }
                                | identifier {
                                	$$ = new_vec_string();
                                    vec_string_push_back($$, $1);
                                }
                                ;

literal_constant				: number {
                                    $$ = $1;
                                }
                                | STRING {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "string");
                                    const_type_set_string(p, $1);
                                    $$ = p;
                                }
                                | bool_constant {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "boolean");
                                    const_type_set_bool(p, $1);
                                    $$ = p;
                                }
                                ;

bool_constant					: TRUE  { $$ = "true"; }
                                | FALSE { $$ = "false"; }
                                ;

int_constant					: INT { $$ = $1; }
                                ;

number							: INT {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "integer");
                                    const_type_set_int(p, $1);
                                    $$ = p;
                                }
                                | SCI {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "real");
                                    const_type_set_science(p, $1);
                                    $$ = p;
                                }
                                | FLOAT {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "real");
                                    const_type_set_real(p, $1);
                                    $$ = p;
                                }
                                | OCTAL {
                                    const_type_ptr p = new_const_type();
                                    const_type_set_type(p, "integer");
                                    const_type_set_int(p, $1);
                                    $$ = p;
                                }
                                ;


/* varible list */
varible_list					: /* empty */
                                | varible_list_ext {
//    							    table_print(table_stack_top(stack_table));
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
                                    for(i = 0; i < vec_string_size($2); i++)
                                    {
                                        entry_ptr p = new_entry(vec_string_at($2, i),
                                                                K_VARIABLE,
                                                                table_get_level(table),
                                                                $4,
  																empty_attr,
  																"");
                                        int err = table_push(table, p);
                                        if(err)
										{
										    report_error_redeclared_var(linenum, entry_get_name(p));
										    delete_entry(p);
										}
                                    }
                                    vec_string_clear($2);
                                    delete_vec_string($2);
                                };

varible_declare_array           : VAR identifier_list ':' ARRAY int_constant TO int_constant OF array_types ';' {
                                    if(! array_construct)
									{
									    array_construct = new_array_object($9, $7 - $5 + 1);
									}
                                    else
									{
									    array_object_ptr p = new_array_object("", $7 - $5 + 1);
                                        array_construct = array_object_append(p, array_construct);
									}
                                    table_ptr  table = table_stack_top(stack_table);
									char * att_data = array_object_show(array_construct);
                                    int i;
                                    for(i = 0; i < vec_string_size($2); i++)
                                    {
                                        entry_ptr p = new_entry(vec_string_at($2, i),
                                                                K_VARIABLE,
                                                                table_get_level(table),
                                                                att_data,
                                                                empty_attr,
																"");
                                        table_push(table, p);
                                    }
                                    free(att_data);
                                    delete_array_object(array_construct);
                                    array_construct = NULL;
                                    vec_string_clear($2);
                                    delete_vec_string($2);
                                }
                                ;

array_types						: ARRAY int_constant TO int_constant OF array_types {
                                    if(! array_construct)
									{
									    array_construct = new_array_object($6, $4 - $2 + 1);
									}
                                    else
									{
									    array_object_ptr p = new_array_object($6, $4 - $2 + 1);
                                        array_construct = array_object_append(p, array_construct);
									}
                                    free($6);
                                    $$ = array_object_show(array_construct);
                                }
                                | TYPE {
								    $$ = $1;
 								}
                                ;

varible_declare_constant        : VAR identifier_list ':' literal_constant ';' {
                                    table_ptr table = table_stack_top(stack_table);
                                    int i;
                                    for(i = 0; i < vec_string_size($2); i++)
                                    {
                                        char * s = const_type_get_attrbute_string($4);
                                        entry_ptr p = new_entry(vec_string_at($2, i),
                                                                K_CONSTANT,
                                                                table_get_level(table),
                                                                const_type_get_type($4),
  																empty_attr,
  															    s);
                                        free(s);
                                        table_push(table, p);
                                    }
                                    vec_string_clear($2);
                        		    delete_vec_string($2);
								}
                                ;


/* function */
function_list					: /* empty */
                                | function_list_ext
                                ;

function_list_ext				: function function_list_ext
                                | function
                                ;

function						: function_name '(' arguments ')' ':' array_types ';' {
                                    table_ptr table = table_stack_top(stack_table);
                                    entry_ptr p = new_entry($1,
															K_FUNCTION,
															table_get_level(table),
															$6,
															empty_attr,
															$3);								    
									table_push(table, p);
								} function_body END identifier {
                                }
                                | function_name '(' arguments ')' ';' {
                                    table_ptr table = table_stack_top(stack_table);
                                    entry_ptr p = new_entry($1,
															K_FUNCTION,
															table_get_level(table),
															"void",
															empty_attr,
															"");								    
									table_push(table, p);
                                } function_body END identifier
                                ;

function_body					: compound
                                ;

function_name					: identifier
                                ;

arguments						: /* empty */   {
                                    $$ = "void";
                                }
                                | arguments_ext { $$ = $1; }
                                ;

arguments_ext					: identifier_list ':' array_types ';' arguments_ext {
									char * arr = (array_construct)? array_object_show(array_construct): $3;
                                    $$ = newstringconcat("", arr);
									if(parameter_table == NULL)
										parameter_table = new_table(0);
								    

									for(int i = 0; i < vec_string_size($1); i++)
									{
										entry_ptr p = new_entry(vec_string_at($1, i),
																K_PARAMETER,
															    0,
															    $3,
															    empty_attr,
															    "");
                                        table_push(parameter_table, p);
										if(i >= 1)
                         				{
	                                        //  $$ = ", " + arr; in c++
										    char * ptr  = $$;
	                                        $$ = newstringconcat($$, ", ");
										    free(ptr);
											char * ptr2 = $$;
											$$ = newstringconcat($$, arr);
	                                        free(ptr2);
                                        }
									}
									char * ptr  = $$;
                                    $$ = newstringconcat($$, ", ");
                                    free(ptr);
                                    char * ptr2 = $$;
									
                                    $$ = newstringconcat($$, $5);
									free(ptr2);
                                    if(array_construct)
                                    {
                                    	free(arr);	
                                    	delete_array_object(array_construct);
                                    	array_construct = NULL;
                                    }
                                    vec_string_clear($1);
                                    delete_vec_string($1);
								}
                                | identifier_list ':' array_types {
	                                if(parameter_table == NULL)
										parameter_table = new_table(0);
								    
									char * arr = (array_construct)? array_object_show(array_construct): $3;
                                    $$ = newstringconcat("", "");
									for(int i = 0; i < vec_string_size($1); i++)
									{
										entry_ptr p = new_entry(vec_string_at($1, i),
																K_PARAMETER,
															    0,
															    $3,
															    empty_attr,
															    "");
                                        table_push(parameter_table, p);
                                        if(i >= 1)
				                        {
									    	char * ptr  = $$;
                                        	$$ = newstringconcat($$, ", ");
									    	free(ptr);
											char * ptr2 = $$;
											$$ = newstringconcat($$, arr);
                                        	free(ptr2);
                                        }
									}
									char * ptr = $$;
                                    $$ = newstringconcat($$, arr);
									free(ptr);
                                    if(array_construct)
                                    {
                                    	free(arr);	
                                    	delete_array_object(array_construct);
                                    	array_construct = NULL;
                                    }
                                    vec_string_clear($1);
                                    delete_vec_string($1);
								}
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
compound						: KWBEGIN {
                                    table_ptr new_p = new_table(table_stack_size(stack_table));
									if(parameter_table != NULL)
									{
										entry_ptr p = table_pop(parameter_table);
									    while (p)
										{
											entry_set_level(p, table_get_level(new_p));
										    table_push(new_p, p);
											p = table_pop(parameter_table);
										}
									        
									    delete_table(parameter_table);
									    parameter_table = NULL;
									}
                                    table_stack_push(stack_table, new_p);
                                }
                                varible_list statements END {
                                    table_ptr p = table_stack_pop(stack_table);
                                    table_print(p);
                                    delete_table(p);
                                }
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

for								: FOR identifier ASSIGN int_constant TO int_constant DO {
								    table_ptr table = table_stack_top(stack_table);
								    char * s = new_for_varrange($4, $6);
								    
								    entry_ptr p = new_entry($2,
                                                            K_VARIABLE,
                                                            table_get_level(table_stack_top(stack_table)),
                                                            "integer",
                                                            empty_attr,
                                                            s);
                                    free(s);
                                    int err = table_push(table, p);
                                    if(err)
									{
									    report_error_redeclared_var(linenum, entry_get_name(p));
									    delete_entry(p);
                                        for_error++;
									}
								} statements END DO {
//									table_print(table_stack_top(stack_table));
									if(for_error == 0)
									    table_remove(table_stack_top(stack_table), $2);
                                }
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

	yyparse();

	table_stack_pop(stack_table);
	delete_table_stack(stack_table);
	
	fclose(fp);
	exit(0);
}
