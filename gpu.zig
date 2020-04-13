pub const Gpu = struct {
    pub const GpuCfg = struct {
        w: Pos,
        h: Pos
    };

    const Pos = u16;
    const Self = @This();
    const screen_widths = [_]Pos {320, 368};
    const screen_heights = [_]Pos {240};

    const DrawEnv = struct {
        width: Pos,
        height: Pos
    };

    pub fn init(self: Self, comptime cfg: GpuCfg) !void {
        comptime {
            var found: bool = undefined;

            for (screen_heights) |height| {
                if (height == cfg.h) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                @compileError("Invalid height");
            }

            found = false;

            for (screen_widths) |width| {
                if (width == cfg.w) {
                    return;
                }
            }

            if (!found) {
                @compileError("Invalid width");
            }
        }
    }
};
