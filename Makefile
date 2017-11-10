TARGET   = parser
OBJECT   = lex.yy.cc
CXX      = clang++
CXXFLAGS = -std=c++14
LEX      = flex++
YACC     = bison


all: $(TARGET)

$(TARGET): lex.yy.cc
	$(CXX) $(CXXFLAGS) $< -o $(TARGET)

lex.yy.cc: scanner.ll
	$(LEX) $<

yacc.tab.hh: yacc.yy
	$(YACC) $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)
