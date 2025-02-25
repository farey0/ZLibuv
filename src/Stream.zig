//! ZLibuv
//! Author : farey0
//!
//! Mirrors : https://docs.libuv.org/en/v1.x/stream.html

//  ----------------   Declarations   ----------------
const c = @import("c.zig");
const Handle = @import("Handle.zig");
const Request = @import("Request.zig");

const Self = @This();

pub const MaxBacklog = c.MaxBacklog;

pub const Error = @import("Error.zig").BaseError;
const HandleError = @import("Error.zig").HandleBaseErr;

pub const Callback = struct {
    pub const Read = fn (Self, readed: usize, BufferPtr, ?Error) void;
    pub const Common = fn (Request.Base, ?Error) void;
    pub const Alloc = fn (Handle, suggestedSize: usize, BufferPtr) void;

    pub const Write = fn (*Request.Write, ?Error) void;
    pub const Connect = fn (*Request.Connect, ?Error) void;
    pub const Shutdown = fn (*Request.Shutdown, ?Error) void;

    pub const Connection = fn (Self, ?Error) void;
};

pub const Buffer = extern struct {
    base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    len: usize = @import("std").mem.zeroes(usize),

    pub fn FromSlice(slice: []const u8) Buffer {
        return .{
            .base = @ptrCast(@constCast(slice.ptr)),
            .len = @intCast(slice.len),
        };
    }

    pub fn ToSlice(buffer: Buffer) error{Invalid}![]u8 {
        return if (buffer.base != null) buffer.base[0..buffer.len] else error.Invalid;
    }
};

pub const BufferPtr = struct {
    cBuf: [*c]c.Buffer = undefined,

    pub fn ToSlice(buffer: BufferPtr) error{Invalid}![]u8 {
        return if (buffer.cBuf.*.base != null) buffer.cBuf.*.base[0..buffer.cBuf.*.len] else error.Invalid;
    }

    pub fn FromSlice(buffer: BufferPtr, slice: []const u8) void {
        buffer.cBuf.* = .{
            .base = @ptrCast(@constCast(slice.ptr)),
            .len = @intCast(slice.len),
        };
    }
};

//  ----------------      Members     ----------------

cStream: *c.Stream = undefined,

//  ----------------      Public      ----------------

pub fn Shutdown(self: Self, comptime callback: Callback.Shutdown, req: *Request.Shutdown) Error!void {
    const ret = c.Shutdown(&req.cReq, self.cStream, &CBHandlerShutdown(callback).native);

    if (ret < 0)
        return HandleError(ret);
}

pub fn Listen(self: Self, backlog: c_int, callback: Callback.Connection) Error!void {
    const ret = c.Listen(self.cStream, backlog, &CBHandlerConnection(callback).native);

    if (ret < 0)
        return HandleError(ret);
}

pub fn Accept(self: Self, client: Self) Error!void {
    const ret = c.Accept(self.cStream, client.cStream);

    if (ret < 0)
        return HandleError(ret);
}

pub fn ReadStart(self: Self, comptime allocCb: Callback.Alloc, comptime readCb: Callback.Read) Error!void {
    const ret = c.ReadStart(self.cStream, &CBHandlerAlloc(allocCb).native, &CBHandlerRead(readCb).native);

    if (ret < 0)
        return HandleError(ret);
}

pub fn ReadStop(self: Self) void {
    _ = c.ReadStop(self.cStream); // see why return is ignored here : https://docs.libuv.org/en/v1.x/stream.html#c.uv_read_stop
}

pub fn Write(self: Self, req: *Request.Write, bufs: []Buffer, writeCb: Callback.Write) Error!void {
    const ret = c.Write(
        &req.cReq,
        self.cStream,
        @ptrCast(bufs.ptr),
        @intCast(bufs.len),
        &CBHandlerWrite(writeCb).native,
    );

    if (ret < 0)
        return HandleError(ret);
}

pub fn SendHandle(self: Self, req: *Request.Write, bufs: []Buffer, toSend: Self, writeCb: Callback.Write) Error!void {
    const ret = c.SendHandle(&req.cReq, self.cStream, bufs.ptr, bufs.len, toSend.cStream, &CBHandlerWrite(writeCb).native);

    if (ret < 0)
        return HandleError(ret);
}

pub fn IsReadable(self: Self) bool {
    return c.IsReadable(self.cStream) == 1;
}

pub fn IsWritable(self: Self) bool {
    return c.IsWritable(self.cStream) == 1;
}

pub fn SetBlocking(self: Self, blocking: bool) Error!void {
    const ret = c.SetBlocking(&self.cStream, if (blocking == true) 1 else 0);

    if (ret < 0)
        return HandleError(ret);
}

pub fn GetWriteQueueSize(self: Self) usize {
    return self.cStream.write_queue_size;
}

pub fn GetHandle(self: Self) Handle {
    return .{
        .cHandle = @ptrCast(self.cStream),
    };
}

//  ----------------      Private     ----------------

pub fn CBHandlerShutdown(comptime callback: Callback.Shutdown) type {
    return struct {
        pub fn native(cReq: [*c]c.ShutdownT, status: c_int) callconv(.C) void {
            callback(
                @as(?*Request.Shutdown, @fieldParentPtr("cReq", cReq)).?,
                if (status == 0) null else HandleError(status),
            );
        }
    };
}

pub fn CBHandlerWrite(comptime callback: Callback.Write) type {
    return struct {
        pub fn native(cReq: [*c]c.WriteT, status: c_int) callconv(.C) void {
            callback(
                @as(?*Request.Write, @fieldParentPtr("cReq", cReq)).?,
                if (status == 0) null else HandleError(status),
            );
        }
    };
}

pub fn CBHandlerConnect(comptime callback: Callback.Connect) type {
    return struct {
        pub fn native(cReq: [*c]c.ConnectT, status: c_int) callconv(.C) void {
            callback(
                @as(?*Request.Connect, @fieldParentPtr("cReq", cReq)).?,
                if (status == 0) null else HandleError(status),
            );
        }
    };
}

pub fn CBHandlerConnection(comptime callback: Callback.Connection) type {
    return struct {
        pub fn native(cSteam: [*c]c.Stream, status: c_int) callconv(.C) void {
            callback(
                .{ .cStream = cSteam },
                if (status == 0) null else HandleError(status),
            );
        }
    };
}

pub fn CBHandlerAlloc(comptime callback: Callback.Alloc) type {
    return struct {
        pub fn native(handle: [*c]c.Handle, suggestedSize: usize, buf: [*c]const c.Buffer) callconv(.C) void {
            callback(.{ .cHandle = handle }, suggestedSize, .{ .cBuf = @constCast(buf) });
        }
    };
}

pub fn CBHandlerRead(comptime callback: Callback.Read) type {
    return struct {
        pub fn native(stream: [*c]c.Stream, nread: isize, buf: [*c]const c.Buffer) callconv(.C) void {
            if (nread < 0)
                callback(.{ .cStream = stream }, 0, .{ .cBuf = @constCast(buf) }, HandleError(@intCast(nread)))
            else
                callback(.{ .cStream = stream }, @intCast(nread), .{ .cBuf = @constCast(buf) }, null);
        }
    };
}
