TARGET	= parser
OBJECT	= lex.yy.c y.tab.h y.tab.c y.output
CC		= clang -g
LEX		= flex
LIBS	= -lfl -ly
YACC	= yacc -d -v

all: lex.yy.c y.tab.c
	$(CC) lex.yy.c y.tab.c -o $(TARGET) $(LIBS)

y.tab.c: parser.y
	$(YACC) parser.y

lex.yy.c: lex.l
	$(LEX) lex.l

.PHONY: clean
clean:
	rm $(TARGET) $(OBJECT)

.PHONE: test
test:
	mkdir 0413220 && \
	cp lex.l Makefile parser.y 0413220 && \
	7z a -tzip 0413220.zip 0413220 >/dev/null  && \
	rm -r 0413220 && \
	mv 0413220.zip compiler-hw2/compiler_examples && \
	cd compiler-hw2/compiler_examples && \
	./test.sh && \
	echo ---- diff start ---- && \
	diff -r ExAns 0413220/ans && \
	echo ---- diff end ------ && \
	rm -r 0413220.zip 0413220/ 
