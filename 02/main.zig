const std = @import("std");

pub fn main() !void {
    const reports_raw = @embedFile("input.txt");

    var line_iterator = std.mem.split(u8, reports_raw, "\n");

    var safe_counter: u64 = 0;
    line_loop: while (line_iterator.next()) |single_line| {
        var safe_marker: u8 = 0;
        var value_iterator = std.mem.split(u8, single_line, " ");

        var previos_report: i32 = 0;
        var previous_diff: i32 = 0;
        value_loop: while (value_iterator.next()) |single_value| {
            // std.debug.print("{s}\n", .{single_value});
            const currentValue: i32 = try std.fmt.parseInt(i32, single_value, 10);
            std.debug.print("{d} against {d}\n", .{ currentValue, previos_report });
            // check if i am at the beginning. There is no asc or desc yet.
            if (previos_report == 0) {
                previos_report = currentValue;
                continue :value_loop;
            }
            if (previos_report == currentValue) {
                safe_marker = 0;
                continue :line_loop;
            }
            const diff: i32 = currentValue - previos_report;
            //std.debug.print("{d} against {d}: {d}\n", .{ currentValue, previos_report, diff });

            // check ranges, this is just for my head. invert it to a single line statement
            if (diff < 0 and diff >= -3) {
                // valid desc
            } else if (diff > 0 and diff <= 3) {
                // valid asc
            } else {
                // invalid
                continue :line_loop;
            }
            std.debug.print("ranges valid\n", .{});
            // check asc desc
            if (previous_diff == 0) {
                previous_diff = diff;

                previos_report = currentValue;
                continue :value_loop;
            } else if ((diff < 0 and previous_diff > 0) or (diff > 0 and previous_diff < 0)) {
                std.debug.print("previous diff {d} against current diff{d}\n", .{ previous_diff, diff });

                // difference in asc desc
                continue :line_loop;
            }
            safe_marker = 1;
            previous_diff = diff;
            previos_report = currentValue;
        }
        if (safe_marker == 1) safe_counter += 1;
        previous_diff = 0;
        safe_marker = 0;
        previos_report = 0;
    }
    std.debug.print("{d}\n", .{safe_counter});
}
