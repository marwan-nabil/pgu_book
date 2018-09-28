# how to assemble and run ?
you probably have a 64-bit compiler, these files are written in 32-bit assembly.   
to assemble 32-bit assembly code into object files use:
```bash
	as --32 power.s -o power.o
```
to link that object file into an executable use:
```bash
	ld -m elf_i386 power.o -o power
```
to run the program use:
```bash
	./power
```
