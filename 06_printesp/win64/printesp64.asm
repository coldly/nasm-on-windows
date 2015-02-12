[BITS 64]
  DEFAULT REL

  GLOBAL _main
  EXTERN ExitProcess
  EXTERN GetStdHandle
  EXTERN WriteFile

  SECTION .bss
    sHex: resb 8
    lHex equ $-sHex
    sHex_end equ sHex+lHex-1

  SECTION .text
_main:
    ;align stack to 16 bytes for Win64 calls
    and rsp, -10h
    ;give room to Win64 API calls that don't take stack params
    sub rsp, 020h

    call print_esp
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_esp                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Prints the contents of ESP to STDOUT. Intended ;
;   for debugging the stack. It does not take into ;
;   account the return address that's been PUSH'd  ;
;   onto the stack to make this function call.     ;
; Usage and Effects:                               ;
;   RAX: DESTROYED upon return.                    ;
;   RCX: DESTROYED upon return.                    ;
;   RDX: DESTROYED upon return.                    ;
;   RDI: DESTROYED upon return.                    ;
;   RSI: DESTROYED upon return.                    ;
;    R8: DESTROYED upon return.                    ;
;    R9: DESTROYED upon return.                    ;
; Depends on:                                      ;
;   hex32tostr                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_esp:
    mov rsi, rsp
    mov rdi, sHex_end
    call hex32tostr
    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, sError
    mov r8, lError
    xor r9, r9
    push r9
    sub rsp, 20h ;Give Win64 API calls room
    call WriteFile
    add rsp, 28h ;Restore Stack Pointer
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
