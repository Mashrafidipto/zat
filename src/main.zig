const std = @import("std");
const fs = std.fs;
const env = std.process;
const Reader = std.io.Reader;

const MAX_LENGTH: usize = 1024;

var stdout_buffer = [_]u8{0} ** MAX_LENGTH;
var stdout_writer = fs.File.stdout().writer(&stdout_buffer);
pub var stdout = &stdout_writer.interface;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alocator = gpa.allocator();

pub fn main() !void {
    const agrv = try env.argsAlloc(alocator);
    defer env.argsFree(alocator, agrv);

    const file = if (agrv.len > 1) try fs.cwd().openFile(agrv[1], .{ .mode = .read_only }) else fs.File.stdin();

    //colsing file if not stdin()
    defer {
        if (agrv.len == 1) {
            file.close();
        }
    }
    var file_buffer = [_]u8{0} ** MAX_LENGTH;
    var file_reader = file.reader(&file_buffer);
    try print_contents(&file_reader.interface);
}

pub fn print_contents(file_interface: *Reader) !void {
    while (try file_interface.takeDelimiter('\n')) |line| {
        try stdout.print("{s}\n", .{line});
    }
    try stdout.flush();
}
