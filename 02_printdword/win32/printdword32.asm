[BITS 32]

  GLOBAL _main
  EXTERN _ExitProcess@4
  EXTERN _GetStdHandle@4
  EXTERN _WriteFile@20

  SECTION .bss
    sHexstring: resb 8
    lHexstring equ $-sHexstring
    sHexstring_end equ sHexstring+lHexstring-1

  SECTION .text
_main:
    mov edi, sHexstring_end
    mov esi, 0abc01234h
    call hex32tostr
    push -0Bh   ;STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    push 0
    push 0
    push lHexstring
    push sHexstring
    push eax
    call _WriteFile@20
    push 0
    call _ExitProcess@4
    xor eax, eax
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hex32tostr                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Takes a 32bit value and converts it to         ;
;   an ASCII string.                               ;
; Usage and Effects:                               ;
;   EAX: DESTROYED upon return.                    ;
;   ECX: DESTROYED upon return.                    ;
;   ESI: 32bit input value. DESTROYED upon return. ;
;   EDI: On function call, must be set to point to ;
;        the last character in the output buffer.  ;
;        Function will decrement EDI for each char ;
;        written, totalling 8 times. EDI will be   ;
;        pointing to the character preceding the   ;
;        start of the output buffer upon return.   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex32tostr:
    xor ecx, ecx
.loop:
    mov eax, esi
    and eax, dword 0fh
    add eax, 030h
    cmp eax, 039h
    jle .nonalpha
    add eax, 7
.nonalpha:
    mov byte [edi], al
    add ecx, 4
    dec edi
    shr esi, 4
    cmp ecx, 32
    jl .loop
    ret
