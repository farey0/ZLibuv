//! ZLibuv
//! Author : farey0
//!
//! Mirrors : https://docs.libuv.org/en/v1.x/tcp.html

//                          ----------------   Declarations   ----------------

const Self = @This();

const c = @import("c.zig");
const Stream = @import("Stream.zig");
const Loop = @import("Loop.zig");
const SocketAddress = @import("SocketAddress.zig");
const Request = @import("Request.zig");
const ConnectRequest = Request.Type.Connect;

const Handle = @import("Handle.zig");

pub const Error = @import("Error.zig").BaseError;
const HandleError = @import("Error.zig").HandleBaseErr;

//                          ----------------      Members     ----------------

cTcp: c.Tcp = .{},

//                          ----------------      Public      ----------------

pub fn Init(self: *Self, uvLoop: *Loop) Error!void {
    const ret = c.TcpInit(&uvLoop.cLoop, &self.cTcp);

    if (ret < 0)
        return HandleError(ret);
}

pub fn Bind(self: *Self, socketAddr: *const SocketAddress, ipv6Only: bool) Error!void {
    const ret = c.TcpBind(
        &self.cTcp,
        @ptrCast(&socketAddr.cSocketAddress),
        if (ipv6Only) c.c.UV_TCP_IPV6ONLY else 0,
    );

    if (ret < 0)
        return HandleError(ret);
}

pub fn Connect(self: *Self, conReq: *Request.Connect, sockAddr: *SocketAddress, comptime callback: Stream.Callback.Connect) Error!void {
    const ret = c.TcpConnect(&conReq.cReq, &self.cTcp, @ptrCast(&sockAddr.cSocketAddress), Stream.CBHandlerConnect(callback).native);

    if (ret < 0)
        return HandleError(ret);
}

pub fn CloseReset(self: *Self, comptime CloseCb: Handle.CloseCallback) Error!void {
    const ret = c.TcpCloseReset(&self.cTcp, Handle.CloseCbMaker(CloseCb).cCallback);

    if (ret < 0)
        return HandleError(ret);
}

//                          ---------------- Getters/Setters  ----------------

pub fn SetNoDelay(self: *Self, enable: bool) Error!void {
    const ret = c.TcpNoDelay(&self.cTcp, if (enable) 1 else 0);

    if (ret < 0)
        return HandleError(ret);
}

pub fn SetSimultaneousAccepts(self: *Self, enable: bool) Error!void {
    const ret = c.TcpSimultaneousAccepts(&self.cTcp, if (enable) 1 else 0);

    if (ret < 0)
        return HandleError(ret);
}

pub fn SetKeepAlive(self: *Self, enable: bool, delay: u32) Error!void {
    const ret = c.TcpKeepAlive(&self.cTcp, if (enable) 1 else 0, @intCast(delay));

    if (ret < 0)
        return HandleError(ret);
}

pub fn GetSocketAddress(self: *Self) Error!SocketAddress {
    var out: SocketAddress = .{};

    const ret = c.TcpGetSockName(
        &self.cTcp,
        @ptrCast(&out.cSocketAddress),
        @sizeOf(@TypeOf(out.cSocketAddress)),
    );

    if (ret < 0)
        return HandleError(ret);

    return out;
}

pub fn GetPeerAddress(self: *Self) Error!SocketAddress {
    var out: SocketAddress = .{};

    const ret = c.TcpGetPeerName(
        &self.cTcp,
        @ptrCast(&out.cSocketAddress),
        @sizeOf(@TypeOf(out.cSocketAddress)),
    );

    if (ret < 0)
        return HandleError(ret);

    return out;
}

pub fn FromStream(stream: *Stream) *Self {
    return @fieldParentPtr("cTcp", @as(*c.Tcp, @ptrCast(stream.cStream)));
}

pub fn GetStream(self: *Self) Stream {
    return .{
        .cStream = @ptrCast(&self.cTcp),
    };
}

pub fn GetHandle(self: *Self) Handle {
    return .{
        .cHandle = @ptrCast(&self.cTcp),
    };
}

//                          ----------------      Private     ----------------
