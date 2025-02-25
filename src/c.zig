/// Redefine names of functions/types of uv.h
/// It allows to directly call the c API if you know what you're doing
///
/// This file follow the same order as https://docs.libuv.org/en/v1.x/api.html

//                          ----------------   Declarations   ----------------

const std = @import("std");
const builtin = @import("builtin");

pub const c = @import("c");

//                ----------------  Error Handling - https://docs.libuv.org/en/v1.x/errors.html  ----------------

pub const Error = enum(c_int) {
    Ok = 0,
    ArgListTooLong = c.UV_E2BIG,
    PermissionDenied = c.UV_EACCES,
    AddressAlreayInUse = c.UV_EADDRINUSE,
    AddressNotAvailable = c.UV_EADDRNOTAVAIL,
    AdressFamilyNotSupported = c.UV_EAFNOSUPPORT,
    RessTemporaryUnavailable = c.UV_EAGAIN,
    AdressFamilyNotSupported2 = c.UV_EAI_ADDRFAMILY,
    TempFailure = c.UV_EAI_AGAIN,
    BadAIFlags = c.UV_EAI_BADFLAGS,
    InvalidValueHints = c.UV_EAI_BADHINTS,
    RequestCanceled = c.UV_EAI_CANCELED,
    PermanentFailure = c.UV_EAI_FAIL,
    AIFamilyUnsupported = c.UV_EAI_FAMILY,
    OutOfMemory = c.UV_EAI_MEMORY,
    NoAddress = c.UV_EAI_NODATA,
    UnknowNodeOrService = c.UV_EAI_NONAME,
    ArgBufferOverflow = c.UV_EAI_OVERFLOW,
    UnknowProtocol = c.UV_EAI_PROTOCOL,
    WrongServiceForSocketType = c.UV_EAI_SERVICE,
    UnsupportedSocketType = c.UV_EAI_SOCKTYPE,
    ConnAlreadyInProgress = c.UV_EALREADY,
    BadFileDescriptor = c.UV_EBADF,
    RessBusyOrLocked = c.UV_EBUSY,
    OperationCanceled = c.UV_ECANCELED,
    InvalidUnicodeChar = c.UV_ECHARSET,
    ConnectionAbortedSoftware = c.UV_ECONNABORTED,
    ConnectionRefused = c.UV_ECONNREFUSED,
    ConnectionResetByPeer = c.UV_ECONNRESET,
    DestinationAddressRequired = c.UV_EDESTADDRREQ,
    FileAlreadyExists = c.UV_EEXIST,
    BadAddress = c.UV_EFAULT,
    FileTooLarge = c.UV_EFBIG,
    HostUnreachable = c.UV_EHOSTUNREACH,
    InterruptedSyscall = c.UV_EINTR,
    InvalidArgument = c.UV_EINVAL,
    IOError = c.UV_EIO,
    SocketAlreadyConnected = c.UV_EISCONN,
    IllegalOperationOnDir = c.UV_EISDIR,
    TooManySymlink = c.UV_ELOOP,
    TooManyOpenedFiles = c.UV_EMFILE,
    MessageTooLong = c.UV_EMSGSIZE,
    NameTooLong = c.UV_ENAMETOOLONG,
    NetworkDown = c.UV_ENETDOWN,
    NetworkUnreachable = c.UV_ENETUNREACH,
    FileTableOverflow = c.UV_ENFILE,
    NoBufferSpaceAvailable = c.UV_ENOBUFS,
    NoSuchDevice = c.UV_ENODEV,
    NoSuchFile = c.UV_ENOENT,
    NotEnoughMem = c.UV_ENOMEM,
    MachineIsNotOnNetwork = c.UV_ENONET,
    ProtocolNotAvailable = c.UV_ENOPROTOOPT,
    NoSpaceLeftOnDevice = c.UV_ENOSPC,
    FunctionNotImplemented = c.UV_ENOSYS,
    SocketNotConnected = c.UV_ENOTCONN,
    NotADir = c.UV_ENOTDIR,
    DirNotEmpty = c.UV_ENOTEMPTY,
    SockOperationOnNonSock = c.UV_ENOTSOCK,
    OperationNotSupportedOnSock = c.UV_ENOTSUP,
    ValueTooLarge = c.UV_EOVERFLOW,
    OperationNotPermitted = c.UV_EPERM,
    BrokenPipe = c.UV_EPIPE,
    ProtocolError = c.UV_EPROTO,
    ProtocolUnsupported = c.UV_EPROTONOSUPPORT,
    ProtocolWrongTypeForSocket = c.UV_EPROTOTYPE,
    ResultTooLarge = c.UV_ERANGE,
    ReadyOnlyFilesystem = c.UV_EROFS,
    CannotSendAfterShutdown = c.UV_ESHUTDOWN,
    InvalidSeek = c.UV_ESPIPE,
    NoSuchProcess = c.UV_ESRCH,
    ConnectionTimedOut = c.UV_ETIMEDOUT,
    TextFileBusy = c.UV_ETXTBSY,
    CrossLinkNotPermited = c.UV_EXDEV,
    Unknow = c.UV_UNKNOWN,
    EndOfFile = c.UV_EOF,
    NoSuchDeviceOrAddress = c.UV_ENXIO,
    TooManySymlinks = c.UV_EMLINK,
    UV_EHOSTDOWN = c.UV_EHOSTDOWN,
    UV_EREMOTEIO = c.UV_EREMOTEIO,
    WrongIOCTLForDevice = c.UV_ENOTTY,
    BadFileTypeOrFormat = c.UV_EFTYPE,
    IllegalByteSequence = c.UV_EILSEQ,
    SocketTypeNotSupported = c.UV_ESOCKTNOSUPPORT,
    UV_ENODATA = c.UV_ENODATA,
    ProtocolDriverNotAttached = c.UV_EUNATCH,
    UV_ERRNO_MAX = c.UV_ERRNO_MAX,
};

