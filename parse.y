
%{
#include <iostream>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token SEMICOLON END IDENT

%%

expr : ;

%%

int yyerror( char *msg )
{
    fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
    fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
    fprintf( stderr, "|\n" );
    fprintf( stderr, "| Unmatched token: %s\n", yytext );
    fprintf( stderr, "|--------------------------------------------------------------------------\n" );
    exit(-1);

// program		: programname SEMICOLON programbody END IDENT
// 		;
// 
// programname	: identifier
// 		;
// 
// identifier	: IDENT
// 		;
}

int main( int argc, char *argv[] )
{
	std::cout << "yacc\n";
	
/*	if( argc != 2 ) {
//		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
//		exit(0);
//	}
//
//	
//	std::cout << "\n"
//	"|--------------------------------|\n"
//	"|  There is no syntactic error!  |\n"
//	"|--------------------------------|\n"
//	
 */
}
