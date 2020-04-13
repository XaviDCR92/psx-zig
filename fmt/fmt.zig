var buffer: [64]u8 = undefined;

pub fn fmtZ(comptime s: []const u8, n: var) [*:0]const u8 {
    const std = @import("std");
    const formatted = std.fmt.bufPrint(&buffer, s ++ "\n\x00", n) catch "fmtZ error\n\x00";
    return @ptrCast([*:0]const u8, formatted.ptr);
}
