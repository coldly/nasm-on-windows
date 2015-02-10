[BITS 32]

  GLOBAL _main
  EXTERN _ExitProcess@4
  EXTERN _GetCommandLineA@0
  EXTERN _GetStdHandle@4
  EXTERN _WriteFile@20

  SECTION .text
_main:
    ;;; GetCommandLineA retrieves the cmdline as it was called. It
    ;;;   includes the program name as it was called (e.g. quotes,
    ;;;   relative/absolute path). 2 spaces (ASCII code 20h)
    ;;;   follow the program name. The cmdline is NULL terminated.
    call _GetCommandLineA@0
    mov esi, eax
    mov edi, eax
    call strlen_v3
    push -11D   ;STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    push 0
    push 0
    push ecx
    push esi
    push eax
    call _WriteFile@20
    push 0
    call _ExitProcess@4
    xor eax, eax
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
;   DWORD at a time.                               ;
;                                                  ;
;   DANGER: This function doesn't place a limit on ;
;   the size of the string. If the string is not   ;
;   NULL terminated, this function will continue   ;
;   reading bytes of memory until an exception is  ;
;   thrown.                                        ;
;                                                  ;
; Usage and Effects:                               ;
;   ECX: Length of string upon return.             ;
;   EDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v1:
    xor ecx, ecx
.loop:
    cmp byte [edi], 0
    jz .end
    inc ecx
    inc edi
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
;   efficient than v1 by reading a DWORD at a time ;
;   from the input string.                         ;
;                                                  ;
;   DANGER: This function doesn't place a limit on ;
;   the size of the string. If the string is not   ;
;   NULL terminated, this function will continue   ;
;   reading bytes of memory until an exception is  ;
;   thrown.                                        ;
;                                                  ;
; Usage and Effects:                               ;
;   ECX: Length of string upon return.             ;
;   EDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;   EDX: DESTROYED upon return.                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v2:
    xor ecx, ecx
.loop:
    mov edx, dword [edi]
    cmp dl, 0
    jz .end
    shr edx, 8
    inc ecx
    inc edi
    cmp dl, 0
    jz .end
    shr edx, 8
    inc ecx
    inc edi
    cmp dl, 0
    jz .end
    shr edx, 8
    inc ecx
    inc edi
    cmp dl, 0
    jz .end
    inc ecx
    inc edi
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
;   EAX: 0 upon return.                            ;
;   ECX: Length of string upon return.             ;
;   EDI: Pointer to the input string on function   ;
;        call. Points to input string's NULL       ;
;        terminator upon return.                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen_v3:
    xor eax, eax
    mov ecx, -1
    cld
    repne scasb
    inc ecx
    inc ecx
    dec edi
    neg ecx
    ret
