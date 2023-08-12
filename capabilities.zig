const seL4 = @import("./common.zig");
const sys = @import("./syscalls.zig");
const thread = @import("./thread.zig");

// This file provides ...

const Untyped = seL4.CPtr;
const TCB = seL4.CPtr;
const X86Page = seL4.CPtr;
const X86PDPT = seL4.CPtr;
const X86PageDirectory = seL4.CPtr;
const X86PageTable = seL4.CPtr;
const X64PML4 = seL4.CPtr; // Should this even be defined?

pub const Caps = enum(seL4.CPtr) {
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
    capInitThreadSC = 14,
    numInitialCaps = 15,
};

pub const CapRights = extern struct {
    words: [1]seL4.Word,
};

pub fn capRightsNew(capAllowGrantReply: seL4.Word, capAllowGrant: seL4.Word, capAllowRead: seL4.Word, capAllowWrite: seL4.Word) CapRights {
    var capRights: CapRights = undefined;

    capRights.words[0] = 0 | (capAllowGrantReply & 0x1) << 3 | (capAllowGrant & 0x1) << 2 | (capAllowRead & 0x1) << 1 | (capAllowWrite & 0x1) << 0;

    return capRights;
}

pub const readWrite = capRightsNew(0, 0, 1, 1);
pub const allRights = capRightsNew(1, 1, 1, 1);
pub const canRead = capRightsNew(0, 0, 1, 0);
pub const canWrite = capRightsNew(0, 0, 0, 1);
pub const canGrant = capRightsNew(0, 1, 0, 0);
pub const canGrantReply = capRightsNew(1, 0, 0, 0);
pub const noWrite = capRightsNew(1, 1, 1, 0);
pub const noRead = capRightsNew(1, 1, 0, 1);
pub const noRights = capRightsNew(0, 0, 0, 0);

const InvocationLabel = enum(seL4.Word) {
    invalidInvocation = 0,
    untypedRetype = 1,
    tCBReadRegisters = 2,
    tCBWriteRegisters = 3,
    tCBCopyRegisters = 4,
    tCBConfigure = 5,
    tCBSetPriority = 6,
    tCBSetMCPriority = 7,
    tCBSetSchedParams = 8,
    tCBSetTimeoutEndpoint = 9,
    tCBSetIPCBuffer = 10,
    tCBSetSpace = 11,
    tCBSuspend = 12,
    tCBResume = 13,
    tCBBindNotification = 14,
    tCBUnbindNotification = 15,
    tCBSetTLSBase = 16,
    cNodeRevoke = 17,
    cNodeDelete = 18,
    cNodeCancelBadgedSends = 19,
    cNodeCopy = 20,
    cNodeMint = 21,
    cNodeMove = 22,
    cNodeMutate = 23,
    cNodeRotate = 24,
    iRQIssueIRQHandler = 25,
    iRQAckIRQ = 26,
    iRQSetIRQHandler = 27,
    iRQClearIRQHandler = 28,
    domainSetSet = 29,
    schedControlConfigureFlags = 30,
    schedContextBind = 31,
    schedContextUnbind = 32,
    schedContextUnbindObject = 33,
    schedContextConsumed = 34,
    schedContextYieldTo = 35,
    x86PDPTMap = 36,
    x86PDPTUnmap = 37,
    //nSeL4ArchInvocationLabels = 38,
    x86PageDirectoryMap = 38,
    x86PageDirectoryUnmap = 39,
    x86PageTableMap = 40,
    x86PageTableUnmap = 41,
    x86PageMap = 42,
    x86PageUnmap = 43,
    x86PageGetAddress = 44,
    x86ASIDControlMakePool = 45,
    x86ASIDPoolAssign = 46,
    x86IOPortControlIssue = 47,
    x86IOPortIn8 = 48,
    x86IOPortIn16 = 49,
    x86IOPortIn32 = 50,
    x86IOPortOut8 = 51,
    x86IOPortOut16 = 52,
    x86IOPortOut32 = 53,
    x86IRQIssueIRQHandlerIOAPIC = 54,
    x86IRQIssueIRQHandlerMSI = 55,
    nArchInvocationLabels = 56,
};

