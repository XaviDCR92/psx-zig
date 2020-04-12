var buffer: [32]u8 = undefined;

pub fn print(n: u32) ![*:0]const u8 {
    const std = @import("std");
    const formatted = try std.fmt.bufPrint(&buffer, "{}\n\x00", .{n});
    return @ptrCast([*:0]const u8, formatted.ptr);
}
