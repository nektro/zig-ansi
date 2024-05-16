const std = @import("std");
const ansi = @import("./lib.zig");

fn expectFmt(comptime actual: []const u8, expected: []const u8) !void {
    return std.testing.expectEqualSlices(u8, expected, actual);
}

test {
    try expectFmt(
        ansi.color.Fg(.Blue, "All your codebase"),
        &(.{ 27, '[', '3', '4', 'm' } ++ "All your codebase".* ++ .{ 27, '[', '3', '9', 'm' }),
    );
}
test {
    try expectFmt(
        ansi.color.Bg(.Cyan, "All your codebase"),
        &(.{ 27, '[', '4', '6', 'm' } ++ "All your codebase".* ++ .{ 27, '[', '4', '9', 'm' }),
    );
}
