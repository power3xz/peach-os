; x86 kernel boot
ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
  jmp short start
  nop
times 33 db 0

start:
  jmp 0:step2

step2:
  cli ; 인터럽트 비활성화
  mov ax, 0x00
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7c00
  sti ; 인터럽트 활성화

.load_protected:
  cli
  lgdt [gdt_descriptor]
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax
  jmp CODE_SEG:load32

; GDT
gdt_start:
gdt_null:
  dd 0x0
  dd 0x0
; offset 0x8
gdt_code: ; CS should point to this
  dw 0xffff ; segment limit first 0 - 15 bits
  dw 0 ; base first 0 - 15 bits
  db 0 ; base 16 - 23 bits
  db 0x9a ; access byte
  db 11001111b ; high 4 bits flags and the low bits flag
  db 0 ; base 24 - 31 bits

; offset 0x10
gdt_data: ; DS, SS, ES, FS, GS
  dw 0xffff ; segment limit first 0 - 15 bits
  dw 0 ; base first 0 - 15 bits
  db 0 ; base 16 - 23 bits
  db 0x92 ; access byte
  db 11001111b ; high 4 bits flags and the low bits flag
  db 0 ; base 24 - 31 bits

gdt_end:
gdt_descriptor:
  dw gdt_end - gdt_start - 1
  dd gdt_start

[BITS 32]
load32:
  mov eax, 1
  mov ecx, 100
  mov edi, 0x0100000
  call ata_lba_read
  jmp CODE_SEG:0x0100000

ata_lba_read:
  mov ebx, eax ; backup the LBA
  ; send the highest 8 bits of the lba to hard disk controller
  shr eax, 24
  or eax, 0xe0 ; select the master drive
  mov dx, 0x1f6
  out dx, al
  ; finished sending the highest 8 bits of the lba

  ;send the total sectors to read
  mov eax, ecx
  mov dx, 0xf2
  out dx, al
  ; finished sending the total sectors to read

  ; send more bits of the LAB
  mov eax, ebx ; restore the backup LBA
  mov dx, 0x1f3
  out dx, al
  ; finished sending more bits of the LBA

  ; send more bits of the LBA
  mov dx, 0x1f4
  mov eax, ebx ; restore the backup LBA
  shr eax, 8
  out dx, al
  ; finished sending more bits of the LBA

  ;send upper 16bits of the LBA
  mov dx, 0x1f5
  mov eax, ebx ; restore the backup LBA
  shr eax, 16
  out dx, al
  ; finished sending upper 16 bits of the LBA

  mov dx, 0x1f7
  mov al, 0x20
  out dx, al

  ; read all sectors into memory
.next_sector:
  push ecx
.try_again:
  mov dx, 0x1f7
  in al, dx
  test al, 8
  jz .try_again
  ; we need to read 256 words to at a time
  mov ecx, 256
  mov dx, 0x1f0
  rep insw
  pop ecx
  loop .next_sector
  ; end of reading sectors into memory
  ret

times 510 - ($ - $$) db 0 ; 510 바이트까지 0으로 채움
dw 0xaa55 ; 부트 섹터 마지막에 0xaa55를 삽입하여 부트 섹터임을 표시
