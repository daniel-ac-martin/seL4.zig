pub usingnamespace @import("./c-library.zig");

pub usingnamespace @import("./common.zig");
pub usingnamespace @import("./syscalls.zig");

pub const cap = @import("./cap.zig");
pub const tcb = @import("./tcb.zig");

const bi = @import("./bootinfo.zig");

pub const getBootInfo = bi.getBootInfo;

usingnamespace @import("./entrypoints.zig");
