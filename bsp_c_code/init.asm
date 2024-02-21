extern main  ; Точка входа в код на Си

global entry  ; Точка входа, чтобы линкер её нашел

segment .text

[bits 64]
; Точка входа в весь код, после управление передается в main
entry:

    ; Необходимо настроить стек
    mov rsp, 0x300
    mov rbp, rsp

    call main

    ; Зацикливаем, чтобы не произошел выход дальше
    jmp $

