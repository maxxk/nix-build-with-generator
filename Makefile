all: program

generator: generator.o
generator.o: generator.c

program: program.o generator-source.txt.o
program.o: program.c
generator-source.txt.o: generator-source.txt.c
generator-source.txt.c: generator generator-source.txt
	./generator generator-source.txt generator-source.txt.c

