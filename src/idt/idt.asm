section .asm

extern init21h_handler
extern no_interrupt_handler
extern isr80h_handler
extern interrupt_handler

global idt_load
global init21h
global no_interrupt
global enable_interrupts
global disable_interrupts
global isr80h_wrapper

enable_interrupts:
  sti
  ret

disable_interrupts:
  cli
  ret

idt_load:
  push ebp
  mov ebp, esp

  mov ebx, [ebp + 8]
  lidt [ebx]

  pop ebp
  ret

init21h:
  pushad

  call init21h_handler

  popad
  iret

no_interrupt:
  pushad

  call no_interrupt_handler

  popad
  iret


%macro interrupt 1
  global int%1
  int%1:
    ; interrupt frame start
    ; already pushed to us by the processor upon entry to this interrupt
    ; uint32_t ip
    ; uint32_t cs
    ; uint32_t flags
    ; uint32_t sp
    ; uint32_t ss
    ; pushes the general purpose registers to the stack
    pushad
    ; interrupt frame end
    push esp
    push dword %i
    call interrupt_handler
    add esp, 8
    popad
    iret
%endmacro

%assign i 0
%rep 512
  interrupt i
%assign i i+1
%endrep

isr80h_wrapper:
  ; interrupt frame start
  ; already pushed to us by the processor upon entry to this interrupt
  ; uint32_t ip
  ; uint32_t cs
  ; uint32_t flags
  ; uint32_t sp
  ; uint32_t ss
  ; pushes the general purpose registers to the stack
  pushad

  ; interrupt frame end

  ; push the stack pointer so that we are pointing to the interrupt frame
  push esp

  ; eax holds our command lets push it to the stack for isr80h_handler
  push eax
  call isr80h_handler
  mov dword[tmp_res], eax
  add esp, 8

  ; restore general purpose registers for user land
  popad
  mov eax, [tmp_res]
  iretd

section .data
; inside here is stored the return result from isr80h_handler
tmp_res: dd 0

%macro interrupt_array_entry 1
  dd int%1
%endmacro

interrupt_pointer_table:
%assign i 0
%rep 512
  interrupt_array_entry i
%assign i i+1
%endrep
