[BITS 32]

section .asm

global print:function
global peachos_getkey:function
global peachos_malloc:function
global peachos_free:function
global peachos_putchar:function
global peachos_process_load_start:function
global peachos_process_get_arguments:function
global peachos_system:function
global peachos_exit:function

; void print(const char* filename)
print:
  push ebp
  mov ebp, esp
  push dword[ebp + 8] ; filename
  mov eax, 1 ; command print
  int 0x80
  add esp, 4

  pop ebp
  ret

; int peachos_getkey()
peachos_getkey:
  push ebp
  mov ebp, esp
  mov eax, 2 ; command getkey
  int 0x80
  pop ebp
  ret

; void peachos_putchar(char c)
peachos_putchar:
  push ebp
  mov ebp, esp

  mov eax, 3 ; command putchar
  push dword[ebp + 8] ; variable c
  int 0x80

  add esp, 4
  pop ebp
  ret

; void* peachos_malloc(size_t size)
peachos_malloc:
  push ebp
  mov ebp, esp

  mov eax, 4 ; command malloc (allocate memory for the process)
  push dword[ebp + 8] ; size
  int 0x80

  add esp, 4
  pop ebp
  ret

; void peachos_free(void* ptr)
peachos_free:
  push ebp
  mov ebp, esp

  mov eax, 5 ; command 5 free
  push dword[ebp + 8]
  int 0x80

  add esp, 4
  pop ebp
  ret


; void peachos_process_load_start(const char* filename)
peachos_process_load_start:
  push ebp
  mov ebp, esp

  mov eax, 6 ; command process_load_start
  push dword[ebp + 8] ; filename
  int 0x80

  add esp, 4
  pop ebp
  ret

; int peachos_system(struct command_argument* argument)
peachos_system:
  push ebp
  mov ebp, esp

  mov eax, 7 ; command system
  push dword[ebp + 8] ; argument
  int 0x80

  add esp, 4
  pop ebp
  ret

; void peachos_process_get_arguments(struct process_arguments* arguments)
peachos_process_get_arguments:
  push ebp
  mov ebp, esp

  mov eax, 8 ; command process_get_arguments
  push dword[ebp + 8] ; arguments
  int 0x80

  add esp, 4
  pop ebp
  ret

; void peachos_exit()
peachos_exit:
  push ebp
  mov ebp, esp

  mov eax, 9 ; command exit
  int 0x80

  pop ebp
  ret
