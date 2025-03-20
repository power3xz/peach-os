#ifndef CLASSIC_H
#define CLASSIC_H

#define PS2_PORT 0x64
#define PS2_COMMAND_ENABlE_FIRST_PORT 0xae

struct keyboard *classic_init();

#endif
