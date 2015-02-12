[BITS 64]
  DEFAULT REL

  GLOBAL _main
  EXTERN ExitProcess
  EXTERN GetStdHandle
  EXTERN WriteFile

  SECTION .bss
    sHexstring: resb 8
    lHexstring equ $-sHexstring
    sHexstring_end equ sHexstring+lHexstring-1

  SECTION .text
_main:
    ;align stack to 16 bytes for Win64 calls
    and rsp, -10h

    mov rdi, sHexstring_end
    mov rsi, 0abc01234h
    call hex32tostr
    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, sHexstring
    mov r8, lHexstring
    xor r9, r9
    push r9
    call WriteFile
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hex32tostr                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Takes a 32bit value and converts it to         ;
;   an ASCII string.                               ;
; Usage and Effects:                               ;
;   RAX: DESTROYED upon return.                    ;
;   RCX: DESTROYED upon return.                    ;
;   ESI: 32bit input value. DESTROYED upon return. ;
;   RDI: On function call, must be set to point to ;
;        the last character in the output buffer.  ;
;        Function will decrement EDI for each char ;
;        written, totalling 8 times. EDI will be   ;
;        pointing to the character preceding the   ;
;        start of the output buffer upon return.   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex32tostr:
    xor rcx, rcx
.loop:
    mov rax, rsi
    and rax, qword 0fh
    add rax, 030h
    cmp rax, 039h
    jle .nonalpha
    add rax, 7
.nonalpha:
    mov byte [rdi], al
    add rcx, 4
    dec rdi
    shr rsi, 4
    cmp rcx, 32
    jl .loop
    ret
