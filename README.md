# NCTU 0413220 hw1-report 
A small p-language compiler
  - hw1-scanner

# Platform & dependency:
- dependency
  - cmake
  - make
  - flex
- Platform
  - Linux
  - FreeBSD
  - macOS   # please use brewed-flex


If you get an error like `member reference type 'std::istream *' (aka 'basic_istream<char> *') is a pointer; maybe you meant to use '->'? `, please make sure the version of `FlexLexer.h` are synced with `flex --version`.
Flex 2.6.0 changed the storage definition of yyin storage for C++ scanners for both the header and the generated source. 

# compile
```
cd 0413220-p-compiler
mkdir build
cd build
cmake ..
make
```
Binaries will generate in `./bin/`

# Usage

`./bin/scanner [file]`

# Ability

Same as `project.pdf` required.
