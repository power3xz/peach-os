ORG 0x7c00
BITS 16

start:
  ; video teletype output
  mov ah, 0eh
  mov al, 'A'
  mov bx, 0
  int 0x10; call bios interrupt

  jmp $

times 510 - ($ - $$) db 0 ; fill the rest of the sector with 0
dw 0xaa55 ; boot signature
