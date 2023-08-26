ENTRY(_start)

PHDRS
{
    headers PT_PHDR PHDRS ;
    text PT_LOAD FILEHDR PHDRS ;
    rodata PT_LOAD ;
    data PT_LOAD ;
    gnu_stack PT_GNU_STACK ;
}

SECTIONS
{
    . = SIZEOF_HEADERS;

    .text : ALIGN(4K)
    {
        _text = . ;
        *(.text .text.*)
        _text_end = . ;
    } :text

    .rodata : ALIGN(4K)
    {
        _rodata = . ;
        *(.rodata .rodata.*)
        _rodata_end = . ;
    } :rodata

    .data : ALIGN(4K)
    {
        _data = . ;
        *(.data .data.*)
        _data_end = . ;
    } :data

    .tdata : ALIGN(4K)
    {
        _tdata = . ;
        *(.tdata .tdata.*)
        _tdata_end = . ;
    } :data

    .bss : ALIGN(4K)
    {
        _bss = . ;
        *(COMMON)
        *(.bss .bss.*)
        _bss_end = . ;
    } :data

    .tbss : ALIGN(4K)
    {
        _tbss = . ;
        *(.tbss .tbss.*)
        *(.tcommon .tcommon.*)
        _tbss_end = . ;
    } :data

    .note.GNU-stack (NOLOAD):
    {
        *(.note.GNU-stack)
    } : gnu_stack
}
