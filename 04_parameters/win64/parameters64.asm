[BITS 64]
  DEFAULT REL

  GLOBAL _main
  EXTERN ExitProcess
  EXTERN GetCommandLineA
  EXTERN GetStdHandle
  EXTERN WriteFile

  SECTION .text
_main:
    ;align stack to 16 bytes for Win64 calls
    and rsp, -10h

    ;;; GetCommandLineA retrieves the cmdline as it was called. It
    ;;;   includes the program name as it was called (e.g. quotes,
    ;;;   relative/absolute path). 2 spaces (ASCII code 20h)
    ;;;   follow the program name. The cmdline is NULL terminated.
    call GetCommandLineA
    mov rsi, rax
    mov rdi, rax
    call strlen_v3
    mov rbx, rcx
    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, rsi
    mov r8, rbx
    xor r9, r9
    push r9
    call WriteFile
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strlen_v1                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Works like the C library function it's named   ;
;   after. Finds the length of a NULL terminated   ;
;   string. Version 1 (v1): This function is very  ;
;   inefficient by reading a single byte of the    ;
;   input string at a time rather than reading a   ;
;   QWORD at a time.                               ;
;                                                  ;
;   DANGER: This function doesn't place a limit on ;
;   the size of the string. If the string is not   ;
;   NULL terminated, this function will continue   ;
;   reading bytes of memory until an exception is  ;
;   thrown.                                        ;
;                                                  ;
; Usage and Effects:                               ;
;   RCX: Length of string upon return.             ;
;   RDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v1:
    xor rcx, rcx
.loop:
    cmp byte [rdi], 0
    jz .end
    inc rcx
    inc rdi
    jmp .loop
.end:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strlen_v2                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Works like the C library function it's named   ;
;   after. Finds the length of a NULL terminated   ;
;   string. Version 2 (v2): This function is more  ;
;   efficient than v1 by reading a QWORD at a time ;
;   from the input string.                         ;
;                                                  ;
;   DANGER: This function doesn't place a limit on ;
;   the size of the string. If the string is not   ;
;   NULL terminated, this function will continue   ;
;   reading bytes of memory until an exception is  ;
;   thrown.                                        ;
;                                                  ;
; Usage and Effects:                               ;
;   RCX: Length of string upon return.             ;
;   RDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;   RDX: DESTROYED upon return.                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v2:
    xor rcx, rcx
.loop:
    mov rdx, qword [rdi]
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    shr rdx, 8
    inc rcx
    inc rdi
    cmp dl, 0
    jz .end
    inc rcx
    inc rdi
    jmp .loop
.end:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strlen_v3                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Works like the C library function it's named   ;
;   after. Finds the length of a NULL terminated   ;
;   string. Version 3 (v3): This function is the   ;
;   same as v2 but makes use of the processor's    ;
;   REP prefix.                                    ;
;                                                  ;
;   DANGER: This function doesn't place a limit on ;
;   the size of the string. If the string is not   ;
;   NULL terminated, this function will continue   ;
;   reading bytes of memory until an exception is  ;
;   thrown.                                        ;
;                                                  ;
; Usage and Effects:                               ;
;   RAX: 0 upon return.                            ;
;   RCX: Length of string upon return.             ;
;   RDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v3:
    xor rax, rax
    mov rcx, -1
    cld
    repne scasb
    inc rcx
    inc rcx
    dec rdi
    neg rcx
    ret
