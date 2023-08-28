const c = @import("./c-library.zig");
const seL4 = @import("./common.zig");

pub const debug = @import("./syscalls/debug.zig");

// This file provides the seL4 system call API

pub inline fn call(dest: seL4.CPtr, msgInfo: seL4.MessageInfo) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_Call")) {
        return c.seL4_Call(dest, msgInfo);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn callWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, mr0: ?*seL4.Word, mr1: ?*seL4.Word, mr2: ?*seL4.Word, mr3: ?*seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_CallWithMRs")) {
        return c.seL4_CallWithMRs(dest, msgInfo, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

// Not for MCS, AKA 'seL4_Reply' in libsel4
pub inline fn sendReply(msgInfo: seL4.MessageInfo) void {
    if (@hasDecl(c, "seL4_Reply")) {
        return c.seL4_Reply(msgInfo);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

// Not for MCS, AKA 'seL4_ReplyWithMRs' in libsel4
pub inline fn sendReplyWithMRs(msgInfo: seL4.MessageInfo, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word) void {
    if (@hasDecl(c, "seL4_ReplyWithMRs")) {
        return c.seL4_ReplyWithMrs(msgInfo, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

// Send: "Basically not useful. It's there mostly for historical purposes." - G. Heiser
pub inline fn send(dest: seL4.CPtr, msgInfo: seL4.MessageInfo) void {
    if (@hasDecl(c, "seL4_Send")) {
        return c.seL4_Send(dest, msgInfo);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn sendWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word) void {
    if (@hasDecl(c, "seL4_SendWithMRs")) {
        return c.seL4_SendWithMRs(dest, msgInfo, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

// Non-blocking send. Will silently fail if receiver is not ready!
// Used more for notifications rather than endpoints.
pub inline fn nBSend(dest: seL4.CPtr, msgInfo: seL4.MessageInfo) void {
    if (@hasDecl(c, "seL4_Send")) {
        return c.seL4_NBSend(dest, msgInfo);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBSendWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word) void {
    if (@hasDecl(c, "seL4_NBSendWithMRs")) {
        return c.seL4_NBSendWithMRs(dest, msgInfo, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn recv(src: seL4.CPtr, sender: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_Recv")) {
        return c.seL4_Recv(src, sender, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn recvWithMRs(src: seL4.CPtr, sender: *seL4.Word, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_RecvWithMRs")) {
        return c.seL4_RecvWithMRs(src, sender, mr0, mr1, mr2, mr3, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBRecv(src: seL4.CPtr, sender: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_NBRecv")) {
        return c.seL4_NBRecv(src, sender, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn replyRecv(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, sender: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_ReplyRecv")) {
        return c.seL4_ReplyRecv(dest, msgInfo, sender, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn replyRecvWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, sender: *seL4.Word, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_ReplyRecvWithMRs")) {
        return c.seL4_ReplyRecvWithMRs(dest, msgInfo, sender, mr0, mr1, mr2, mr3, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBSendRecv(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, src: seL4.CPtr, sender: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_SendRecv")) {
        return c.seL4_NBSendRecv(dest, msgInfo, src, sender, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBSendRecvWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, src: seL4.CPtr, sender: *seL4.Word, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word, reply: seL4.CPtr) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_SendRecvWithMRs")) {
        return c.seL4_NBSendRecvWithMRs(dest, msgInfo, src, sender, mr0, mr1, mr2, mr3, reply);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBSendWait(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, src: seL4.CPtr, sender: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_NBSendWait")) {
        return c.seL4_NBSendWait(dest, msgInfo, src, sender);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBSendWaitWithMRs(dest: seL4.CPtr, msgInfo: seL4.MessageInfo, src: seL4.CPtr, sender: *seL4.Word, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_NBSendWaitWithMRs")) {
        return c.seL4_NBSendWaitWithMRs(dest, msgInfo, src, sender, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn yield() void {
    if (@hasDecl(c, "seL4_Yield")) {
        return c.seL4_Yield();
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn signal(dest: seL4.CPtr) void {
    if (@hasDecl(c, "seL4_Signal")) {
        return c.seL4_Signal(dest);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn wait(src: seL4.CPtr, sender: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_Wait")) {
        return c.seL4_Wait(src, sender);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn waitWithMRs(src: seL4.CPtr, sender: *seL4.Word, mr0: *seL4.Word, mr1: *seL4.Word, mr2: *seL4.Word, mr3: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_WaitWithMRs")) {
        return c.seL4_WaitWithMRs(src, sender, mr0, mr1, mr2, mr3);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn nBWait(src: seL4.CPtr, sender: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_NBWait")) {
        return c.seL4_NBWait(src, sender);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn poll(src: seL4.CPtr, sender: *seL4.Word) seL4.MessageInfo {
    if (@hasDecl(c, "seL4_Poll")) {
        return c.seL4_Poll(src, sender);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}

pub inline fn vMEnter(sender: *seL4.Word) seL4.Word {
    if (@hasDecl(c, "seL4_VMEnter")) {
        return c.seL4_VMEnter(sender);
    } else {
        @compileError("System call is not supported under this configuration");
    }
}
