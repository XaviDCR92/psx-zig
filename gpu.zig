pub const Pos = u16;
pub const VRAM_W: Pos = 1024;
pub const VRAM_H: Pos = 512;
usingnamespace @import("puts.zig");
const fmt = @import("fmt/fmt.zig");

pub const Gpu = struct {
    const port = @import("gpu/ports.zig");

    pub const Cfg = struct {
        x: Pos = 0,
        y: Pos = 0,
        w: Pos,
        h: Pos
    };

    const Self = @This();

    const DrawEnv = struct {
        width: Pos,
        height: Pos
    };

    fn initTexPage(self: Self) void {
        const TexPage = packed struct {
            x_base: u4 = 0,
            y_base: packed enum(u1) {
                YBase0,
                YBase256
            } = .YBase0,
            transparency: u2 = 0,
            tpage_colors: u2 = 0,
            dither: u1 = 0,
            draw_to_display: packed enum(u1) {
                Prohibited,
                Allowed
            } = .Prohibited,
            texture_disable: packed enum(u1) {
                Normal,
                Disable // If GP1(09h).Bit0 == 1
            } = .Normal,
            x_flip: u1 = 0,
            y_flip: u1 = 0,
            reserved: u10 = 0,
            command: u8 = 0xE1
        };

        port.data.cmd = .GP0;
        port.ctrl.* = @bitCast(u32, TexPage {});
    }

    fn initTextureWindow(self: Self) void {
        const TexWindow = packed struct {
            x: u5 = 0,
            y: u5 = 0,
            x_offset: u5 = 0,
            y_offset: u5 = 0,
            reserved: u4 = 0,
            cmd: u8 = 0
        };

        port.data.cmd = .GP0;
        port.ctrl.* = @bitCast(u32, TexWindow {});
    }

    fn initDrawingArea(self: Self, comptime w: Pos, comptime h: Pos) void {
        comptime {
            if (w >= VRAM_W) {
                @compileError("screen width exceeds VRAM width");
            }
            else if (h >= VRAM_H) {
                @compileError("screen height exceeds VRAM height");
            }
        }

        const DrawingArea = packed struct {
            x: u10 = 0,
            y: u9 = 0,
            reserved: u5 = 0,
            cmd: u8
        };

        const top_left = DrawingArea {
            .cmd = 0xE3
        };

        const bottom_right = DrawingArea {
            .x = @truncate(u10, w),
            .y = @truncate(u9, h),
            .cmd = 0xE4
        };

        port.data.cmd = .GP0;
        port.ctrl.* = @bitCast(u32, top_left);

        port.data.cmd = .GP0;
        port.ctrl.* = @bitCast(u32, bottom_right);
    }

    fn initDrawingAreaOffset(self: Self, comptime x: Pos, comptime y: Pos) void {
        comptime {
            if (x >= VRAM_W) {
                @compileError("invalid drawing area X offset");
            }
            else if (y >= VRAM_H) {
                @compileError("invalid drawing area Y offset");
            }
        }

        const DrawingAreaOffset = packed struct {
            x: u11 = x,
            y: u11 = y,
            reserved: u2 = 0,
            cmd: u8 = 0xE5
        };

        port.data.cmd = .GP0;
        port.ctrl.* = @bitCast(u32, DrawingAreaOffset{});
    }

    fn enableDisplay(self: Self) void {
        const DisplayEnable = packed struct {
            enable: packed enum(u1) {
                On,
                Off
            } = .On,
            reserved: u23 = 0,
            cmd: u8 = 0x03
        };

        port.data.cmd = .GP1;
        port.ctrl.* = @bitCast(u32, DisplayEnable{});
    }

    pub fn init(self: Self, comptime cfg: Cfg) !void {
        comptime {
            const screen_widths = [_]Pos {320, 368};
            const screen_heights = [_]Pos {240};

            blk: {
                for (screen_widths) |width| {
                    if (width == cfg.w) {
                        break :blk;
                    }
                }
                @compileError("Invalid width");
            }

            blk: {
                for (screen_heights) |height| {
                    if (height == cfg.h) {
                        break :blk;
                    }
                }
                @compileError("Invalid height");
            }
        }

        self.initTexPage();
        self.initTextureWindow();
        self.initDrawingArea(cfg.w, cfg.h);
        self.initDrawingAreaOffset(cfg.x, cfg.y);
        self.enableDisplay();
    }
};