//                ---------------- Version Checking - https://docs.libuv.org/en/v1.x/version.html ----------------

pub const VersionMajor = @as(u8, c.UV_VERSION_MAJOR);
pub const VersionMinor = @as(u8, c.UV_VERSION_MINOR);
pub const VersionPatch = @as(u8, c.UV_VERSION_PATCH);

pub const IsRelease = c.UV_VERSION_IS_RELEASE == 1;

pub const VersionSuffix = c.UV_VERSION_SUFFIX;

pub const VersionString = c.uv_version_string;

//                ----------------   Event Loop - https://docs.libuv.org/en/v1.x/loop.html   ----------------

pub const Loop = c.uv_loop_t;

pub const LoopInit = c.uv_loop_init;
pub const LoopConfigure = c.uv_loop_configure;
pub const LoopClose = c.uv_loop_close;
pub const DefaultLoop = c.uv_default_loop;

const RunModeType = if (@import("builtin").abi == .msvc) c_int else c_uint;

pub const RunMode = enum(RunModeType) {
    Default = c.UV_RUN_DEFAULT,
    Once = c.UV_RUN_ONCE,
    NoWait = c.UV_RUN_NOWAIT,
};
pub const Run = c.uv_run;

pub const LoopAlive = c.uv_loop_alive;
pub const Stop = c.uv_stop;
pub const LoopSize = c.uv_loop_size;
pub const BackendFd = c.uv_backend_fd;
pub const BackendTimeout = c.uv_backend_timeout;
pub const Now = c.uv_now;
pub const UpdateTime = c.uv_update_time;
pub const Walk = c.uv_walk;
pub const LoopFork = c.uv_loop_fork;

//                ----------------   Base Handle - https://docs.libuv.org/en/v1.x/handle.html   ----------------

pub const Handle = c.uv_handle_t;

pub const HandleType = enum(c_int) {
    Unknow = c.UV_UNKNOWN_HANDLE,
    Async = c.UV_ASYNC,
    Check = c.UV_CHECK,
    FsEvent = c.UV_FS_EVENT,
    FsPoll = c.UV_FS_POLL,
    Handle = c.UV_HANDLE,
    Idle = c.UV_IDLE,
    NamePipe = c.UV_NAMED_PIPE,
    Poll = c.UV_POLL,
    Prepare = c.UV_PREPARE,
    Process = c.UV_PROCESS,
    Stream = c.UV_STREAM,
    TCP = c.UV_TCP,
    Timer = c.UV_TIMER,
    TTY = c.UV_TTY,
    UDP = c.UV_UDP,
    Signal = c.UV_SIGNAL,
    File = c.UV_FILE,
    HandleTypeMax = c.UV_HANDLE_TYPE_MAX,
};

pub const AnyHandle = c.uv_any_handle;

pub const AllocCb = c.uv_alloc_cb;
pub const CloseCb = c.uv_close_cb;

