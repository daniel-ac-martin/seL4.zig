const c = @import("./c-library.zig");
const seL4 = @import("./common.zig");

pub fn getBootInfo() *seL4.BootInfo {
    return c.seL4_GetBootInfo();
}
