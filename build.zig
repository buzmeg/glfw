
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "glfw3",
        .target = target,
        .optimize = optimize,
    });
    const t = lib.target_info.target;


    lib.addIncludePath("include");
    lib.addCSourceFiles(&generic_src_files, &.{});
    //lib.defineCMacro("SDL_USE_BUILTIN_OPENGL_DEFINITIONS", "1");
    lib.linkLibC();
    switch (t.os.tag) {
        .linux => {
            lib.addCSourceFiles(&linux_src_files, &.{});
        },
        .windows => {
            lib.addCSourceFiles(&windows_src_files, &.{});
            lib.linkSystemLibrary("setupapi");
            lib.linkSystemLibrary("winmm");
            lib.linkSystemLibrary("gdi32");
            lib.linkSystemLibrary("imm32");
            lib.linkSystemLibrary("version");
            lib.linkSystemLibrary("oleaut32");
            lib.linkSystemLibrary("ole32");
        },
        // .macos => {
        //     lib.addCSourceFiles(&darwin_src_files, &.{});
        //     lib.addCSourceFiles(&objective_c_src_files, &.{"-fobjc-arc"});
        //     lib.linkFramework("OpenGL");
        //     lib.linkFramework("Metal");
        //     lib.linkFramework("CoreVideo");
        //     lib.linkFramework("Cocoa");
        //     lib.linkFramework("IOKit");
        //     lib.linkFramework("ForceFeedback");
        //     lib.linkFramework("Carbon");
        //     lib.linkFramework("CoreAudio");
        //     lib.linkFramework("AudioToolbox");
        //     lib.linkFramework("AVFoundation");
        //     lib.linkFramework("Foundation");
        // },
        else => {
            // const config_header = b.addConfigHeader(.{
            //     .style = .{ .cmake = .{ .path = "include/SDL_config.h.cmake" } },
            //     .include_path = "SDL2/SDL_config.h",
            // }, .{});
            // lib.addConfigHeader(config_header);
            // lib.installConfigHeader(config_header, .{});
        },
    }
    lib.install();
    lib.installHeadersDirectory("include", "glfw");
}

const generic_src_files = [_][]const u8{
    "src/context.c",
    "src/init.c",
    "src/input.c",
    "src/monitor.c",
    "src/platform.c",
    "src/vulkan.c",
    "src/window.c",
    "src/egl_context.c",
    "src/osmesa_context.c",
    "src/null_init.c",
    "src/null_monitor.c",
    "src/null_window.c",
    "src/null_joystick.c",
};

const linux_src_files = [_][]const u8{
    "src/posix_time.c",
    "src/posix_thread.c",
    "src/posix_poll.c",

    "src/x11_init.c",
    "src/x11_monitor.c",
    "src/x11_window.c",
    "src/xkb_unicode.c",

    "src/glx_context.c",

    "src/linux_joystick.c",
};

const windows_src_files = [_][]const u8{

};

const darwin_src_files = [_][]const u8{

};

const objective_c_src_files = [_][]const u8{

};
