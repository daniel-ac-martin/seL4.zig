// Let's do the C include in one place.
// This probably doesn't achieve anything, but it feels a bit cleaner.
pub usingnamespace @cImport({
    @cInclude("sel4/sel4.h");
});
