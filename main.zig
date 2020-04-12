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

fn fmtNum(num: u32, buffer: []u8) ![*:0]const u8 {
    const std = @import("std");
    const formatted = try std.fmt.bufPrint(buffer, "{}\n\x00", .{num});
    return @ptrCast([*:0]const u8, formatted.ptr);
}

fn main() noreturn {
    const a = 486;
    var buffer: [16]u8 = undefined;
    _ = puts("yo\n");
    _ = puts(fmtNum(a, &buffer) catch "error\n");
    _ = puts("num\n");
    _ = puts("num2\n");
    const b = puts(fmtNum(98, &buffer) catch "error\n");
    _ = puts(fmtNum(@intCast(u32, b), &buffer) catch "error\n");

    while (true) {}
}

//const builtin = @import("builtin");
//pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
//    while (true) {}
//}
