[BITS 64]
  DEFAULT REL

  GLOBAL _main
  EXTERN ExitProcess
  EXTERN GetStdHandle
  EXTERN WriteFile

  SECTION .text
_main:
    ;align stack to 16 bytes for Win64 calls
    and rsp, -10h

    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, message
    mov r8, msglen
    xor r9, r9
    push r9
    call WriteFile
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret

  SECTION .data
    message db 'Hello, World', 10
    msglen equ $-message
