const c = @import("./c-library.zig");
const seL4 = @import("./common.zig");

const TCB = seL4.CPtr;

// Thread Control Block (TCB) API

pub fn suspendThread(service: TCB) seL4.Error {
    return @enumFromInt(c.seL4_TCB_Suspend(service));
}
