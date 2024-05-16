const std = @import("std");

pub const ascii = enum(u7) {
    NUL,
    SOH,
    STX,
    ETX,
    EOT,
    ENQ,
    ACK,
    BEL,
    BS,
    TAB,
    LF,
    VT,
    FF,
    CR,
    SO,
    SI,
    DLE,
    DC1,
    DC2,
    DC3,
    DC4,
    NAK,
    SYN,
    ETB,
    CAN,
    EM,
    SUB,
    ESC,
    FS,
    GS,
    RS,
    US,
    _,

    pub fn s(self: ascii) [1]u8 {
        return .{@intFromEnum(self)};
    }
};

pub const escape = struct {
    pub const SS2 = ascii.ESC.s() ++ "N";
    pub const SS3 = ascii.ESC.s() ++ "O";
    pub const DCS = ascii.ESC.s() ++ "P";
    pub const CSI = ascii.ESC.s() ++ "[";
    pub const ST = ascii.ESC.s() ++ "\\";
    pub const OSC = ascii.ESC.s() ++ "]";
    pub const SOS = ascii.ESC.s() ++ "X";
    pub const PM = ascii.ESC.s() ++ "^";
    pub const APC = ascii.ESC.s() ++ "_";
    pub const RIS = ascii.ESC.s() ++ "c";
};

fn make_csi_sequence(comptime c: []const u8, comptime x: anytype) []const u8 {
    return comptime escape.CSI ++ _join(";", arr_i_to_s(x)) ++ c;
}

fn arr_i_to_s(x: anytype) [][]const u8 {
    var res: [x.len][]const u8 = undefined;
    for (x, 0..) |item, i| {
        res[i] = std.fmt.comptimePrint("{}", .{item});
    }
    return &res;
}

pub const csi = struct {
    pub fn CursorUp(comptime n: i32) []const u8 {
        return make_csi_sequence("A", .{n});
    }
    pub fn CursorDown(comptime n: i32) []const u8 {
        return make_csi_sequence("B", .{n});
    }
    pub fn CursorForward(comptime n: i32) []const u8 {
        return make_csi_sequence("C", .{n});
    }
    pub fn CursorBack(comptime n: i32) []const u8 {
        return make_csi_sequence("D", .{n});
    }
    pub fn CursorNextLine(comptime n: i32) []const u8 {
        return make_csi_sequence("E", .{n});
    }
    pub fn CursorPrevLine(comptime n: i32) []const u8 {
        return make_csi_sequence("F", .{n});
    }
    pub fn CursorHorzAbs(comptime n: i32) []const u8 {
        return make_csi_sequence("G", .{n});
    }
    pub fn CursorPos(comptime n: i32, m: i32) []const u8 {
        return make_csi_sequence("H", .{ n, m });
    }
    pub fn EraseInDisplay(comptime n: i32) []const u8 {
        return make_csi_sequence("J", .{n});
    }
    pub fn EraseInLine(comptime n: i32) []const u8 {
        return make_csi_sequence("K", .{n});
    }
    pub fn ScrollUp(comptime n: i32) []const u8 {
        return make_csi_sequence("S", .{n});
    }
    pub fn ScrollDown(comptime n: i32) []const u8 {
        return make_csi_sequence("T", .{n});
    }
    pub fn HorzVertPos(comptime n: i32, m: i32) []const u8 {
        return make_csi_sequence("f", .{ n, m });
    }
    pub fn SGR(comptime ns: anytype) []const u8 {
        return make_csi_sequence("m", ns);
    }
};

