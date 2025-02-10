; x86 kernel boot
ORG 0
BITS 16
_start:
  jmp short start
  nop
times 33 db 0

start:
  jmp 0x7c0:step2

handle_zero:
  mov ah, 0eh
  mov al, 'A'
  mov bx, 0x00
  int 0x10
  iret

handle_one:
  mov ah, 0eh
  mov al, 'V'
  mov bx, 0x00
  int 0x10
  iret

step2:
  cli ; 인터럽트 비활성화
  mov ax, 0x7c0
  mov ds, ax
  mov es, ax
  mov ax, 0x00
  mov ss, ax
  mov sp, 0x7c00
  sti ; 인터럽트 활성화

  ; ivt 초기화
  ; 0번 인터럽트, divided by zero error
  mov word[ss:0x00], handle_zero ; offset
  mov word[ss:0x02], 0x7c0 ; segment
  ; 1번 인터럽트
  mov word[ss:0x04], handle_one ; offset
  mov word[ss:0x06], 0x7c0 ; segment

  mov si, message ; message의 주소를 si레지스터에 저장
  call print
  jmp $

print:
  mov bx, 0 ; 페이지 숫자, 폰트 색상
.loop:
  lodsb ; si가 가리키는 메모리를 al 레지스터에 로드하고 si를 증가
  ; ex)
  ; mov al, [si] ; 출력 문자를 al 레지스터에 저장
  ; inc si ; si를 증가
  cmp al, 0 ; 문자열이 끝났는지 확인
  je .done ; message의 끝에 0이 있으므로 0이 나오면 종료 -> .done으로 점프
  call print_char ; 그렇지 않다면 print_char 호출
  jmp .loop ; 다음 문자 출력
.done:
  ret

print_char:
  mov ah, 0eh ; video teletype 출력
  int 0x10; call bios interrupt
  ret

message: db 'Hello World!', 0

times 510 - ($ - $$) db 0 ; 510 바이트까지 0으로 채움
dw 0xaa55 ; 부트 섹터 마지막에 0xaa55를 삽입하여 부트 섹터임을 표시
