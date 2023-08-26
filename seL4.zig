pub usingnamespace @cImport({
    @cInclude("sel4/sel4.h");
});

// pub usingnamespace @import("./common.zig");
// pub usingnamespace @import("./bootinfo.zig");
// pub usingnamespace @import("./syscalls.zig");

// pub const thread = @import("./thread.zig");
// pub const capabilities = @import("./capabilities.zig");

usingnamespace @import("./entrypoints.zig");