pub const style = struct {
    pub const ResetAll = csi.SGR(.{0});

    pub const Bold = csi.SGR(.{1});
    pub const Faint = csi.SGR(.{2});
    pub const Italic = csi.SGR(.{3});
    pub const Underline = csi.SGR(.{4});
    pub const BlinkSlow = csi.SGR(.{5});
    pub const BlinkFast = csi.SGR(.{6});

    pub const ResetFont = csi.SGR(.{10});
    pub const Font1 = csi.SGR(.{11});
    pub const Font2 = csi.SGR(.{12});
    pub const Font3 = csi.SGR(.{13});
    pub const Font4 = csi.SGR(.{14});
    pub const Font5 = csi.SGR(.{15});
    pub const Font6 = csi.SGR(.{16});
    pub const Font7 = csi.SGR(.{17});
    pub const Font8 = csi.SGR(.{18});
    pub const Font9 = csi.SGR(.{19});

    pub const UnderlineDouble = csi.SGR(.{21});
    pub const ResetIntensity = csi.SGR(.{22});
    pub const ResetItalic = csi.SGR(.{23});
    pub const ResetUnderline = csi.SGR(.{24});
    pub const ResetBlink = csi.SGR(.{25});

    pub const FgBlack = csi.SGR(.{30});
    pub const FgRed = csi.SGR(.{31});
    pub const FgGreen = csi.SGR(.{32});
    pub const FgYellow = csi.SGR(.{33});
    pub const FgBlue = csi.SGR(.{34});
    pub const FgMagenta = csi.SGR(.{35});
    pub const FgCyan = csi.SGR(.{36});
    pub const FgWhite = csi.SGR(.{37});
    // Fg8bit       = func(n int) string { return csi.SGR(38, 5, n) }
    // Fg24bit      = func(r, g, b int) string { return csi.SGR(38, 2, r, g, b) }
    pub const ResetFgColor = csi.SGR(.{39});

    pub const BgBlack = csi.SGR(.{40});
    pub const BgRed = csi.SGR(.{41});
    pub const BgGreen = csi.SGR(.{42});
    pub const BgYellow = csi.SGR(.{43});
    pub const BgBlue = csi.SGR(.{44});
    pub const BgMagenta = csi.SGR(.{45});
    pub const BgCyan = csi.SGR(.{46});
    pub const BgWhite = csi.SGR(.{47});
    // Bg8bit       = func(n int) string { return csi.SGR(48, 5, n) }
    // Bg24bit      = func(r, g, b int) string { return csi.SGR(48, 2, r, g, b) }
    pub const ResetBgColor = csi.SGR(.{49});

    pub const Framed = csi.SGR(.{51});
    pub const Encircled = csi.SGR(.{52});
    pub const Overlined = csi.SGR(.{53});
    pub const ResetFrameEnci = csi.SGR(.{54});
    pub const ResetOverlined = csi.SGR(.{55});
};

pub const color = struct {
    pub const Color = enum(u8) {
        Black,
        Red,
        Green,
        Yellow,
        Blue,
        Magenta,
        Cyan,
        White,
    };

    pub fn Fg(s: Color, comptime m: []const u8) []const u8 {
        return csi.SGR(.{30 + @intFromEnum(s)}) ++ m ++ style.ResetFgColor;
    }

    pub fn Bg(s: Color, comptime m: []const u8) []const u8 {
        return csi.SGR(.{40 + @intFromEnum(s)}) ++ m ++ style.ResetBgColor;
    }

    pub fn Bold(comptime m: []const u8) []const u8 {
        return style.Bold ++ m ++ style.ResetIntensity;
    }

    pub fn Faint(comptime m: []const u8) []const u8 {
        return style.Faint ++ m ++ style.ResetIntensity;
    }

    pub fn Italic(comptime m: []const u8) []const u8 {
        return style.Italic ++ m ++ style.ResetItalic;
    }

    pub fn Underline(comptime m: []const u8) []const u8 {
        return style.Underline ++ m ++ style.ResetUnderline;
    }
};

//
// private
//

fn _join(comptime delim: []const u8, comptime xs: [][]const u8) []const u8 {
    var buf: []const u8 = "";
    for (xs, 0..) |x, i| {
        buf = buf ++ x;
        if (i < xs.len - 1) buf = buf ++ delim;
    }
    return buf;
}
