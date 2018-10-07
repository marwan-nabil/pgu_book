all: write-records.elf read-records.elf add-year.elf Makefile

clean:
	rm *.o
	rm *.dat

# executables
write-records.elf : write-records.o record-operations.o linux-defs.s record-defs.s
	ld -m elf_i386 write-records.o record-operations.o -o write-records.elf
read-records.elf : read-records.o record-operations.o write-newline.o count-chars.o linux-defs.s record-defs.s
	ld -m elf_i386 read-records.o record-operations.o write-newline.o count-chars.o -o read-records.elf
add-year.elf: add-year.o record-operations.o linux-defs.s record-defs.s
	ld -m elf_i386 add-year.o record-operations.o -o add-year.elf

# objects
add-year.o: add-year.s linux-defs.s record-defs.s
	as --32 add-year.s -o add-year.o
write-newline.o: write-newline.s linux-defs.s record-defs.s
	as --32 write-newline.s -o write-newline.o
count-chars.o: count-chars.s
	as --32 count-chars.s -o count-chars.o
read-records.o: read-records.s linux-defs.s record-defs.s
	as --32 read-records.s -o read-records.o
record-operations.o: record-operations.s linux-defs.s record-defs.s
	as --32 record-operations.s -o record-operations.o
write-records.o: write-records.s linux-defs.s record-defs.s
	as --32 write-records.s -o write-records.o

