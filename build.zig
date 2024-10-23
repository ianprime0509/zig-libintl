const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libintl = b.addModule("libintl", .{
        .root_source_file = b.path("src/libintl.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    _ = libintl;
    // TODO: platform-specific libraries to link

    // TODO: will be easier with https://github.com/ziglang/zig/pull/20388
    const test_step = b.step("test", "Run the tests");
    const libintl_test = b.addTest(.{
        .root_source_file = b.path("src/libintl.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    const libintl_test_run = b.addRunArtifact(libintl_test);
    test_step.dependOn(&libintl_test_run.step);

    const docs_step = b.step("docs", "Build the documentation");
    const libintl_docs = b.addObject(.{
        .name = "libintl",
        .root_source_file = b.path("src/libintl.zig"),
        .target = target,
        .optimize = .Debug,
        .link_libc = true,
    });
    const libintl_docs_copy = b.addInstallDirectory(.{
        .source_dir = libintl_docs.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&libintl_docs_copy.step);
}
