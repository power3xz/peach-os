#ifndef PROCESS_H
#define PROCESS_H

#include <stdint.h>
#include "config.h"
#include "task.h"

#define PROCESS_FILETYPE_ELF 0
#define PROCESS_FILETYPE_BINARY 1

typedef unsigned char PROCESS_FILETYPE;

struct process
{
  // the process id
  uint16_t id;
  char filename[PEACHOS_MAX_PATH];

  // the main process task
  struct task *task;

  // the memory (malloc) allocations of the process
  void *allocations[PEACHOS_MAX_PROGRAM_ALLOCATIONS];

  PROCESS_FILETYPE filetype;
  union
  {
    // the physical pointer to the process memory
    void *ptr;
    struct elf_file *elf_file;
  };

  // the physical pointer to stack memory
  void *stack;

  // the size of data pointed to by "ptr"
  uint32_t size;

  struct keyboard_buffer
  {
    char buffer[PEACHOS_KEYBOARD_BUFFER_SIZE];
    int tail;
    int head;
  } keyboard;
};
int process_switch(struct process *process);
int process_load_switch(const char *filename, struct process **process);

int process_load(const char *filename, struct process **process);
int process_load_for_slot(const char *filename, struct process **processes, int process_slot);
struct process *process_current();
struct process *process_get(int process_id);
void *process_malloc(struct process *process, size_t size);

#endif
