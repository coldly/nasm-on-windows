[BITS 64]
  DEFAULT REL

  GLOBAL _main
  EXTERN CloseHandle
  EXTERN CreateProcessA
  EXTERN ExitProcess
  EXTERN GetCommandLineA
  EXTERN GetLastError
  EXTERN GetStdHandle
  EXTERN WaitForSingleObject
  EXTERN WriteFile

  SECTION .data
    sUsage db 'USAGE: exec mycmd [cmdarg]...',10,'Executes the program specified and waits for the spawned process to exit.',10
    lUsage equ $-sUsage
    sError db 'CreateProcess failed.',10
    lError equ $-sError
    startinfo:
      dd 060h
      times 23 dq 0
    procinfo:
      hproc dq 0
      hthread dq 0
      times 2 dd 0

  SECTION .bss
    stdout resq 1


  SECTION .text
_main:
    ;align stack to 16 bytes for Win64 calls
    and rsp, -10h
    ;give room to Win64 API calls that don't take stack params
    sub rsp, 020h

    mov rcx, -0Bh   ;STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [stdout], rax

    call GetCommandLineA
    mov rsi, rax
    mov rdi, rax
    call strlen_v3
    mov rdi, rsi
    call finddblsp
    cmp rdi, 0
    jz .usage

    lea rax, [rel procinfo]
    push rax
    lea rax, [rel startinfo]
    push rax
    push 0
    push 0
    push 0
    push 0
    xor r9, r9
    xor r8, r8
    mov edx, edi
    xor ecx, ecx
    sub rsp, 20h ;Give Win64 API calls room
    call CreateProcessA
    add rsp, 50h ;Restore Stack Pointer
    cmp rax, 0
    jz .error

    mov rcx, [hproc]
    mov rdx, -1
    call WaitForSingleObject
    mov rcx, [hproc]
    call CloseHandle
    mov rcx, [hthread]
    call CloseHandle
    mov rcx, 0
    call ExitProcess
    xor rax, rax
    ret
.error:
    call GetLastError
    mov rbx, rax
    mov rcx, [stdout]
    mov rdx, sError
    mov r8, lError
    xor r9, r9
    push r9
    sub rsp, 20h ;Give Win64 API calls room
    call WriteFile
    add rsp, 28h ;Restore Stack Pointer
    mov rcx, rbx
    call ExitProcess
    mov rax, rbx
    ret
.usage:
    mov rcx, [stdout]
    mov rdx, sUsage
    mov r8, lUsage
    xor r9, r9
    push r9
    sub rsp, 20h ;Give Win64 API calls room
    call WriteFile
    add rsp, 28h ;Restore Stack Pointer
    mov rcx, 0
    call ExitProcess
    mov rax, 2
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; finddblsp                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:                                     ;
;   Finds the first occurance of 2 spaces (ASCII   ;
;   code 020h) in a row. Function stops searching  ;
;   after looking at RCX bytes. Very inefficient.  ;
;                                                  ;
; Usage and Effects:                               ;
;   RAX: DESTROYED upon return.                    ;
;   RCX: Length of string to search. Length of     ;
;        substring upon return.                    ;
;   RDI: Pointer to the input string on function   ;
;        call. Points to the character immediately ;
;        following the double space upon return if ;
;        found. 0 upon return if not found.        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
finddblsp:
    cmp rcx, 1
    jle .notfound
    cmp word [rdi], 02020h
    jz .found
    dec rcx
    inc rdi
    jmp finddblsp
.notfound:
    xor rdi, rdi
    ret
.found:
    inc rdi
    inc rdi
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
