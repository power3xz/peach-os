#ifndef PROCESS_H
#define PROCESS_H

#include <stdint.h>
#include "config.h"
#include "task.h"

struct process
{
  // the process id
  uint16_t id;
  char filename[PEACHOS_MAX_PATH];

  // the main process task
  struct task *task;

  // the memory (malloc) allocations of the process
  void *allocations[PEACHOS_MAX_PROGRAM_ALLOCATIONS];

  // the physical pointer to the process memory
  void *ptr;

  // the physical pointer to stack memory
  void *stack;

  // the size of data pointed to by "ptr"
  uint32_t size;
};

#endif
