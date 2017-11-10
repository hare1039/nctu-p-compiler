%{
#if __cplusplus < 201103L
    #error("Please compile using -std=c++11 or higher")
#endif

#include <memory>
#include <regex>
#include <fstream>
#include <iostream>

#define LIST               std::strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) std::printf("<%s>\n", #t);}
#define tokenIm(t)         {LIST; if (Opt_T) std::printf("<%s>\n", t);}
#define tokenChar(t)       {LIST; if (Opt_T) std::printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) std::printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) std::printf("<%s: %s>\n", #t, (s));}
#define LINE_END           {\
                                if (Opt_S)\
                                    std::printf("%3d: %s", linenum, buf);\
                                linenum++;\
                                std::strcpy(buf, "");\
	                       }
#define MAX_LINE_LENG      8096

bool Opt_S = true;
bool Opt_T = true;
int  linenum = 1;
char buf[MAX_LINE_LENG];
std::string string_buf;
%}

keyword      array|begin|boolean|def|do|else|end|false|for|integer|if|of|print|read|real|string|then|to|true|return|var|while
token_char   [(|)|,|:|;]
ignore_char  "\t"|" "
arith_string "+"|"-"|"*"|"/"|"mod"|":="|"<"|"<="|"<>"|">="|">"|"="|"and"|"or"|"not"
												
form_string \".*\"
						
letter      [a-zA-Z]
digit       [0-9]

number      {digit}*
float       {digit}*\.{digit}+
sci_num     {float}|{number}[eE][+-]?{number}
						
%x C_COMMENT
%x STR

												
%%

"//&S+".*    { LIST; Opt_S = true; }
"//&S-".*    { LIST; Opt_S = false;}
"//&T+".*    { LIST; Opt_T = true; }
"//&T-".*    { LIST; Opt_T = false;}
"//".*    { LIST; }

"/*"     { BEGIN(C_COMMENT);}

<C_COMMENT>[^*\n]*      { /* eat */ }
<C_COMMENT>"*"+[^*/\n]* { /* eat */ }
<C_COMMENT>\n           { ++linenum; }
<C_COMMENT>"*/"         { BEGIN(INITIAL); }


{token_char} { tokenChar(yytext[0]); }
{keyword}    {
                 tokenIm((std::string("KW") + std::string(yytext)).c_str());
             }

{number} {
             if(yytext[0] == '0')
			 {
                 tokenString(oct_integer, yytext);
             }
             else
			 {
                 tokenString(integer, yytext);
             }
         }
{float}  { tokenString(float, yytext); }

{sci_num} { tokenString(scientific, yytext); }

{form_string}      {
                       std::regex e("\"\"");
                       string_buf = std::regex_replace(std::string(std::string(yytext), 1, yyleng - 2), e, "\"");
                       tokenString(string, string_buf.c_str());
                   }
				
{arith_string} { tokenIm(yytext);}

{ignore_char} {LIST;}

{letter}({letter}|{digit})* { tokenString(id, yytext); }

\n	         { LIST; LINE_END;}

.            { LIST; std::printf("error at line %d: bad character '%s'\n", linenum, yytext); }
%%


int main( int argc, char *argv[] )
{
   	if (argc != 2)
	{
		std::cerr << "Missing argument: [file]\n";	   
		exit(1);
	}
	FILE *fp = std::fopen(argv[1], "r");
	
	if(fp == NULL){
		std::cout << "Open file error\n";
		std::exit(1);
	}
	
	yyin = fp;
	yylex();
	std::fclose(fp);
    return 0;
}

	
