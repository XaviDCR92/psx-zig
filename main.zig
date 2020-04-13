// I do not know why, but even if _start is the entry point it
// must be placed into a separate section...
extern var __bss_end: u8;
extern var __bss_start: u8;

export fn _start() linksection(".main") noreturn {
    asm volatile (
        \\ li $29, 0x801fff00
        \\ li $k1, 0x1f800000
    );

    {
        const sz = @ptrToInt(&__bss_end) - @ptrToInt(&__bss_start);
        @memset(@ptrCast([*]u8, &__bss_start), 0, sz);
    }

    main();
}

usingnamespace @import("gpu.zig");
usingnamespace @import("puts.zig");

fn main() noreturn {
    {
        const fmt = @import("fmt/fmt.zig");
        _ = puts(fmt.fmtZ("{}", .{"hello world!"}));
    }

    const gpu: Gpu = undefined;
    const cfg = Gpu.Cfg {.w = 320, .h = 240};
    gpu.init(cfg) catch {_ = puts(fmt.fmtZ("gpu init fail"));};

    while (true) {
    }
}
