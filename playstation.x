/*
 * Linker script to generate an ELF file
 * that has to be converted to PS-X EXE.
 */

OUTPUT_FORMAT("elf32-tradlittlemips")
OUTPUT_ARCH("mips")

SECTIONS
{
	. = 0x80010000;

	.text ALIGN(4) :
	{
		*(.text*)
	}

	.rodata ALIGN(4) :
	{
		*(.rodata)
	}

	.data ALIGN(4) :
	{
		 *(.data)
	}

	.ctors ALIGN(4) :
	{
		*(.ctors)
	}

	.dtors ALIGN(4) :
 	{
		*(.dtors)
	}

	.bss  ALIGN(4) :
	{
		*(.bss)
	}

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

