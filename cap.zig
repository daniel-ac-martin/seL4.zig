const c = @import("./c-library.zig");
const seL4 = @import("./common.zig");

const unsupported = "Capability is not supported under this configuration";

pub const null_cap: seL4.CPtr = if (@hasDecl(c, "seL4_CapNull")) c.seL4_CapNull else @compileError(unsupported);
pub const init_thread_tcb: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadTCB")) c.seL4_CapInitThreadTCB else @compileError(unsupported);
pub const init_thread_cnode: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadCNode")) c.seL4_CapInitThreadCNode else @compileError(unsupported);
pub const init_thread_vspace: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadVSpace")) c.seL4_CapInitThreadVSpace else @compileError(unsupported);
pub const irq_control: seL4.CPtr = if (@hasDecl(c, "seL4_CapIRQControl")) c.seL4_CapIRQControl else @compileError(unsupported);
pub const asid_control: seL4.CPtr = if (@hasDecl(c, "seL4_CapASIDControl")) c.seL4_CapASIDControl else @compileError(unsupported);
pub const init_thread_asid_pool: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadASIDPool")) c.seL4_CapInitThreadASIDPool else @compileError(unsupported);
pub const ioport_control: seL4.CPtr = if (@hasDecl(c, "seL4_CapIOPortControl")) c.seL4_CapIOPortControl else @compileError(unsupported);
pub const iospace: seL4.CPtr = if (@hasDecl(c, "seL4_CapIOSpace")) c.seL4_CapIOSpace else @compileError(unsupported);
pub const bootinfo_frame: seL4.CPtr = if (@hasDecl(c, "seL4_CapBootInfoFrame")) c.seL4_CapBootInfoFrame else @compileError(unsupported);
pub const init_thread_ipc_buffer: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadIPCBuffer")) c.seL4_CapInitThreadIPCBuffer else @compileError(unsupported);
pub const domain: seL4.CPtr = if (@hasDecl(c, "seL4_CapDomain")) c.seL4_CapDomain else @compileError(unsupported);
pub const smmusid_control: seL4.CPtr = if (@hasDecl(c, "seL4_CapSMMUSIDControl")) c.seL4_CapSMMUSIDControl else @compileError(unsupported);
pub const smmucb_control: seL4.CPtr = if (@hasDecl(c, "seL4_CapSMMUCBControl")) c.seL4_CapSMMUCBControl else @compileError(unsupported);
pub const init_thread_SC: seL4.CPtr = if (@hasDecl(c, "seL4_CapInitThreadSC")) c.seL4_CapInitThreadSC else @compileError(unsupported);
