org 0x9000
use16

; открытие линии А20 для 32-битной системы
    in  al, 0x92
    or  al, 0x02
    out 0x92, al

    lgdt [GDTR]
	
; запрет всех прерываний
    cli

    in  al, 0x70
    or  al, 0x80
    out 0x70, al

; переключение в защищенный режим
    mov eax, cr0
    or  al , 0x01
    mov cr0, eax

    jmp 0x8:PROT_MODE

GDT:
  D_NULL   db 8 dup(0)
  D_CODE   db 0xFF, 0xFF, 0x00, 0x00, 0x00, 10011010b, 11001111b, 0x00 ; 0x08
  D_DATA   db 0xFF, 0xFF, 0x00, 0x00, 0x00, 10010010b, 11001111b, 0x00 ; 0x10
  D_CODE64 db 0x00, 0x00, 0x00, 0x00, 0x00, 10011010b, 00100000b, 0x00 ; 0x18
  D_DATA64 db 0x00, 0x00, 0x00, 0x00, 0x00, 10010010b, 00100000b, 0x00 ; 0x20
  GDT_SIZE equ $-GDT

GDTR:
  dw GDT_SIZE
  dd GDT

use32
PROT_MODE:
    mov ax, 0x10
    mov ds, ax
    mov es, ax

; выставляется бит PAE (бит, отвечающий за long Mode) в регистре CR4
    mov eax, cr4
    bts eax, 5 ; CR4-PAE
    mov cr4, eax

; очистка пространства памяти под таблицы страниц
    mov edi, 0x100000
    mov ecx, 0x0C0000
    xor eax, eax
    clear_all:
        mov dword[es:edi], eax
		add edi, 8
    loop clear_all

; PML4E
    mov dword[0x100000], 0x110000 + 111b

; PDPTE (4GB memory/1 GB catalogue = 4 catalogues)
    mov dword[0x110000], 0x120000 + 111b 
    mov dword[0x110008], 0x121000 + 111b 
    mov dword[0x110010], 0x122000 + 111b 
    mov dword[0x110018], 0x123000 + 111b 

; PDE (4GB memory/2MB pages = 2048 pages = 0x800)
    mov edi, 0x120000 ; адрес 1-го каталога страниц
    mov eax, 0x0 + 10000111b 
    mov ecx, 0x800 
    generate_ptes:
        mov dword[es:edi], eax
        add edi, 0x8 
        add eax, 0x200000 
    loop generate_ptes

; загрузка PML4 в CR3
    mov eax, 0x100000
    mov cr3, eax

; установка бита LME в регистре IA32_EFER
    mov ecx, 0x0C0000080 ; EFER
    rdmsr
    bts eax, 8 ; EFER.LME
    wrmsr
; включение страничной адресации (бит PG в регистре CR0)
    mov eax, cr0
    bts eax, 31 ; CR0-PG
    mov cr0, eax

    jmp 0x18:LONG_MODE64
LONG_MODE64:
use64
    mov ax, 0x20
    mov ds, ax
    mov es, ax

    lgdt [0x9500] ; загружаем основную GDT, у которой GDTR расположен по адресу 0x9500
metka:
    mov rax, qword[0x308]
    inc rax
    mov qword[0x308], rax

    jmp $
