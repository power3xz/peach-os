; x86 kernel boot
ORG 0x7c00 ; 0x7c00 주소 부터 시작
BITS 16

start:
  mov ah, 0eh ; video teletype 출력
  mov al, 'A' ; 출력 문자를 al 레지스터에 저장
  mov bx, 0 ; 폰트 색상
  int 0x10; call bios interrupt

  jmp $

times 510 - ($ - $$) db 0 ; 510 바이트까지 0으로 채움
dw 0xaa55 ; 부트 섹터 마지막에 0xaa55를 삽입하여 부트 섹터임을 표시
