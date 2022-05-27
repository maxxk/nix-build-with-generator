{ pkgs ? import <nixpkgs> {}}:
let
    HASH_LENGTH = 32;
    cleanName = name: 
        let 
            base = baseNameOf name;
            baseLength = builtins.stringLength base; in
        if baseLength > HASH_LENGTH + 1
        then builtins.unsafeDiscardStringContext (
            builtins.substring (HASH_LENGTH + 1) (baseLength - HASH_LENGTH - 1) base
        ) else base;

    link = { name, inputs, args ? []}: derivation {
        inherit (pkgs) system;
        inherit name;
        builder = "${pkgs.stdenv.cc}/bin/cc";
        args = [
            "-o"
            (placeholder "out")
        ]  ++ inputs ++ args;
        # PATH = "${pkgs.darwin.cctools}/bin";
    };

    cc = { input, args ? [] }: link {
        name = "${cleanName input}.o";
        inputs = [ input ];
        args = [ "-c" ] ++ args;
    };
    
    generator-bin = link ({ name = "generator"; inputs = [ ./generator.c ]; });

    generate = { input }: derivation {
        inherit (pkgs) system;
        name = "${cleanName input}.c";
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