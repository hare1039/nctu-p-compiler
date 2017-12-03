TARGET	  = parser
OBJECT	  = lex.yy.c y.tab.h y.tab.c y.output stack_interface.o stlstack.o
CC		  = clang -g
CXX       = clang++
CXX_FLAGS = -std=c++14
LEX		  = flex
LIBS	  = -lfl -ly -lstdc++ -lm
YACC	  = yacc -d -v

all: stack_interface.o stlstack.o lex.yy.c y.tab.c
	$(CC) -o $(TARGET) $(LIBS) $^

y.tab.c: parser.y
	$(YACC) $<

lex.yy.c: lex.l
	$(LEX) -o $@ $<

stack_interface.o: stack_interface.cpp
	$(CXX) $(CXX_FLAGS) -o $@ -c $<

stlstack.o: stlstack.cpp
	$(CXX) $(CXX_FLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm $(TARGET) $(OBJECT)

.PHONY: test
test:
	mkdir 0413220; \
	cp lex.l Makefile parser.y stack_interface* stlstack* 0413220; \
	7z a -tzip 0413220.zip 0413220 >/dev/null ; \
	rm -r 0413220; \
	mv 0413220.zip test_files; \
	cd test_files; \
	./test.sh; \
	rm -r 0413220.zip 0413220/

.PHONY: test2
test2:
	mkdir 0413220; \
	cp lex.l Makefile parser.y stack_interface* stlstack* 0413220; \
	7z a -tzip 0413220.zip 0413220 >/dev/null ; \
	rm -r 0413220; \
	mv 0413220.zip test_files; \
	cd test_files; \
	./test2.sh;

.PHONY: test2clean
test2clean:
	cd test_files;\
	rm -r 0413220.zip 0413220/


.PHONY: build
build:
	mkdir 0413220; \
	cp lex.l Makefile parser.y stack_interface* stlstack* README.org 0413220; \
	7z a -tzip 0413220.zip 0413220 >/dev/null ; \
	rm -r 0413220;
