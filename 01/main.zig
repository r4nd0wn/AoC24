const std = @import("std");

pub fn main() !void {
    var firstGroup: [1000]i32 = undefined;
    var secondGroup: [1000]i32 = undefined;
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var distance: i32 = 0;
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var counter: u64 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        firstGroup[counter] = try std.fmt.parseInt(i32, line[0..5], 10);
        secondGroup[counter] = try std.fmt.parseInt(i32, line[8..], 10);
        std.debug.print("{d}:{d}\n", .{ firstGroup[counter], secondGroup[counter] });
        counter += 1;
    }

    std.mem.sort(i32, &firstGroup, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, &secondGroup, {}, comptime std.sort.asc(i32));
    for (0..1000) |i| {
        std.debug.print("{d}:{d}\n", .{ firstGroup[i], secondGroup[i] });
        // what should i substrate from what?
        if (firstGroup[i] < secondGroup[i]) {
            distance += secondGroup[i] - firstGroup[i];
        } else {
            // if equal it is 0, no need to check
            distance += firstGroup[i] - secondGroup[i];
        }
    }
    std.debug.print("Distance equals: {d}\n", .{distance});

    // second question is solvable on a sorted list
    // iterate through list 1 and count the times the number is selected in list 2 (iterating over 2?)
    var similarityScore: i32 = 0; // this could be a quite high number
    for (0..1000) |i| {
        var occurence: i32 = 0;
        inner: for (0..1000) |j| {
            // sorted list, if left number is higher than my right one, no need to check anything further
            if (firstGroup[i] < secondGroup[j]) {
                break :inner;
            }
            if (firstGroup[i] == secondGroup[j]) {
                occurence += 1;
            }
        }
        similarityScore += firstGroup[i] * occurence;
    }
    std.debug.print("Similarity Score is: {d}\n", .{similarityScore});
}
