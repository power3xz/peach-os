#include "process.h"
#include "task/task.h"
#include "status.h"
#include "task/process.h"
#include "config.h"

void *isr80h_command6_process_load_start(struct interrupt_frame *frame)
{
  void *filename_user_ptr = task_get_stack_item(task_current(), 0);
  char filename[PEACHOS_MAX_PATH];
  int res = copy_string_from_task(task_current(), filename_user_ptr, filename, sizeof(filename));
  if (res < 0)
  {
    goto out;
  }

  struct process *process = 0;
  res = process_load_switch(filename, &process);
  if (res < 0)
  {
    goto out;
  }

  task_switch(process->task);
  task_return(&process->task->registers);

out:
  return 0;
}
