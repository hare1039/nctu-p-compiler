TARGET   = parser
OBJECT   = lex.yy.cc
CXX      = clang++
CXXFLAGS = -std=c++14 -Wno-deprecated-register
LEX      = flex
YACC     = bison
OS       = $(shell uname)


all: $(TARGET)

$(TARGET): lex.yy.cc

	$(CXX) $(CXXFLAGS) -ll $< -o $(TARGET)
lex.yy.cc: scanner.l
	$(LEX) -o lex.yy.cc $<

yacc.tab.hh: yacc.yy
	$(YACC) $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)
