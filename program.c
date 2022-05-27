#include <stdio.h>

extern const char *hello;

int main(void) {
    puts(hello);
    return 0;
}