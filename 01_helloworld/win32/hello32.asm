[BITS 32]

  GLOBAL _main
  EXTERN _ExitProcess@4
  EXTERN _GetStdHandle@4
  EXTERN _WriteFile@20

  SECTION .text
_main:
    push -0Bh   ;STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    push 0
    push 0
    push msglen
    push message
    push eax
    call _WriteFile@20
    push 0
    call _ExitProcess@4
    xor eax, eax
    ret

  SECTION .data
    message db 'Hello, World', 10
    msglen equ $-message
