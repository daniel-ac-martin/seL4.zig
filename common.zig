const c = @import("./c-library.zig");

pub const CNode = c.seL4_CNode;
pub const CPtr = c.seL4_CPtr;
pub const Word = c.seL4_Word;

pub const MessageInfo = c.seL4_MessageInfo_t;

pub const BootInfo = c.seL4_BootInfo;
