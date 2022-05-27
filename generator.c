#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[argc]) {
    if (argc < 3) {
        return 0;
    }
    FILE *input = fopen(argv[1], "r");
    FILE *output = fopen(argv[2], "w");

    char *line = NULL;
    size_t size = 0;
    assert(getline(&line, &size, input) != -1);
    fclose(input);

    fputs("const char *hello = \"", output);
    fputs(line, output);
    fputs("\";\n", output);
    fclose(output);
    free(line);
    return 0;
}