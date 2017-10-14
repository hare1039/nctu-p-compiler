# NCTU 0413220 report 
A small p-language compiler

# compile
```
cd ..../0413220-p-compiler
mkdir build
cd build
cmake ..
make
```
Binaries will generate in `./bin/`

# Platform & dependency:
- dependency
  - cmake
  - make
  - flex
- Platform
  - Linux
  - FreeBSD
  - macOS # please use brewed-flex

# Usage

`./bin/scanner [file]`