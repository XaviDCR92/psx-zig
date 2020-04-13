pub const Data = packed struct {
    reserved: u24,
    cmd: enum(u8) {
        GP0,
        GP1
    }
};

pub const data = @intToPtr(*volatile Data, 0x1f801810);
pub const ctrl = @intToPtr(*volatile u32, 0x1f801814);