pub const IsActive = c.uv_is_active;
pub const IsClosing = c.uv_is_closing;
pub const Close = c.uv_close;
pub const Ref = c.uv_ref;
pub const Unref = c.uv_unref;
pub const HasRef = c.uv_has_ref;
pub const HandleSize = c.uv_handle_size;
pub const TypeName = c.uv_handle_type_name;

//                ----------------   Base Request - https://docs.libuv.org/en/v1.x/request.html   ----------------

pub const Request = c.uv_req_t;
pub const AnyRequest = c.union_uv_any_req;

pub const RequestType = enum(c_int) {
    Unknow = c.UV_UNKNOWN_REQ,
    Req = c.UV_REQ,
    Connect = c.UV_CONNECT,
    Write = c.UV_WRITE,
    Shutdown = c.UV_SHUTDOWN,
    UdpSend = c.UV_UDP_SEND,
    FS = c.UV_FS,
    Work = c.UV_WORK,
    GetAddrInfp = c.UV_GETADDRINFO,
    GetNameInfo = c.UV_GETNAMEINFO,
    Random = c.UV_RANDOM,
    Accept = c.UV_ACCEPT,
    FsEventReq = c.UV_FS_EVENT_REQ,
    PollReq = c.UV_POLL_REQ,
    ProcessExit = c.UV_PROCESS_EXIT,
    Read = c.UV_READ,
    UDPReceive = c.UV_UDP_RECV,
    WakeUp = c.UV_WAKEUP,
    SignalReq = c.UV_SIGNAL_REQ,
    ReqTypeMax = c.UV_REQ_TYPE_MAX,
};

pub const Cancel = c.uv_cancel;
pub const ReqSize = c.uv_req_size;
pub const ReqTypeName = c.uv_req_type_name;

//                ----------------   Timer - https://docs.libuv.org/en/v1.x/handle.html   ----------------

pub const Timer = c.uv_timer_t;
pub const TimerCb = c.uv_timer_cb;

pub const TimerInit = c.uv_timer_init;
pub const TimerStart = c.uv_timer_start;
pub const TimerStop = c.uv_timer_stop;
pub const TimerAgain = c.uv_timer_again;
pub const TimerSetRepeat = c.uv_timer_set_repeat;
pub const TimerGetRepeat = c.uv_timer_get_repeat;
pub const TimerGetDueIn = c.uv_timer_get_due_in;

//                ---------------- Prepare handle - http://docs.libuv.org/en/v1.x/prepare.html ----------------

pub const Prepare = c.uv_prepare_t;
pub const PrepareCb = c.uv_prepare_cb;

pub const PrepareInit = c.uv_prepare_init;
pub const PrepareStart = c.uv_prepare_start;
pub const PrepareStop = c.uv_prepare_stop;

//                ----------------   Check - http://docs.libuv.org/en/v1.x/check.html    ----------------

pub const Check = c.uv_check_t;
pub const CheckCb = c.uv_check_cb;

pub const CheckInit = c.uv_check_init;
pub const CheckStart = c.uv_check_start;
pub const CheckStop = c.uv_check_stop;

//                ----------------     Idle - http://docs.libuv.org/en/v1.x/idle.html     ----------------

pub const Idle = c.uv_idle_t;
pub const IdleCb = c.uv_idle_cb;

pub const IdleInit = c.uv_idle_init;
pub const IdleStart = c.uv_idle_start;
pub const IdleStop = c.uv_idle_stop;

//                ----------------     Async - http://docs.libuv.org/en/v1.x/idle.html     ----------------

pub const Async = c.uv_async_t;
pub const AsyncCb = c.uv_async_cb;

pub const AsyncInit = c.uv_async_init;
pub const AsyncSend = c.uv_async_send;

//                ----------------   Signal - http://docs.libuv.org/en/v1.x/signal.html    ----------------

pub const SignalType = enum(c_int) {
    Interruption = c.SIGINT,
    Ill = c.SIGILL,
    ArithmeticError = c.SIGFPE,
    SegmentationFault = c.SIGSEGV,
    Terminate = c.SIGTERM,
    Break = c.SIGBREAK,
    Abort = c.SIGABRT,
};

pub const Signal = c.uv_signal_t;
pub const SignalCb = c.uv_signal_cb;

pub const SignalInit = c.uv_signal_init;
pub const SignalStart = c.uv_signal_start;
pub const SignalStartOneShot = c.uv_signal_start_oneshot;
pub const SignalStop = c.uv_signal_stop;

