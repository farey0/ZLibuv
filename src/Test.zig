const L = @import("ZLibuv");

test "main" {
    @import("std").testing.refAllDecls(@This());
    try main();
}

pub fn MyCallback(timer: *L.Timer) void {
    const count: *u64 = timer.GetHandle().GetData(u64);
    count.* += 1;

    if (count.* >= 20) {
        timer.Stop() catch unreachable;
    }
}

pub fn main() !void {
    var loop: L.Loop = .{};
    var timer: L.Timer = .{};

    var count: u64 = 0;

    try loop.Init();

    timer.Init(&loop);
    timer.GetHandle().SetData(&count);

    try timer.Start(MyCallback, 5, 5);

    try loop.Run(.Default);

    // gracefully close timer
    timer.GetHandle().Close(null);
    try loop.Run(.Once);

    try loop.Close();
}
