const std = @import("std");

//fn check_start(search_buffer: [][]const u8, line: u64, row: u64) bool {
// check above
// check above right

// check right

// check down right

// check down

// check down left

// check left

// check left above

//    return false;
//}

pub fn main() !void {
    const reports_raw = @embedFile("input.txt");
    var search_field: [140][140]u8 = undefined;
    var line_iterator = std.mem.split(u8, reports_raw, "\n");

    var linemarker: u64 = 0;
    while (line_iterator.next()) |single_line| {
        for (0..140) |char_index| {
            search_field[linemarker][char_index] = single_line[char_index];
        }
        linemarker += 1;
    }
    for (0..140) |i| {
        for (0..140) |j| {
            std.debug.print("{c}", .{search_field[i][j]});
        }
        std.debug.print("\n", .{});
    }
}
