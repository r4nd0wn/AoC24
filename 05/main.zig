const std = @import("std");
const Rule = std.meta.Tuple(&.{ u8, u8 });
const Rule_check_result = std.meta.Tuple(&.{ bool, u64, u64 });

const Pages = struct {
    page_buff: []u8,
    length: u64,

    pub fn init(buffer: []const u8) !Pages {
        var parseBuf: []u8 = try std.heap.page_allocator.alloc(u8, 40);
        var pos: u64 = 0;
        var iterator = std.mem.split(u8, buffer, ",");
        while (iterator.next()) |single_value| {
            parseBuf[pos] = try std.fmt.parseInt(u8, single_value, 10);
            pos += 1;
        }
        return Pages{ .page_buff = parseBuf, .length = pos };
    }

    pub fn deinit(self: Pages) void {
        std.heap.page_allocator.destroy(self.page_buff);
    }

    fn get_index(self: *const Pages, search_payload: u8) u64 {
        for (0..self.length) |i| {
            if (self.page_buff[i] == search_payload) return i;
        }
        // return 1000 if it is not found.
        return self.length + 1;
    }
    fn check_proper_order(self: *const Pages, rule: Rule) Rule_check_result {
        const before: u64 = self.get_index(rule[0]);
        const after: u64 = self.get_index(rule[1]);
        // if one of the pages are not there, return true
        if (before > self.length or after > self.length) return .{ true, before, after };
        // its the correct order
        if (before < after) return .{ true, before, after };
        return .{ false, before, after };
    }

    fn apply_rule(self: *const Pages, rule: Rule) bool {
        const rule_result = self.check_proper_order(rule);
        if (rule_result[0]) return false;
        // triangle swap
        const triangle: u8 = self.page_buff[rule_result[1]];
        self.page_buff[rule_result[1]] = self.page_buff[rule_result[2]];
        self.page_buff[rule_result[2]] = triangle;
        return true;
    }

    pub fn apply_rule_set(self: *const Pages, rules: []const Rule) void {
        var marker = true;
        while (marker) {
            rule_iterator: for (rules) |single_rule| {
                if (self.apply_rule(single_rule)) break :rule_iterator;
            }
            marker = false;
        }
    }
};

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
        single_page_set.apply_rule_set(&rule_set);
        std.debug.print("{any}\n", .{single_page_set.page_buff});
    }
}
