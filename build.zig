const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libintl = b.addModule("libintl", .{
        .root_source_file = .{ .path = "src/libintl.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    _ = libintl;
    // TODO: platform-specific libraries to link

    // TODO: test steps, will be easier with https://github.com/ziglang/zig/pull/18752
}
