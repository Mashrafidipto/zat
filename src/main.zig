const std = @import("std");
const fs = std.fs;
const env = std.process;

const MAX_LENGTH: usize = 1024;

var stdout_buffer = [_]u8{0} ** MAX_LENGTH;
var stdout_writer = fs.File.stdout().writer(&stdout_buffer);
pub var stdout = &stdout_writer.interface;

pub fn main() !void {
    _ = try get_file_reader();
}
pub fn mainOld() !void {
    var file_buffer = [_]u8{0} ** MAX_LENGTH;
    const file_location = try fs.cwd().openFile("build.zig.zon", .{ .mode = .read_only });
    var file_interface = file_location.reader(&file_buffer);
    const file_reader = &file_interface.interface;

    while (try file_reader.takeDelimiter('\n')) |line| {
        try stdout.print("{s}\n", .{line});
        try stdout.flush();
    }
}

pub fn get_file_reader() !?std.io.Reader {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alocator = gpa.allocator();

    const agrv = try env.argsAlloc(alocator);
    defer env.argsFree(alocator, agrv);

    for (agrv) |line| {
        try stdout.print("{s}\n", .{line});
    }
    try stdout.flush();

    return null;
}
