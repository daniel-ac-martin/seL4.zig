const seL4 = @import("./common.zig");
const debugPrint = @import("./syscalls.zig").debugPrint;

const Caps = enum(u8) {
    capNull = 0,
    capInitThreadTCB = 1,
    capInitThreadCNode = 2,
    capInitThreadVSpace = 3,
    capIRQControl = 4,
    capASIDControl = 5,
    capInitThreadASIDPool = 6,
    capIOPortControl = 7,
    capIOSpace = 8,
    capBootInfoFrame = 9,
    capInitThreadIPCBuffer = 10,
    capDomain = 11,
    capSMMUSIDControl = 12,
    capSMMUCBControl = 13,
    numInitialCaps = 14,
};
const thread = @import("./thread.zig");

const NodeId = seL4.Word;
const Domain = seL4.Word;

const SlotPos = seL4.Word;
const SlotRegion = extern struct {
    start: SlotPos,
    end: SlotPos,
};
const UntypedDesc = extern struct {
    paddr: seL4.Word,
    sizeBits: u8,
    isDevice: u8,
    padding: [6]u8,
};

const maxUntyped = 230;

pub const BootInfo = extern struct {
    extraLen: seL4.Word,
    nodeID: NodeId,
    numNodes: seL4.Word,
    numIOPTLevels: seL4.Word,
    ipcBuffer: *seL4.IPCBuffer, //[*c]IPCBuffer,
    empty: SlotRegion,
    sharedFrames: SlotRegion,
    userImageFrames: SlotRegion,
    userImagePaging: SlotRegion,
    ioSpaceCaps: SlotRegion,
    extraBIPages: SlotRegion,
    initThreadCNodeSizeBits: seL4.Word,
    initThreadDomain: Domain,
    schedcontrol: SlotRegion, // MCS only
    untyped: SlotRegion,
    untypedList: [maxUntyped]UntypedDesc,
};

var __sel4_boot_info: *BootInfo = undefined;

pub fn getBootInfo() *BootInfo {
    return __sel4_boot_info;
}

pub fn setBootInfo(boot_info: *BootInfo) void {
    __sel4_boot_info = boot_info;
    thread.setIPCBuffer(boot_info.*.ipcBuffer);
}

// Inspired by: https://github.com/seL4/seL4_libs/blob/master/libsel4debug/src/bootinfo.c
pub fn debugPrintBootInfo(boot_info: *BootInfo) void {
    debugPrint("Node {d} of {d}\n", .{ boot_info.*.nodeID, boot_info.*.numNodes });
    debugPrint("IOPT levels:     {d}\n", .{boot_info.*.numIOPTLevels});
    debugPrint("IPC buffer:      {}\n", .{boot_info.*.ipcBuffer});
    debugPrint("\n", .{});
    debugPrint("sharedFrames:    [{d} --> {d})\n", .{ boot_info.*.sharedFrames.start, boot_info.*.sharedFrames.end });
    debugPrint("ioSpaceCaps:     [{d} --> {d})\n", .{ boot_info.*.ioSpaceCaps.start, boot_info.*.ioSpaceCaps.end });
    debugPrint("schedcontrol:     [{d} --> {d})\n", .{ boot_info.*.schedcontrol.start, boot_info.*.schedcontrol.end });
    debugPrint("userImagePaging: [{d} --> {d})\n", .{ boot_info.*.userImagePaging.start, boot_info.*.userImagePaging.end });
    debugPrint("extraBIPages:     [{d} --> {d})\n", .{ boot_info.*.extraBIPages.start, boot_info.*.extraBIPages.end });
    debugPrint("userImageFrames: [{d} --> {d})\n", .{ boot_info.*.userImageFrames.start, boot_info.*.userImageFrames.end });
    debugPrint("untypeds:        [{d} --> {d})\n", .{ boot_info.*.untyped.start, boot_info.*.untyped.end });
    debugPrint("Empty slots:     [{d} --> {d})\n", .{ boot_info.*.empty.start, boot_info.*.empty.end });
    debugPrint("\n", .{});
    debugPrint("Initial thread domain: {d}\n", .{boot_info.*.initThreadDomain});
    debugPrint("Initial thread cnode size: {d}\n", .{boot_info.*.initThreadCNodeSizeBits});
    debugPrint("\n", .{});
    debugPrint("List of untypeds\n", .{});
    debugPrint("----------------\n", .{});
    debugPrint("{s:3}: {s:12} | {s:4} | {s:6}\n", .{ "No", "Paddr", "Size", "Device" });
    debugPrint("------------------| ---- | ------\n", .{});

    const first_untyped = boot_info.*.untyped.start;
    const last_untyped = boot_info.*.untyped.end;
    const untyped_num = last_untyped - first_untyped;

    var sizes = [_]u64{0} ** 256;

    for (boot_info.*.untypedList[0..untyped_num], 0..) |v, i| {
        const index = v.sizeBits;
        sizes[index] += 1;
        debugPrint("{:3}: {x:12} | {:4} | {d:6}\n", .{ i + first_untyped, boot_info.*.untypedList[i].paddr, v.sizeBits, v.isDevice });
    }

    debugPrint("Untyped summary\n", .{});

    for (sizes, 0..) |v, i| {
        if (v != 0) {
            debugPrint("{d} untypeds of size {d}\n", .{ v, i });
        }
    }
}
