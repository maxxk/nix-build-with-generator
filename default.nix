{ pkgs ? import <nixpkgs> {}}:
let
    link = { name, inputs, args ? []}: derivation {
        inherit (pkgs) system;
        inherit name;
        builder = "${pkgs.stdenv.cc}/bin/cc";
        args = [
            "-o"
            (placeholder "out")
        ]  ++ inputs ++ args;
    };

    cc = { input, args ? [] }: link {
        name = "${baseNameOf input}.o";
        inputs = [ input ];
        args = [ "-c" ] ++ args;
    };
    
    generator-bin = link ({ name = "generator"; inputs = [ ./generator.c ]; });

    generate = { input }: derivation {
        inherit (pkgs) system;
        name = "${baseNameOf input}.c";
        builder = generator-bin;
        args = [
            input
            (placeholder "out")
        ];
    };

    hello-c = generate { input = ./generator-source.txt; };

    sources = [ hello-c ./program.c ];
    objs = map (source: cc { input = source; }) sources;
    bin = link { name = "program"; inputs = objs; };
    bin2 = link { name = "program2"; inputs = [ (cc { input = ./program.c; }) ]; };
in 
    bin
    # bin2