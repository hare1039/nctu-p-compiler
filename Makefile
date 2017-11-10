TARGET   = parser
OBJECT   = lex.yy.cc
CXX      = clang++
CXXFLAGS = -std=c++14
LEX      = flex++

all: $(TARGET)

$(TARGET): lex.yy.cc
	$(CXX) $(CXXFLAGS) $< -o $(TARGET)

lex.yy.cc: scanner.l
	$(LEX) $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)
