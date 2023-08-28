const c = @import("./c-library.zig");

pub const CNode = c.seL4_CNode;
pub const CPtr = c.seL4_CPtr;
pub const Word = c.seL4_Word;

pub const MessageInfo = c.seL4_MessageInfo_t;

pub const BootInfo = c.seL4_BootInfo;

pub const Error = enum(c.seL4_Error) {
    noError = c.seL4_NoError,
    invalidArgument = c.seL4_InvalidArgument,
    invalidCapability = c.seL4_InvalidCapability,
    illegalOperation = c.seL4_IllegalOperation,
    rangeError = c.seL4_RangeError,
    alignmentError = c.seL4_AlignmentError,
    failedLookup = c.seL4_FailedLookup,
    truncatedMessage = c.seL4_TruncatedMessage,
    deleteFirst = c.seL4_DeleteFirst,
    revokeFirst = c.seL4_RevokeFirst,
    notEnoughMemory = c.seL4_NotEnoughMemory,
};
