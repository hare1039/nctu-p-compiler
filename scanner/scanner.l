%{

#define LIST                strcat(buf, yytext)
#define token(t)            {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define token_char(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define token_integer(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define token_string(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define MAX_LINE_LENG       256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];

%}

%%

"(" { token_char('('); }
\n	{
         LIST;
         if (Opt_S)
	         printf("%d: %s\n", linenum, buf);
         linenum++;
         buf[0] = '\0';
    }

%%

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		fprintf(stderr, "Missing argument: [file]\n");
		exit(1);
	}

	FILE *fp = fopen(argv[1], "r");
	if (! fp)
	{
		fprintf(stderr, "File can't open. Abort.\n");
		exit(1);
	}

	yyin = fp;

	ttlex();

	close(fp);
	fp = NULL;
	
	return 0;
}
