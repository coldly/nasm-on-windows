[BITS 64]

  GLOBAL _main
  EXTERN ExitProcess
  EXTERN GetStdHandle
  EXTERN WriteFile

  SECTION .text
_main:
    mov rcx, 0fffffff5h   ;STD_OUTPUT_HANDLE
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
