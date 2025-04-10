#ifndef ELFLOADER_H
#define ELFLOADER_H

#include <stdint.h>
#include <stddef.h>

#include "elf.h"
#include "config.h"

struct elf_file
{
  char filename[PEACHOS_MAX_PATH];

  int in_memory_size;
  /**
   * the physical memory address that this elf file is loaded to
   */
  void *elf_memory;

  /*
   * the virtual base address of this binary
   */
  void *virtual_base_address;

  /*
   * the ending virtual address
   */
  void *virtual_end_address;

  /*
   * the physical base address
   */
  void *physical_base_address;

  /*
   * the ending physical address
   */
  void *physical_end_address;
};

#endif
