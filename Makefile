TARGET   = parser
OBJECT   = lex.yy.cc parse.tab.hpp parse.tab.cpp
CXX      = clang++
CXXFLAGS = -std=c++14 -Wno-deprecated-register
LEX      = flex
YACC     = bison
LIB      = -lfl -ly
OS       = $(shell uname)


all: $(TARGET)

$(TARGET): lex.yy.cc parse.tab.cpp
	$(CXX) $(CXXFLAGS) $(LIB) $< -o $(TARGET)

parse.tab.hpp: parse.ypp
	$(YACC) -d $<

lex.yy.cc: scanner.l parse.tab.hpp
	$(LEX) -o lex.yy.cc $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)
