#include "peachos.h"
#include "stdlib.h"
#include "stdio.h"

int main(int argc, char **argv)
{
  printf("My age is %i\n", 90);
  print("hello how are you!\n");
  print(itoa(8763));
  putchar((int)'Z');
  void *ptr = malloc(512);
  free(ptr);
  if (ptr)
  {
  }

  while (1)
  {
    if (getkey() != 0)
    {
      print("key was pressed\n");
    }
  }
  return 0;
}
