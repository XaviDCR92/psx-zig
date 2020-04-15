/*
 * Linker script to generate an ELF file
 * that has to be converted to PS-X EXE.
 */

MEMORY {
    ram	(rwx) : ORIGIN = 0x80010000, LENGTH = 2M
}

OUTPUT_FORMAT("elf32-tradlittlemips")
OUTPUT_ARCH("mips")
ENTRY(start)

SECTIONS
{
	. = ORIGIN(ram);
	.text ALIGN(4) :
	{
		KEEP(*(.main))
		*(.text*)
	} >ram

	.MIPS.abiflags   : { *(.MIPS.abiflags) } > ram
  	.reginfo         : { *(.reginfo) } > ram


	.rodata ALIGN(4) :
	{
		*(.rodata)
	} >ram AT>ram

	.data ALIGN(4) :
	{
		 *(.data)
	} >ram

	.ctors ALIGN(4) :
	{
		*(.ctors)
	} >ram

	.dtors ALIGN(4) :
 	{
		*(.dtors)
	} >ram

	.bss  ALIGN(4) :
	{
		*(.bss)
	} >ram

	__text_start = ADDR(.text);
	__text_end = ADDR(.text) + SIZEOF(.text);

	__rodata_start = ADDR(.rodata);
	__rodata_end = ADDR(.rodata) + SIZEOF(.rodata);

	__data_start = ADDR(.data);
	__data_end = ADDR(.data) + SIZEOF(.data);

	__bss_start = ADDR(.bss);
	__bss_end = ADDR(.bss) + SIZEOF(.bss);

	__scratchpad = 0x1f800000;
}

