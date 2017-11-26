TARGET	  = parser
OBJECT	  = lex.yy.c y.tab.h y.tab.c y.output libstack_interface.so libstlstack.so
CC		  = clang -g
CXX       = clang++
CXX_FLAGS = -std=c++14 -shared -fPIC
LEX		  = flex
LIBS	  = -L. -lfl -ly -lstack_interface -lstlstack
YACC	  = yacc -d -v

all: lex.yy.c y.tab.c libstack_interface.so
	$(CC) -o $(TARGET) $(LIBS) lex.yy.c y.tab.c

y.tab.c: parser.y
	$(YACC) $<

lex.yy.c: lex.l
	$(LEX) -o $@ $<

libstack_interface.so: stack_interface.cpp libstlstack.so
	$(CXX) $(CXX_FLAGS) -L. -lstlstack -o $@ $<

libstlstack.so: stlstack.cpp
	$(CXX) $(CXX_FLAGS) $< -o $@

.PHONY: clean
clean:
	rm $(TARGET) $(OBJECT)

.PHONY: test
test:
	mkdir 0413220; \
	cp lex.l Makefile parser.y 0413220; \
	7z a -tzip 0413220.zip 0413220 >/dev/null ; \
	rm -r 0413220; \
	mv 0413220.zip compiler-hw2/compiler_examples; \
	cd compiler-hw2/compiler_examples; \
	./test.sh; \
	echo ---- diff start ----; \
	diff -r ExAns 0413220/ans; \
	echo ---- diff end ------; \
	rm -r 0413220.zip 0413220/ 

.PHONY: build
build:
	mkdir 0413220; \
	cp lex.l Makefile parser.y README.org 0413220; \
	7z a -tzip 0413220.zip 0413220 >/dev/null ; \
	rm -r 0413220;
