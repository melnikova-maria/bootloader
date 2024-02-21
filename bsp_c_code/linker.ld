ENTRY(entry);  /* В принципе в этом нет необходимости */

PHDRS
{
    load PT_LOAD;
}

SECTIONS
{
    . = 0x0;  /* Поскольку будет использоваться PIC - адресация с 0 */

    /* Код загрузки, собираемый из асемблера */
    /* Код должен строго идти первым, чтобы линкер его так и раположил, а
       по нулевому адресу там находится точка входа - entry */
    .text          : { *init.o(.text) } : load

    /* Си-код */
    .text ALIGN(8) : { *(.text)   } : load
    .text ALIGN(8) : { *(.rodata) } : load
    .text ALIGN(8) : { *(.data)   } : load
    .text ALIGN(8) : { *(.bss)    } : load

    /DISCARD/      : { *(.comment) }
}
