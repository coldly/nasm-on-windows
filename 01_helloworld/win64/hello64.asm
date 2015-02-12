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
    ;give room to Win64 API calls that don't take stack params
    sub rsp, 020h

    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, message
    mov r8, msglen
    xor r9, r9
    push r9
    sub rsp, 20h ;Give Win64 API calls room
    call WriteFile
    add rsp, 28h ;Restore Stack Pointer
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret

  SECTION .data
    message db 'Hello, World', 10
    msglen equ $-message
