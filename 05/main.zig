const std = @import("std");

const Pages = struct {
    page_buff: [40]u8,
    length: u64,
    pub fn init(buffer: []const u8) !Pages {
        var parseBuf: [40]u8 = undefined;
        var pos: u64 = 0;
        var iterator = std.mem.split(u8, buffer, ",");
        while (iterator.next()) |single_value| {
            parseBuf[pos] = try std.fmt.parseInt(u8, single_value, 10);
            pos += 1;
        }
        return Pages{ .page_buff = parseBuf, .length = pos };
    }
};
const Rule = std.meta.Tuple(&.{ u8, u8 });

pub fn main() !void {
    const reports_raw = @embedFile("input.txt");

    var line_iterator = std.mem.split(u8, reports_raw, "\n\n");
    var rule_set: [1176]Rule = undefined;
    var page_set: [300]Pages = undefined;
    var rule_iterator = std.mem.split(u8, line_iterator.first(), "\n");
    var rule_marker: u64 = 0;
    while (rule_iterator.next()) |single_rule| {
        var fmlanotheriterator = std.mem.split(u8, single_rule, "|");
        const before = try std.fmt.parseInt(u8, fmlanotheriterator.first(), 10);
        const after = try std.fmt.parseInt(u8, fmlanotheriterator.rest(), 10);
        rule_set[rule_marker] = .{ before, after };
        rule_marker += 1;
    }
    var page_marker: u64 = 0;
    var page_iterator = std.mem.split(u8, line_iterator.rest(), "\n");
    while (page_iterator.next()) |single_page_set| {
        page_set[page_marker] = try Pages.init(single_page_set);
        page_marker += 1;
    }
    for (rule_set) |single_rule| {
        std.debug.print("{d}|{d},", .{ single_rule[0], single_rule[1] });
    }
    std.debug.print("\n", .{});
    for (page_set) |single_page_set| {
        std.debug.print("{any}\n", .{single_page_set.page_buff});
    }
}