//                ----------------   Process - http://docs.libuv.org/en/v1.x/signal.html    ----------------

pub const Process = c.uv_process_t;
pub const ProcessOption = c.uv_process_options_t;

pub const ProcessCb = c.uv_exit_cb;

pub const ProcessFlags = struct {
    pub const SetUID = c.UV_PROCESS_SETUID;
    pub const SetGID = c.UV_PROCESS_GID;
    pub const WindowsVerbatimArguments = c.UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS;
    pub const Detached = c.UV_PROCESS_DETACHED;
    pub const WindowsHide = c.UV_PROCESS_WINDOWS_HIDE;
    pub const WindowsHideConsole = c.UV_PROCESS_WINDOWS_HIDE_CONSOLE;
    pub const WindowsHideGUI = c.UV_PROCESS_WINDOWS_HIDE_GUI;
};

pub const StdioContainer = c.uv_stdio_container_t;

pub const StdioFlags = struct {
    pub const Ignore = c.UV_IGNORE;
    pub const CreatePipe = c.UV_CREATE_PIPE;
    pub const InheritFd = c.UV_INHERIT_FD;
    pub const InheritStream = c.UV_INHERIT_STREAM;
    pub const ReadablePipe = c.UV_READABLE_PIPE;
    pub const WritablePipe = c.UV_WRITABLE_PIPE;
    pub const NonBlockingPipe = c.UV_NONBLOCK_PIPE;
};

pub const DisableStdioInheritance = c.uv_disable_stdio_inheritance;

pub const Spawn = c.uv_spawn;
pub const ProcessKill = c.uv_process_kill;
pub const Kill = c.uv_kill;

//                ----------------   Stream - https://docs.libuv.org/en/v1.x/stream.html   ----------------

pub const MaxBacklog = c.SOMAXCONN;

pub const Stream = c.uv_stream_t;
pub const ConnectT = c.uv_connect_t;
pub const ShutdownT = c.uv_shutdown_t;
pub const WriteT = c.uv_write_t;

pub const ReadCb = c.uv_read_cb;
pub const WriteCb = c.uv_write_cb;
pub const ConnectCb = c.uv_connect_cb;
pub const ShutdownCb = c.uv_shutdown_cb;
pub const InConnectCb = c.uv_connection_cb;

pub const Shutdown = c.uv_shutdown;
pub const Listen = c.uv_listen;
pub const Accept = c.uv_accept;
pub const ReadStart = c.uv_read_start;
pub const ReadStop = c.uv_read_stop;
pub const Write = c.uv_write;
pub const SendHandle = c.uv_write2;
pub const TryWrite = c.uv_try_write;
pub const TrySendHandle = c.uv_try_write2;
pub const IsReadable = c.uv_is_readable;
pub const IsWritable = c.uv_is_writable;
pub const SetBlocking = c.uv_stream_set_blocking;

//                ----------------    Tcp - https://docs.libuv.org/en/v1.x/tcp.html    ----------------

pub const Tcp = c.uv_tcp_t;

pub const TcpInit = c.uv_tcp_init;
pub const TcpInitEx = c.uv_tcp_init_ex;
pub const TcpOpen = c.uv_tcp_open;
pub const TcpNoDelay = c.uv_tcp_nodelay;
pub const TcpKeepAlive = c.uv_tcp_keepalive;
pub const TcpSimultaneousAccepts = c.uv_tcp_simultaneous_accepts;
pub const TcpBind = c.uv_tcp_bind;
pub const TcpGetSockName = c.uv_tcp_getsockname;
pub const TcpGetPeerName = c.uv_tcp_getpeername;
pub const TcpConnect = c.uv_tcp_connect;
pub const TcpCloseReset = c.uv_tcp_close_reset;
pub const SocketPair = c.uv_socketpair;

//                ----------------   Misc - https://docs.libuv.org/en/v1.x/misc.html   ----------------

pub const Buffer = c.uv_buf_t;

pub const SocketAddressIn = c.sockaddr_in;
pub const StrToAddress = c.uv_ip4_addr;
pub const AddressToStr4 = c.uv_ip4_name;

pub const SocketAddressIn6 = c.sockaddr_in6;
pub const StrToAddress6 = c.uv_ip6_addr;
pub const AddressToStr6 = c.uv_ip6_name;

pub const AddressToStr = c.uv_ip_name;
