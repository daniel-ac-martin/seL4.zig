const c = @import("../c-library.zig");
const seL4 = @import("../common.zig");

// const format = @import("std").fmt.format;
// const DebugWriter = struct {
//     const Self = @This();
//     pub fn writeAll(self: Self, bytes: []const u8) Error!void {
//         _ = self;
//         return debugPutString(bytes);
//     }
//     pub const Error = error{ Foo, Bar };
// };
// const debugWriter: DebugWriter = .{};

// fn debugWriteAll(fmt: []const u8) !void {
//     return debugPutString(fmt);
// }

const std = @import("std");
const format = std.fmt.format;
const Writer = std.io.Writer;

const DebugWriteError = error{};
const DebugWriteContext = struct {};

pub inline fn putChar(ch: u8) void {
    if (@hasDecl(c, "seL4_DebugPutChar")) {
        return c.seL4_DebugPutChar(ch);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn putString(s: []const u8) void {
    for (s) |ch| {
        putChar(ch);
    }
}

fn debugWriteFn(context: DebugWriteContext, bytes: []const u8) DebugWriteError!usize {
    _ = context;
    putString(bytes);
    return bytes.len;
}

const DebugWriter = Writer(DebugWriteContext, DebugWriteError, debugWriteFn);
const debugWriter: DebugWriter = .{ .context = .{} };

pub fn print(comptime fmt: []const u8, args: anytype) void {
    _ = format(debugWriter, fmt, args) catch noreturn;
}

// Inspired by: https://github.com/seL4/seL4_libs/blob/master/libsel4debug/src/bootinfo.c
pub fn printBootInfo(boot_info: *seL4.BootInfo) void {
    print("Node {d} of {d}\n", .{ boot_info.*.nodeID, boot_info.*.numNodes });
    print("IOPT levels:     {d}\n", .{boot_info.*.numIOPTLevels});
    print("IPC buffer:      {}\n", .{boot_info.*.ipcBuffer.*});
    print("\n", .{});
    print("sharedFrames:    [{d} --> {d})\n", .{ boot_info.*.sharedFrames.start, boot_info.*.sharedFrames.end });
    print("ioSpaceCaps:     [{d} --> {d})\n", .{ boot_info.*.ioSpaceCaps.start, boot_info.*.ioSpaceCaps.end });
    print("schedcontrol:    [{d} --> {d})\n", .{ boot_info.*.schedcontrol.start, boot_info.*.schedcontrol.end });
    print("userImagePaging: [{d} --> {d})\n", .{ boot_info.*.userImagePaging.start, boot_info.*.userImagePaging.end });
    print("extraBIPages:    [{d} --> {d})\n", .{ boot_info.*.extraBIPages.start, boot_info.*.extraBIPages.end });
    print("userImageFrames: [{d} --> {d})\n", .{ boot_info.*.userImageFrames.start, boot_info.*.userImageFrames.end });
    print("untypeds:        [{d} --> {d})\n", .{ boot_info.*.untyped.start, boot_info.*.untyped.end });
    print("Empty slots:     [{d} --> {d})\n", .{ boot_info.*.empty.start, boot_info.*.empty.end });
    print("\n", .{});
    print("Initial thread domain: {d}\n", .{boot_info.*.initThreadDomain});
    print("Initial thread cnode size: {d}\n", .{boot_info.*.initThreadCNodeSizeBits});
    print("\n", .{});
    print("List of untypeds\n", .{});
    print("----------------\n", .{});
    print("{s:3}: {s:12} | {s:4} | {s:6}\n", .{ "No", "Paddr", "Size", "Device" });
    print("------------------| ---- | ------\n", .{});

    const first_untyped = boot_info.*.untyped.start;
    const last_untyped = boot_info.*.untyped.end;
    const untyped_num = last_untyped - first_untyped;

    var sizes = [_]u64{0} ** 256;

    for (boot_info.*.untypedList[0..untyped_num], 0..) |v, i| {
        const index = v.sizeBits;
        sizes[index] += 1;
        print("{:3}: {x:12} | {:4} | {d:6}\n", .{ i + first_untyped, boot_info.*.untypedList[i].paddr, v.sizeBits, v.isDevice });
    }

    print("Untyped summary\n", .{});

    for (sizes, 0..) |v, i| {
        if (v != 0) {
            print("{d} untypeds of size {d}\n", .{ v, i });
        }
    }
}

pub inline fn dumpScheduler() void {
    if (@hasDecl(c, "seL4_DebugDumpScheduler")) {
        return c.seL4_DebugDumpScheduler();
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn halt() void {
    if (@hasDecl(c, "seL4_DebugHalt")) {
        return c.seL4_DebugHalt();
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn snapshot() void {
    if (@hasDecl(c, "seL4_DebugSnapshot")) {
        return c.seL4_DebugSnapshot();
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn capIdentify(cap: seL4.CPtr) u32 {
    if (@hasDecl(c, "seL4_DebugCapIdentify")) {
        return c.seL4_DebugCapIdentify(cap);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nameThread(tcb: seL4.CPtr, name: []const u8) void {
    if (@hasDecl(c, "seL4_DebugNameThread")) {
        return c.seL4_DebugNameThread(tcb, name);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}
