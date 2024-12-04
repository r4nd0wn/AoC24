const std = @import("std");

const row_size: u64 = 140;
const col_size: u64 = 140;

fn check_direction(search_buffer: *[row_size][col_size]u8, row: u64, col: u64, delta_x: i64, delta_y: i64) bool {
    const search_string: []const u8 = "XMAS";

    // check for out of bounds
    const biggest_bound_x: i64 = @as(i64, @bitCast(row)) + delta_x * 3;
    const biggest_bound_y: i64 = @as(i64, @bitCast(col)) + delta_y * 3;
    if (biggest_bound_x < 0 or biggest_bound_x >= row_size or biggest_bound_y < 0 or biggest_bound_y >= col_size) {
        std.debug.print("row: {d} col: {d}, direction ({d},{d})\n", .{ row, col, delta_x, delta_y });
        std.debug.print("out of bounds {d}, {d}\n", .{ biggest_bound_x, biggest_bound_y });
        return false;
    }
    for (1..4) |i| {
        const lookup_row: u64 = @bitCast(@as(i64, @bitCast(row)) + delta_x * @as(i64, @bitCast(i)));
        const lookup_col: u64 = @bitCast(@as(i64, @bitCast(col)) + delta_y * @as(i64, @bitCast(i)));
        if (search_buffer[lookup_row][lookup_col] != search_string[i]) {
            return false;
        }
    }

    // check above

    // check above right

    // check right

    // check down right

    // check down

    // check down left

    // check left

    // check left above

    return true;
}

pub fn main() !void {
    const reports_raw = @embedFile("input.txt");
    var search_field: [row_size][col_size]u8 = undefined;
    var line_iterator = std.mem.split(u8, reports_raw, "\n");
    var xmas_counter: u32 = 0;
    var linemarker: u64 = 0;
    while (line_iterator.next()) |single_line| {
        for (0..col_size) |char_index| {
            search_field[linemarker][char_index] = single_line[char_index];
        }
        linemarker += 1;
    }
    for (0..row_size) |i| {
        for (0..col_size) |j| {
            if (search_field[i][j] == 'X') {
                xmas_counter += if (check_direction(&search_field, i, j, -1, -1)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, -1, 0)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, -1, 1)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, 0, -1)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, 0, 1)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, 1, -1)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, 1, 0)) 1 else 0;
                xmas_counter += if (check_direction(&search_field, i, j, 1, 1)) 1 else 0;
            }
            //std.debug.print("{c}", .{search_field[i][j]});
        }
        // std.debug.print("\n", .{});
    }
    std.debug.print("found XMAS counter: {d}\n", .{xmas_counter});
}
