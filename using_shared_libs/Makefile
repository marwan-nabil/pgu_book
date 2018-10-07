
all: hello-world-nolib.elf hello-world-lib.elf

hello-world-nolib.elf : hello-world-nolib.s
	as --32 hello-world-nolib.s -o hello-world-nolib.o
	ld -m elf_i386 hello-world-nolib.o -o hello-world-nolib.elf
hello-world-lib.elf : hello-world-lib.s
	as --32 hello-world-lib.s -o hello-world-lib.o
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so -o hello-world-lib.elf hello-world-lib.o -lc
