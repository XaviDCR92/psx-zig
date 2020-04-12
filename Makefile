all:
	zig build-exe main.zig -target mipsel-freestanding-gnueabi -mcpu mips1+soft_float --linker-script playstation.x
	~/psxsdk/tools/elf2exe main zig.exe -mark_eur
	mkdir -p cdimg/
	cp zig.exe cdimg/
	mkisofs -o zig.iso -V zig -sysid PLAYSTATION cdimg/
	mkpsxiso zig.iso zig.bin /usr/local/psxsdk/share/licenses/infoeur.dat -s
	pcsxr -nogui -psxout -cdfile zig.cue
