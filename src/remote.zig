const std = @import("std");

pub const RemoteSessionArg = struct {
    host_name: []const u8,
    session_name: []const u8,

    pub fn init(arg: []const u8) ?RemoteSessionArg {
        if (std.mem.indexOf(u8, arg, ":")) |idx| {
            return .{ .host_name = arg[0..idx], .session_name = arg[idx + 1 ..] };
        }

        return null;
    }
};

pub fn execute(alloc: std.mem.Allocator, host: []const u8, args: []const []const u8) !void {
    var command: std.ArrayList([]const u8) = .empty;
    try command.appendSlice(alloc, &[_][]const u8{ "ssh", "-qt", host });
    try command.appendSlice(alloc, args);

    var child = std.process.Child.init(command.items, alloc);
    child.stdin_behavior = .Inherit;
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    const term = try child.spawnAndWait();
    const code: u8 = switch (term) {
        .Exited => |v| v,
        else => 1,
    };

    std.process.exit(code);
}
