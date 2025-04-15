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
