%option c++ noyywrap
%{
#if __cplusplus < 201103L
    #error("Please compile using -std=c++11 or higher")
#endif

#include <memory>
#include <regex>
#include <fstream>
using std::printf;
using std::strcat;

#define LIST               strcat(buf, YYText())
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenIm(t)         {LIST; if (Opt_T) printf("<%s>\n", t);}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define LINE_END           {\
                                if (Opt_S)\
                                    printf("%3d: %s", linenum, buf);\
                                linenum++;\
                                strcpy(buf, "");\
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
sci_num     {float}[eE][+-]?{number}
						
%x C_COMMENT
%x CPP_COMMENT
%x STR

												
%%

<CPP_COMMENT>&S+    { LIST; Opt_S = true; }
<CPP_COMMENT>&S-    { LIST; Opt_S = false;}
<CPP_COMMENT>&T+    { LIST; Opt_T = true; }
<CPP_COMMENT>&T-    { LIST; Opt_T = false;}
<CPP_COMMENT>"\n"   { LIST; LINE_END; BEGIN(INITIAL); }
<CPP_COMMENT>.      { LIST; }
"//"     { LIST; BEGIN(CPP_COMMENT);}

"/*"     { BEGIN(C_COMMENT);}

<C_COMMENT>[^*\n]*      { /* eat */ }
<C_COMMENT>"*"+[^*/\n]* { /* eat */ }
<C_COMMENT>\n           { ++linenum; }
<C_COMMENT>"*/"         { BEGIN(INITIAL); }


{token_char} { tokenChar(YYText()[0]); }
{keyword}    {
                 tokenIm((std::string("KW") + YYText()).c_str());
             }

{number} {
             if(YYText()[0] == '0')
			 {
                 tokenString(oct_integer, YYText());
             }
             else
			 {
                 tokenString(integer, YYText());
             }
         }
{float}  { tokenString(float, YYText()); }

{sci_num} { tokenString(scientific, YYText()); }

{form_string}      {
                       std::regex e("\"\"");
                       string_buf = std::regex_replace(std::string(YYText(), 1, YYLeng() - 2), e, "\"");
                       tokenString(string, string_buf.c_str());
                   }
				
{arith_string} { tokenIm(YYText());}

{ignore_char} {LIST;}

{letter}({letter}|{digit})* { tokenString(id, YYText()); }

\n	         { LIST; LINE_END;}

%%

//                  LIST;
//                  if (Opt_S)
//	                  printf("%3d: %s", linenum, buf);
//                  linenum++;
//                  strcpy(buf, "");




int main( int argc, char *argv[] )
{
   	if (argc != 2)
	{
		std::cerr << "Missing argument: [file]\n";	   
		exit(1);
	}
	std::ifstream input(argv[1]);
    std::unique_ptr<FlexLexer> lexer(new yyFlexLexer(input, std::cout));

    while( lexer->yylex() != 0 );
    return 0;
}

	
