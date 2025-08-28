const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;
    const disable_llvm = b.option(bool, "disable_llvm", "use the non-llvm zig codegen") orelse false;

    const exe = b.addExecutable(.{
        .name = "zig-ansi",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = mode,
    });
    exe.use_llvm = !disable_llvm;
    exe.use_lld = !disable_llvm;
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const tests = b.addTest(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = mode,
    });
    tests.use_llvm = !disable_llvm;
    tests.use_lld = !disable_llvm;

    const run_test = b.addRunArtifact(tests);
    run_test.setCwd(b.path("."));
    run_test.has_side_effects = true;

    const test_step = b.step("test", "Run all library tests");
    test_step.dependOn(&run_test.step);
}
