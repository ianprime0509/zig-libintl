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
    // TODO: platform-specific libraries to link

    const test_step = b.step("test", "Run the tests");
    const libintl_test = b.addTest(.{
        .root_module = libintl,
    });
    const libintl_test_run = b.addRunArtifact(libintl_test);
    test_step.dependOn(&libintl_test_run.step);

    const docs_step = b.step("docs", "Build the documentation");
    const libintl_docs = b.addObject(.{
        .name = "libintl",
        .root_module = libintl,
    });
    const libintl_docs_copy = b.addInstallDirectory(.{
        .source_dir = libintl_docs.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&libintl_docs_copy.step);
}
