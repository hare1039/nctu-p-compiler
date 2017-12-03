/**
 * Introduction to Compiler Design by Prof. Yi Ping You
 * Project 1 Sample
 */

%{
#include <string.h>
#include "y.tab.h"
#include "stack_interface.h"

#define LIST strcat( buf, yytext )
#define token(t)				{ LIST; if (Opt_T) printf("<%s>\n", #t );}
#define tokenChar(t)			{ LIST; if (Opt_T) printf("<%c>\n", t  );}
#define tokenInteger(t, i)		{ LIST; if (Opt_T) printf("<%s: %d>\n", t, i); }
#define tokenOctInteger(t, i)	{ LIST; if (Opt_T) printf("<%s: %s>\n", t, i); }
#define tokenFloat(t, i)		{ LIST; if (Opt_T) printf("<%s: %s>\n", t, i); }
#define tokenScientific(t, s)	{ LIST; if (Opt_T) printf("<%s: %s>\n", t, s); }
#define tokenString(t, s)		{ LIST; if (Opt_T) printf("<%s: %s>\n", t, s); }


#define MAX_LINE_LENG 8192

int  Opt_S   = 1;				  /* list source code option */
int  Opt_T   = 1;				  /* list token option */
int  Opt_D   = 1;
int  linenum = 1;    			  /* line number */
char buf[MAX_LINE_LENG];		  /* source code line buffer */
char str_content[MAX_LINE_LENG];  /* string buffer */

int  yylex(void);
void set_pseudo_comment( const char * );	/* pseudo comment option switch */
%}

whitespace  [ \t]+
letter      [A-Za-z]
digit       [0-9]
integer     0|[1-9][0-9]*
octal       0[0-7]+
fraction    0|[0-9]*
float       {integer}"."{fraction}
scientific ({integer}|{float}|{octal})[Ee][+-]?({integer}|{octal})
identifier ({letter})({letter}|{digit})*

 /* exclusive start conditions */
%x STR
%x COMMENT
%x COMMENT_CPP

%%

","			 { tokenChar(','); yylval.string_ = strdup(yytext); return ',';}
";"			 { tokenChar(';'); yylval.string_ = strdup(yytext); return ';';}
":"			 { tokenChar(':'); yylval.string_ = strdup(yytext); return ':';}
")"			 { tokenChar(')'); yylval.string_ = strdup(yytext); return ')';}
"("			 { tokenChar('('); yylval.string_ = strdup(yytext); return '(';}
"["			 { tokenChar('['); yylval.string_ = strdup(yytext); return '[';}
"]"			 { tokenChar(']'); yylval.string_ = strdup(yytext); return ']';}
			 				   
"+"			 { tokenChar('+'); yylval.string_ = strdup(yytext);	return '+';}
"-"			 { tokenChar('-'); yylval.string_ = strdup(yytext);	return '-';}
"*"			 { tokenChar('*'); yylval.string_ = strdup(yytext);	return '*';}
"/"			 { tokenChar('/'); yylval.string_ = strdup(yytext);	return '/';}
"mod"		 { token(mod);     yylval.string_ = strdup(yytext); return MOD;}
":="		 { token(:=);      yylval.string_ = strdup(yytext);	return ASSIGN;}
"<"			 { tokenChar('<'); yylval.string_ = strdup(yytext);	return '<'; }
"<="		 { token(<=);      yylval.string_ = strdup(yytext);	return LE; }
"<>"		 { token(<>);      yylval.string_ = strdup(yytext);	return NE;}
">="		 { token(>=);      yylval.string_ = strdup(yytext);	return GE;}
">"			 { tokenChar('>'); yylval.string_ = strdup(yytext);	return '>';}
"="			 { tokenChar('='); yylval.string_ = strdup(yytext);	return '=';}
"and"		 { token(and);     yylval.string_ = strdup(yytext);	return AND;}
"or"		 { token(or);      yylval.string_ = strdup(yytext);	return OR;}
"not"		 { token(not);     yylval.string_ = strdup(yytext);	return NOT;}
			 
