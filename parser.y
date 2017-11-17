%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */

extern int yylex(void);
int yyerror(char *);
%}

/*symbols*/
%token END VAR ARRAY OF TO BG ASSIGN PRINT READ
%token WHILE DO FOR RETURN
%token IDENT TYPE MOD LE GE NE NOT AND OR IF THEN ELSE INT FLOAT SCI OCTAL TRUE FALSE STRING

%left PARENTHESES
%left NEG
%left '*' '/'
%left '+' '-'
%left '>' '<'
%left NOT
%left AND
%left OR


%%
program			: programname ';' programbody END programname
				;

programname		: identifier
				;

identifier		: IDENT
				;

programbody		: varible_list function_list compound
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
	yyparse();

	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fclose(fp);
	exit(0);
}
