const std = @import("std");

const ReportList = struct {
    buff: [10]i32,
    length: u64,
    pub fn init(buffer: []const u8) !ReportList {
        var parseBuf: [10]i32 = undefined;
        var pos: u64 = 0;
        var iter = std.mem.split(u8, buffer, " ");
        while (iter.next()) |single_value| {
            parseBuf[pos] = try std.fmt.parseInt(i32, single_value, 10);
            pos += 1;
        }
        return ReportList{ .buff = parseBuf, .length = pos };
    }
    pub fn printMe(self: ReportList) void {
        for (0..self.length) |i| {
            std.debug.print("{d} \n", .{i});
        }
    }
    pub fn is_safe(self: ReportList) bool {
        var previos_report: i32 = 0;
        var previous_diff: i32 = 0;
        var safe_marker: i32 = 0;
        buffer_loop: for (0..self.length) |i| {
            if (previos_report == 0) {
                previos_report = self.buff[i];
                continue :buffer_loop;
            }
            if (previos_report == self.buff[i]) {
                safe_marker = 0;
                return false;
            }
            const diff: i32 = self.buff[i] - previos_report;
            //std.debug.print("{d} against {d}: {d}\n", .{ currentValue, previos_report, diff });

            // check ranges, this is just for my head. invert it to a single line statement
            if (diff < 0 and diff >= -3) {
                // valid desc
            } else if (diff > 0 and diff <= 3) {
                // valid asc
            } else {
                // invalid
                return false;
            }
            // std.debug.print("ranges valid\n", .{});
            // check asc desc
            if (previous_diff == 0) {
                previous_diff = diff;

                previos_report = self.buff[i];
                continue :buffer_loop;
            } else if ((diff < 0 and previous_diff > 0) or (diff > 0 and previous_diff < 0)) {
                //   std.debug.print("previous diff {d} against current diff{d}\n", .{ previous_diff, diff });

                // difference in asc desc
                return false;
            }
            safe_marker = 1;
            previous_diff = diff;
            previos_report = self.buff[i];
        }
        if (safe_marker == 1) return true;
        return false;
    }
};

pub fn main() !void {
    const reports_raw = @embedFile("input.txt");

    var line_iterator = std.mem.split(u8, reports_raw, "\n");
    var testBuffer: [1000]ReportList = undefined;

    var linemarker: u64 = 0;
    while (line_iterator.next()) |single_line| {
        testBuffer[linemarker] = try ReportList.init(single_line);
        linemarker += 1;
    }
    var anotherSafeCounter: i32 = 0;
    for (testBuffer) |singleReportList| {
        if (singleReportList.is_safe()) anotherSafeCounter += 1;
    }
    std.debug.print("{d}\n", .{anotherSafeCounter});
}
