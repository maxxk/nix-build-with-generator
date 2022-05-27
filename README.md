# Experiment with Nix as a build system

I am trying to reproduce something like the Makefile in Nix:

```make
all: program

generator: generator.o
generator.o: generator.c

program: program.o generator-source.txt.o
program.o: program.c
generator-source.txt.o: generator-source.txt.c
generator-source.txt.c: generator generator-source.txt
	./generator generator-source.txt generator-source.txt.c
```

`bin2` output (commented out) launches all the expected commands.

However, `bin` output, which includes the generated output, fails:

```
error: the string 'dncb9avkhfjsiwqhavfhzhdg546xfm66-generator-source.txt.c.o' is not allowed to refer to a store path (such as '!out!/nix/store/mkk7igwgdyarinx32qcg17bc85lasdhm-generator-source.txt.c.drv'), at /nix/store/dmq2vksdhssgfl822shd0ky3x5x0klh4-nix-2.3.15/share/nix/corepkgs/derivation.nix:8:12
```