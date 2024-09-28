OUTPUT_ARCH( "riscv" )

/* Define memory regions */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 52K
    RAM   (rwx) : ORIGIN = 0x0000D000, LENGTH = 12K
}

BOOT_ADDR    = 0x00000000;
ENTRY_OFFSET = 0x00000080;

/* Define section placement */
SECTIONS
{
    /* Place the .text (code) section in Flash */

    .text :
    {
        . = BOOT_ADDR;
        FILL(0x13000000);      /* Fills memory with the value 0x13000000 */
        . = BOOT_ADDR + ENTRY_OFFSET;              /* Set the current location counter to 0x80 */

        *(.text)               /* All .text sections */
        *(.text.*)             /* All .text.* sections */

        FILL(0x13000000);      /* Fill remaining space with 0x13000000 */
        . = ORIGIN(FLASH) + LENGTH(FLASH);  /* Set the current location counter to the end of FLASH */
    } > FLASH

    /* Place the .data section at the end of RAM and grow downward */
    .data :
    {
        *(.data)
        *(.data.*)
    } > RAM
}
