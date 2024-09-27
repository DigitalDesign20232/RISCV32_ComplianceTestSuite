OUTPUT_ARCH( "riscv" )

SECTIONS
{
    . = 0x00000000;
    .text : {
        FILL(0x13000000);
        . = 0x0080;
    }

    . = ALIGN(0x0080);
    .text : {
        *(.text);
        FILL(0x13000000);
        . = 0xF800;
    }

    . = ALIGN(0xF800);
    .data : {
        *(.data)
    }
}

