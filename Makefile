all:
	zig build-exe main.zig -target mipsel-freestanding-gnueabi -mcpu mips1+soft_float --linker-script playstation.x
	~/psxsdk/tools/elf2exe main zig.exe -mark_eur
