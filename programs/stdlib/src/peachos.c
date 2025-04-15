#include "peachos.h"
#include "string.h"

struct command_argument *peachos_parse_command(const char *command, int max)
{
  struct command_argument *root_command = 0;
  char scommand[1024];
  if (max >= (int)sizeof(scommand))
  {
    return 0;
  }
  strncpy(scommand, command, max);
  char *token = strtok(scommand, " ");
  if (!token)
  {
    goto out;
  }

  root_command = peachos_malloc(sizeof(struct command_argument));
  if (!root_command)
  {
    goto out;
  }
  strncpy(root_command->argument, token, sizeof(root_command->argument));
  root_command->next = 0;

  struct command_argument *current = root_command;
  token = strtok(NULL, " ");
  while (token != 0)
  {
    struct command_argument *new_command = peachos_malloc(sizeof(struct command_argument));
    if (!new_command)
    {
      break;
    }
    strncpy(new_command->argument, token, sizeof(new_command->argument));
    current->next = new_command;
    current = new_command;
    token = strtok(NULL, " ");
  }

out:
  return root_command;
}

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
