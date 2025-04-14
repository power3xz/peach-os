#include <stdint.h>
#include <stddef.h>

#include "kernel.h"
#include "idt/idt.h"
#include "io/io.h"
#include "memory/kheap.h"
#include "memory/paging.h"
#include "memory/memory.h"
#include "string/string.h"
#include "disk/disk.h"
#include "fs/pparser.h"
#include "disk/streamer.h"
#include "string/string.h"
#include "fs/file.h"
#include "gdt/gdt.h"
#include "task/tss.h"
#include "config.h"
#include "task/task.h"
#include "task/process.h"
#include "status.h"
#include "isr80h/isr80h.h"
#include "keyboard/keyboard.h"

uint16_t *video_memory = 0;
uint16_t terminal_row = 0;
uint16_t terminal_col = 0;

uint16_t terminal_make_char(char c, char color)
{
  return (color << 8) | c;
}

void terminal_putchar(int x, int y, char c, char color)
{
  video_memory[y * VGA_WIDTH + x] = terminal_make_char(c, color);
}

void terminal_backspace()
{
  if (terminal_row == 0 && terminal_col == 0)
  {
    return;
  }
  if (terminal_col == 0)
  {
    terminal_row -= 1;
    terminal_col = VGA_WIDTH;
  }
  terminal_col -= 1;
  terminal_writechar(' ', 15);
  terminal_col -= 1;
}

void terminal_writechar(char c, char color)
{
  if (c == '\n')
  {
    terminal_row += 1;
    terminal_col = 0;
    return;
  }
  if (c == 0x08)
  {
    terminal_backspace();
    return;
  }
  terminal_putchar(terminal_col, terminal_row, c, color);
  terminal_col += 1;
  if (terminal_col >= VGA_WIDTH)
  {
    terminal_col = 0;
    terminal_row += 1;
  }
}

void terminal_initialize()
{
  terminal_row = 0;
  terminal_col = 0;
  video_memory = (uint16_t *)0xb8000;
  for (int y = 0; y < VGA_HEIGHT; y++)
  {
    for (int x = 0; x < VGA_WIDTH; x++)
    {
      terminal_putchar(x, y, ' ', 0);
    }
  }
}

void print(const char *str)
{
  size_t len = strlen(str);
  for (size_t i = 0; i < len; i++)
  {
    terminal_writechar(str[i], 15);
  }
}

static struct paging_4gb_chunk *kernel_chunk = 0;

void panic(const char *msg)
{
  print(msg);
  while (1)
  {
  }
}

void kernel_page()
{
  kernel_registers();
  paging_switch(kernel_chunk);
}

struct tss tss;
struct gdt gdt_real[PEACHOS_TOTAL_GDT_SEGMENTS];
struct gdt_structured gdt_structured[PEACHOS_TOTAL_GDT_SEGMENTS] = {
    {.base = 0x00, .limit = 0x00, .type = 0x00},                 // NULL segment
    {.base = 0x00, .limit = 0xffffffff, .type = 0x9a},           // kernel code segment
    {.base = 0x00, .limit = 0xffffffff, .type = 0x92},           // kernrel data segment
    {.base = 0x00, .limit = 0xffffffff, .type = 0xf8},           // user code segment
    {.base = 0x00, .limit = 0xffffffff, .type = 0xf2},           // user data segment
    {.base = (uint32_t)&tss, .limit = sizeof(tss), .type = 0xe9} // tss segment
};

void kernel_main()
{
  terminal_initialize();

  memset(gdt_real, 0x00, sizeof(gdt_real));
  get_structured_to_gdt(gdt_real, gdt_structured, PEACHOS_TOTAL_GDT_SEGMENTS);
  // load the gdt
  gdt_load(gdt_real, sizeof(gdt_real));
  // initialize the heap
  kheap_init();

  // initialize filesystem
  fs_init();

  // search and initialize the disk
  disk_search_and_init();

  // initialize the interrupt descriptor table
  idt_init();

  // setup the tss
  memset(&tss, 0x00, sizeof(tss));
  tss.esp0 = 0x600000;
  tss.ss0 = KERNEL_DATA_SELECTOR;

  // load the tss
  tss_load(0x28);

  // setup paging
  kernel_chunk = paging_new_4gb(PAGING_IS_WRITABLE | PAGING_IS_PRESENT | PAGING_ACCESS_FROM_ALL);

  // switch to kernel paging chunk
  paging_switch(kernel_chunk);

  enable_paging();

  isr80h_register_commands();

  keyboard_init();

  struct process *process = 0;
  int res = process_load_switch("0:/blank.elf", &process);
  if (res != PEACHOS_ALL_OK)
  {
    panic("Failed to load blank.elf\n");
  }

  task_run_first_ever_task();

  while (1)
  {
  }
}
