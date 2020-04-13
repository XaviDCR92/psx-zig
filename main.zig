// I do not know why, but even if _start is the entry point it
// must be placed into a separate section...
extern var __bss_end: u8;
extern var __bss_start: u8;

export fn _start() linksection(".main") noreturn {
    {
        const sz = @ptrToInt(&__bss_end) - @ptrToInt(&__bss_start);
        @memset(@ptrCast([*]u8, &__bss_start), 0, sz);
    }

    main();
}

pub fn puts(str: [*:0]const u8) c_int {
    return asm volatile (
        \\ li $9, 0x3f
        \\ j 0xa0
        \\ nop
        : [ret] "={r2}" (-> c_int)
        : [str] "{r4}" (str)
    );
}

fn main() noreturn {
    while (true) {
        const fmt = @import("fmt/fmt.zig");

        _ = puts(fmt.fmtZ("{}, {}", .{"hello world!", 34}));
        _ = puts(fmt.fmtZ("{}", .{694}));
    }
}