pub const ObjectType = enum(seL4.Word) {
    untypedObject = 0,
    tCBObject = 1,
    endpointObject = 2,
    notificationObject = 3,
    capTableObject = 4,
    schedContextObject = 5,
    replyObject = 6,
    //nonArchObjectTypeCount = 7,
    x86PDPTObject = 7,
    x64PML4Object = 8,
    x64HugePageObject = 9,
    //modeObjectTypeCount = 10,
    x864K = 10,
    x86LargePageObject = 11,
    x86PageTableObject = 12,
    x86PageDirectoryObject = 13,
    objectTypeCount = 14,
};

pub const X86VMAttributes = enum(seL4.Word) {
    writeBack = 0,
    writeThrough = 1,
    cacheDisabled = 2,
    uncacheable = 3,
    writeCombining = 4,
};
pub const x86DefaultVMAttributes = X86VMAttributes.writeBack;

pub fn tCBSuspend(service: TCB) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.tCBSuspend), 0, 0, 0);
    var mr0: seL4.Word = 0;
    var mr1: seL4.Word = 0;
    var mr2: seL4.Word = 0;
    var mr3: seL4.Word = 0;

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}

pub fn untypedRetype(service: Untyped, ctype: seL4.Word, size_bits: seL4.Word, root: seL4.CNode, node_index: seL4.Word, node_depth: seL4.Word, node_offset: seL4.Word, num_objects: seL4.Word) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.untypedRetype), 0, 1, 6);
    var mr0: seL4.Word = ctype;
    var mr1: seL4.Word = size_bits;
    var mr2: seL4.Word = node_index;
    var mr3: seL4.Word = node_depth;

    thread.setCap(0, root);
    thread.setMR(4, node_offset);
    thread.setMR(5, num_objects);

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}

pub fn x86PDPTMap(service: X86PDPT, pml4: X64PML4, vaddr: seL4.Word, attr: X86VMAttributes) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.x86PDPTMap), 0, 1, 2);
    var mr0: seL4.Word = vaddr;
    var mr1: seL4.Word = @intFromEnum(attr);
    var mr2: seL4.Word = 0;
    var mr3: seL4.Word = 0;

    thread.setCap(0, pml4);

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}

pub fn x86PageDirectoryMap(service: X86PageDirectory, vspace: seL4.CPtr, vaddr: seL4.Word, attr: X86VMAttributes) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.x86PageDirectoryMap), 0, 1, 2);
    var mr0: seL4.Word = vaddr;
    var mr1: seL4.Word = @intFromEnum(attr);
    var mr2: seL4.Word = 0;
    var mr3: seL4.Word = 0;

    thread.setCap(0, vspace);

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}

pub fn x86PageTableMap(service: X86PageTable, vspace: seL4.CPtr, vaddr: seL4.Word, attr: X86VMAttributes) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.x86PageTableMap), 0, 1, 2);
    var mr0: seL4.Word = vaddr;
    var mr1: seL4.Word = @intFromEnum(attr);
    var mr2: seL4.Word = 0;
    var mr3: seL4.Word = 0;

    thread.setCap(0, vspace);

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}

pub fn x86PageMap(service: X86Page, vspace: seL4.CPtr, vaddr: seL4.Word, rights: CapRights, attr: X86VMAttributes) seL4.Error {
    const tag: seL4.MessageInfo = seL4.messageInfoNew(@intFromEnum(InvocationLabel.x86PageMap), 0, 1, 3);
    var mr0: seL4.Word = vaddr;
    var mr1: seL4.Word = rights.words[0];
    var mr2: seL4.Word = @intFromEnum(attr);
    var mr3: seL4.Word = 0;

    thread.setCap(0, vspace);

    const output_tag: seL4.MessageInfo = sys.callWithMRs(service, tag, &mr0, &mr1, &mr2, &mr3);
    const result: seL4.Error = @enumFromInt(seL4.messageInfoGetLabel(output_tag));

    if (result != .noError) {
        thread.setMR(0, mr0);
        thread.setMR(1, mr1);
        thread.setMR(2, mr2);
        thread.setMR(3, mr3);
    }

    return result;
}
