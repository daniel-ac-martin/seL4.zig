seL4.zig - A Zig module for building seL4 tasks
===============================================

This is a Zig module for building on top of the [seL4 micro-kernel]. It provides the following:
- Entrypoints / run-time environment
- System call API
- Helper functions for handling seL4 kernel objects (incomplete)

It is inspired by both [libsel4] and [sel4runtime].

Usage
-----

You should add this repo as a Git sub-module...

```shell
git submodule add https://github.com/daniel-ac-martin/seL4.zig.git path/to/seL4.zig
```

Then add it as a module in your `build.zig` file and set you linker script to the one provided...

```zig
// build.zig
// [...]

const seL4 = b.addModule("sel4", .{ .source_file = .{ .path = "path/to/seL4.zig/seL4.zig" } });

// [...]

exe.addModule("seL4", seL4);
exe.setLinkerScriptPath(.{ .path = "path/to/seL4.zig/root-task.ld" });

// [...]
```

You should then be able to import the module into your Zig code:

```zig
const seL4 = @import("seL4");

export fn main() void {
    seL4.debugPutString("Hello, world!"); // Assumes a kernel with debug printing enabled

    const boot_info = seL4.getBootInfo();

    // [...]
}
```

You should be able to run your executables on top of an appropriately configured seL4 micro-kernel, typically obtained via a ['stand-alone' build].

For an example, see: https://github.com/daniel-ac-martin/seL4-minimal-zig


Notes
-----

- This module is at a very early stage; it is both incomplete and the API is unstable.
- Only the MCS kernel is supported. (It might be possible to support non-MCS, but I'm unsure of the value.)
- Only x86-64 is supported, for now. I'd like to support aarch64 and riscv64 in the future, but I'm not conviced of the value of supporting 32bit variants, especially x86.)
- I'm currently unsure as to whether I will maintain this going forward. (If you have an interest in it, reach out in the [issues]; knowing that _someone_ is interested might provide me with some motivation.)


[seL4 micro-kernel]: https://sel4.systems/
[libsel4]: https://github.com/seL4/seL4/tree/master/libsel4
[sel4runtime]: https://github.com/seL4/sel4runtime
['stand-alone' build]: https://docs.sel4.systems/projects/buildsystem/standalone.html
[issues]: https://github.com/daniel-ac-martin/seL4.zig/issues