"boolean"	 { token(KWboolean); yylval.string_ = strdup("boolean"); return TYPE;}
"integer"	 { token(KWinteger); yylval.string_ = strdup("integer"); return TYPE;}
"real"		 { token(KWreal);	 yylval.string_ = strdup("real");    return TYPE;}
"string"	 { token(KWstring);	 yylval.string_ = strdup("string");  return TYPE;}
"array"		 { token(KWarray);	return ARRAY;}
"begin"		 { token(KWbegin);	return KWBEGIN;}
"def"		 { token(KWdef);    return DEF;}
"do"		 { token(KWdo);		return DO;}
"else"		 { token(KWelse);	return ELSE;}
"end"		 { token(KWend);	return END;}
"false"		 { token(KWfalse);	return FALSE;}
"for"		 { token(KWfor);	return FOR;}
"if"		 { token(KWif);		return IF;}
"of"		 { token(KWof);		return OF;}
"print"		 { token(KWprint);	return PRINT;}
"read"		 { token(KWread);	return READ;}
"then"		 { token(KWthen);	return THEN;}
"to"		 { token(KWto);		return TO;}
"true"		 { token(KWtrue);	return TRUE;}
"return"	 { token(KWreturn); return RETURN;}
"var"		 { token(KWvar);	return VAR;}
"while"		 { token(KWwhile);	return WHILE;}

{octal}      { sscanf(yytext, "%o", &yylval.integer_); tokenOctInteger("oct_integer", yytext);	return INT;}
{identifier} { yylval.string_     = strdup(yytext)   ; tokenString    ("id", yytext);			return IDENT;}
{integer}	 { sscanf(yytext, "%d", &yylval.integer_); tokenInteger   ("integer", atoi(yytext));return INT;}
{float}		 { sscanf(yytext, "%f", &yylval.float_)  ; tokenFloat     ("float", yytext);		return FLOAT;}
{scientific} { yylval.string_     = strdup(yytext)   ; tokenScientific("scientific", yytext);	return SCI;}

"\""				{ /* begin string  */
				  LIST;
				  BEGIN STR;
				}

<STR>([^"\n])*			{
				  LIST;
				  strcat( str_content, yytext );
				}

<STR>"\""			{ /* end of string or "" */
				  char c;
				  c = input();
				  if( c == '\"' )	/* "" */
				  {
					LIST;
					strcat( buf, "\"" );
					strcat( str_content, "\"" );
				  }
				  else			/* end of string */
				  {
					unput(c);
					strcat(buf,"\"");
					if (Opt_T)
						printf("<%s: %s>\n", "string", str_content );
                    yylval.string_ = strdup(str_content);
					str_content[0] = '\0';
				  	BEGIN INITIAL;
					return STRING;
				  }
				}
<STR>"\n"			{
				  /* error, cancel execution immediately!  */
				  fprintf( stdout, "error at line %d: string `%s` missing terminating \" character\n", linenum, str_content );
				  exit(-1);
				}

"//&"[A-Z][+-][^\n]*		{ /* pseudo comment */
				  LIST;
				  set_pseudo_comment( yytext );
				}
"//"				{ /* C++ stype comment */
				  LIST;
				  BEGIN COMMENT_CPP;
				}

<COMMENT_CPP>[^\n]+		{
				  LIST;
				}

<COMMENT_CPP>"\n"		{
				  LIST;
				  if( Opt_S )
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
				  BEGIN INITIAL;
				}

"/*"				{ /* C-style comment */
				  LIST;
				  BEGIN COMMENT;
				}
<COMMENT>"*/"			{
				  LIST;
				  BEGIN INITIAL;
				}
<COMMENT>"\n"			{
				  LIST;
				  if  (Opt_S)
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
				}
<COMMENT>.			{
				  LIST;
				}

{whitespace}			{
				  LIST;
				}

\n 				{
				  LIST;
				  if  (Opt_S)
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
		   		}

.				{
				  /* error */
				  printf("error at line %d: bad character \"%s\"\n", linenum, yytext );
				  exit(-1);
				}

%%
void set_pseudo_comment( const char *text )
{
	/* format : //&[A-Z][+-] */
	switch( text[3] ) {
	 case 'S':
		if( text[4] == '+' )
			Opt_S = 1;
		else if( text[4] == '-' )
			Opt_S = 0;
		break;
	 case 'T':
		if( text[4] == '+' )
			Opt_T = 1;
		else if( text[4] == '-' )
			Opt_T = 0;
	 	break;
	 case 'D':
        if( text[4] == '+' )
            Opt_D = 1;
        else if( text[4] == '-' )
            Opt_D = 0;
		printf("'Opt_D:%d'\n", Opt_D);
        break;
	 default:
	 	break;
	}

}

