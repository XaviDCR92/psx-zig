export fn __start() void {
    {
        const sz = @ptrToInt(&__bss_end) - @ptrToInt(&__bss_start);
        @memset(@ptrCast([*]u8, &__bss_start), 0, sz);
    }
    main();
}

extern var __bss_end: u8;
extern var __bss_start: u8;

pub fn puts(str: [*:0]const u8) c_int {
    return asm volatile (
        \\ li $9, 0x3e
        \\ j 0xa0
        \\ nop
        : [ret] "={r2}" (-> c_int)
        : [str] "{r4}" (str)
    );
}

fn main() noreturn {
    while (true) {
        _ = puts("yo");
    }
}

//const builtin = @import("builtin");
//pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
    //while (true) {}
//}
