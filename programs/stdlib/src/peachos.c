#include "peachos.h"

int peachos_getkey_block()
{
  int val = 0;
  do
  {
    val = peachos_getkey();
  } while (val == 0);
  return val;
}

void peachos_terminal_readline(char *out, int max, bool output_while_typing)
{
  int i = 0;
  for (i = 0; i < max - i; i++)
  {
    char key = peachos_getkey_block();
    // carriage return means we have read the line
    if (key == 13)
    {
      break;
    }

    if (output_while_typing)
    {
      peachos_putchar(key);
    }
    // backspace
    if (key == 0x08 && i >= 1)
    {
      out[i - 1] = 0x00;
      // -2 because we will increment i
      i -= 2;
      continue;
    }
    out[i] = key;
  }
  out[i] = 0x00;
}
