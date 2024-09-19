OUTPUT_ARCH( "riscv" )

SECTIONS
{
    . = 0x00000000;
    . = ALIGN(0x1000);
    .text : {
        *(.text);
        FILL(0x00001300);
        . = 0xF800;
    }

    . = ALIGN(0xF800);
    .data : {
        *(.data)
    }
}
