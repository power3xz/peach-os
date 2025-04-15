#ifndef PEACHOS_H
#define PEACHOS_H

#include <stddef.h>
#include <stdbool.h>

void print(const char *filename);
int peachos_getkey();
int peachos_getkey_block();
void *peachos_malloc(size_t size);
void peachos_free(void *ptr);
void peachos_putchar(char c);
void peachos_terminal_readline(char *out, int max, bool output_while_typing);

#endif
