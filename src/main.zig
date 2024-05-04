const std = @import("std");

const ansi = @import("./lib.zig");

pub fn main() anyerror!void {
    std.debug.print(comptime ansi.color.Fg(.Red, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Fg(.Green, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Fg(.Yellow, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Fg(.Blue, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Fg(.Magenta, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Fg(.Cyan, "All your codebase are belong to us.\n"), .{});

    std.debug.print("\n", .{});

    std.debug.print(comptime ansi.color.Bg(.Red, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Bg(.Green, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Bg(.Yellow, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Bg(.Blue, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Bg(.Magenta, "All your codebase are belong to us.\n"), .{});
    std.debug.print(comptime ansi.color.Bg(.Cyan, "All your codebase are belong to us.\n"), .{});
}
