[BITS 32]

  GLOBAL _main
  EXTERN _CloseHandle@4
  EXTERN _CreateProcessA@40
  EXTERN _ExitProcess@4
  EXTERN _GetCommandLineA@0
  EXTERN _GetLastError@0
  EXTERN _GetStdHandle@4
  EXTERN _WaitForSingleObject@8
  EXTERN _WriteFile@20

  SECTION .data
    sUsage db 'USAGE: exec mycmd [cmdarg]...',10,'Executes the program specified and waits for the spawned process to exit.',10
    lUsage equ $-sUsage
    sError db 'CreateProcess failed.',10
    lError equ $-sError
    startinfo:
      dd 044h
      times 16 dd 0
    procinfo:
      hproc dd 0
      hthread dd 0
      times 2 dd 0

  SECTION .bss
    stdout resd 1

  SECTION .text
_main:
    push -0Bh   ;STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov [stdout], eax

    call _GetCommandLineA@0
    mov esi, eax
    mov edi, eax
    call strlen_v3
    mov edi, esi
    call finddblsp
    cmp edi, 0
    jz .usage

    push procinfo
    push startinfo
    push 0
    push 0
    push 0
    push 0
    push 0
    push 0
    push edi
    push 0
    call _CreateProcessA@40
    cmp eax, 0
    jz .error

    mov ebx, [hproc]
    mov edx, [hthread]
    push -1
    push ebx
    call _WaitForSingleObject@8
    push ebx
    call _CloseHandle@4
    push edx
    call _CloseHandle@4
    push 0
    call _ExitProcess@4
    xor eax, eax
    ret
.error:
    call _GetLastError@0
    mov ebx, eax
    mov eax, [stdout]
    push 0
    push 0
    push lError
    push sError
    push eax
    call _WriteFile@20
    push ebx
    call _ExitProcess@4
    mov eax, ebx
    ret
.usage:
    mov eax, [stdout]
    push 0
    push 0
    push lUsage
    push sUsage
    push eax
    call _WriteFile@20
    push 2
    call _ExitProcess@4
    mov eax, 2
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; finddblsp                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Finds the first occurance of 2 spaces (ASCII   ;
;   code 020h) in a row. Function stops searching  ;
;   after looking at ECX bytes. Very inefficient.  ;
;                                                  ;
; Usage and Effects:                               ;
;   EAX: DESTROYED upon return.                    ;
;   ECX: Length of string to search. Length of     ;
;        substring upon return.                    ;
;   EDI: Pointer to the input string on function   ;
;        call. Points to the character immediately ;
;        following the double space upon return if ;
;        found. 0 upon return if not found.        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finddblsp:
    cmp ecx, 1
    jle .notfound
    cmp word [edi], 02020h
    jz .found
    dec ecx
    inc edi
    jmp finddblsp
.notfound:
    xor edi, edi
    ret
.found:
    inc edi
    inc edi
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
