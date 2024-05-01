extension Sqlite {
    public enum ErrorCode: Int32 {
        /// SQLITE_OK, 0, 操作成功
        case OK = 0x0
        
        /// SQLITE_ERROR, 1, 通用错误
        case ERROR = 0x1
        
        /// SQLITE_INTERNAL, 2, SQLite 内部逻辑错误
        case INTERNAL = 0x2
        
        /// SQLITE_PERM, 3, 访问权限被拒绝
        case PERM = 0x3
        
        /// SQLITE_ABORT, 4, 回调函数请求中止操作
        case ABORT = 0x4
        
        /// SQLITE_BUSY, 5, 数据库文件被锁定
        case BUSY = 0x5
        
        /// SQLITE_LOCKED, 6, 数据库中的表被锁定
        case LOCKED = 0x6
        
        /// SQLITE_NOMEM, 7, 内存分配失败
        case NOMEM = 0x7
        
        /// SQLITE_READONLY, 8, 试图写入只读数据库
        case READONLY = 0x8
        
        /// SQLITE_INTERRUPT, 9, 操作被 sqlite3_interrupt() 终止
        case INTERRUPT = 0x9
        
        /// SQLITE_IOERR, 10, 发生某种类型的磁盘 I/O 错误
        case IOERR = 0xA
        
        /// SQLITE_CORRUPT, 11, 数据库磁盘映像损坏
        case CORRUPT = 0xB
        
        /// SQLITE_NOTFOUND, 12, sqlite3_file_control() 中的未知操作码
        case NOTFOUND = 0xC
        
        /// SQLITE_FULL, 13, 数据库已满，插入操作失败
        case FULL = 0xD
        
        /// SQLITE_CANTOPEN, 14, 无法打开数据库文件
        case CANTOPEN = 0xE
        
        /// SQLITE_PROTOCOL, 15, 数据库锁定协议错误
        case PROTOCOL = 0xF
        
        /// SQLITE_EMPTY, 16, 仅供内部使用
        case EMPTY = 0x10
        
        /// SQLITE_SCHEMA, 17, 数据库架构已更改
        case SCHEMA = 0x11
        
        /// SQLITE_TOOBIG, 18, 字符串或 BLOB 超过大小限制
        case TOOBIG = 0x12
        
        /// SQLITE_CONSTRAINT, 19, 由于约束违规而中止
        case CONSTRAINT = 0x13
        
        /// SQLITE_MISMATCH, 20, 数据类型不匹配
        case MISMATCH = 0x14
        
        /// SQLITE_MISUSE, 21, 库的错误使用
        case MISUSE = 0x15
        
        /// SQLITE_NOLFS, 22, 使用主机不支持的 OS 功能
        case NOLFS = 0x16
        
        /// SQLITE_AUTH, 23, 授权被拒绝
        case AUTH = 0x17
        
        /// SQLITE_FORMAT, 24, 不使用
        case FORMAT = 0x18
        
        /// SQLITE_RANGE, 25, sqlite3_bind 的第二个参数超出范围
        case RANGE = 0x19
        
        /// SQLITE_NOTADB, 26, 打开的文件不是数据库文件
        case NOTADB = 0x1A
        
        /// SQLITE_NOTICE, 27, 来自 sqlite3_log() 的通知
        case NOTICE = 0x1B
        
        /// SQLITE_WARNING, 28, 来自 sqlite3_log() 的警告
        case WARNING = 0x1C
        
        /// SQLITE_ROW, 100, sqlite3_step() 有另一行数据可用
        case ROW = 0x64
        
        /// SQLITE_DONE, 101, sqlite3_step() 执行完成
        case DONE = 0x65
        
        
        /// SQLITE_ERROR_MISSING_COLLSEQ (SQLITE_ERROR | (1<<8))
        case ERROR_MISSING_COLLSEQ = 0x101
        
        /// SQLITE_ERROR_RETRY (SQLITE_ERROR | (2<<8))
        case ERROR_RETRY = 0x201
        
        /// SQLITE_ERROR_SNAPSHOT (SQLITE_ERROR | (3<<8))
        case ERROR_SNAPSHOT = 0x301
        
        
        /// SQLITE_IOERR_READ (SQLITE_IOERR | (1<<8))
        case IOERR_READ = 0x10A
        
        /// SQLITE_IOERR_SHORT_READ (SQLITE_IOERR | (2<<8))
        case IOERR_SHORT_READ = 0x20A
        
        /// SQLITE_IOERR_WRITE (SQLITE_IOERR | (3<<8))
        case IOERR_WRITE = 0x30A
        
        /// SQLITE_IOERR_FSYNC (SQLITE_IOERR | (4<<8))
        case IOERR_FSYNC = 0x40A
        
        /// SQLITE_IOERR_DIR_FSYNC (SQLITE_IOERR | (5<<8))
        case IOERR_DIR_FSYNC = 0x50A
        
        /// SQLITE_IOERR_TRUNCATE (SQLITE_IOERR | (6<<8))
        case IOERR_TRUNCATE = 0x60A
        
        /// SQLITE_IOERR_FSTAT (SQLITE_IOERR | (7<<8))
        case IOERR_FSTAT = 0x70A
        
        /// SQLITE_IOERR_UNLOCK (SQLITE_IOERR | (8<<8))
        case IOERR_UNLOCK = 0x80A
        
        /// SQLITE_IOERR_RDLOCK (SQLITE_IOERR | (9<<8))
        case IOERR_RDLOCK = 0x90A
        
        /// SQLITE_IOERR_DELETE (SQLITE_IOERR | (10<<8))
        case IOERR_DELETE = 0xA0A
        
        /// SQLITE_IOERR_BLOCKED (SQLITE_IOERR | (11<<8))
        case IOERR_BLOCKED = 0xB0A
        
        /// SQLITE_IOERR_NOMEM (SQLITE_IOERR | (12<<8))
        case IOERR_NOMEM = 0xC0A
        
        /// SQLITE_IOERR_ACCESS (SQLITE_IOERR | (13<<8))
        case IOERR_ACCESS = 0xD0A
        
        /// SQLITE_IOERR_CHECKRESERVEDLOCK (SQLITE_IOERR | (14<<8))
        case IOERR_CHECKRESERVEDLOCK = 0xE0A
        
        /// SQLITE_IOERR_LOCK (SQLITE_IOERR | (15<<8))
        case IOERR_LOCK = 0xF0A
        
        /// SQLITE_IOERR_CLOSE (SQLITE_IOERR | (16<<8))
        case IOERR_CLOSE = 0x100A
        
        /// SQLITE_IOERR_DIR_CLOSE (SQLITE_IOERR | (17<<8))
        case IOERR_DIR_CLOSE = 0x110A
        
        /// SQLITE_IOERR_SHMOPEN (SQLITE_IOERR | (18<<8))
        case IOERR_SHMOPEN = 0x120A
        
        /// SQLITE_IOERR_SHMSIZE (SQLITE_IOERR | (19<<8))
        case IOERR_SHMSIZE = 0x130A
        
        /// SQLITE_IOERR_SHMLOCK (SQLITE_IOERR | (20<<8))
        case IOERR_SHMLOCK = 0x140A
        
        /// SQLITE_IOERR_SHMMAP (SQLITE_IOERR | (21<<8))
        case IOERR_SHMMAP = 0x150A
        
        /// SQLITE_IOERR_SEEK (SQLITE_IOERR | (22<<8))
        case IOERR_SEEK = 0x160A
        
        /// SQLITE_IOERR_DELETE_NOENT (SQLITE_IOERR | (23<<8))
        case IOERR_DELETE_NOENT = 0x170A
        
        /// SQLITE_IOERR_MMAP (SQLITE_IOERR | (24<<8))
        case IOERR_MMAP = 0x180A
        
        /// SQLITE_IOERR_GETTEMPPATH (SQLITE_IOERR | (25<<8))
        case IOERR_GETTEMPPATH = 0x190A
        
        /// SQLITE_IOERR_CONVPATH (SQLITE_IOERR | (26<<8))
        case IOERR_CONVPATH = 0x1A0A
        
        /// SQLITE_IOERR_VNODE (SQLITE_IOERR | (27<<8))
        case IOERR_VNODE = 0x1B0A
        
        /// SQLITE_IOERR_AUTH (SQLITE_IOERR | (28<<8))
        case IOERR_AUTH = 0x1C0A
        
        /// SQLITE_IOERR_BEGIN_ATOMIC (SQLITE_IOERR | (29<<8))
        case IOERR_BEGIN_ATOMIC = 0x1D0A
        
        /// SQLITE_IOERR_COMMIT_ATOMIC (SQLITE_IOERR | (30<<8))
        case IOERR_COMMIT_ATOMIC = 0x1E0A
        
        /// SQLITE_IOERR_ROLLBACK_ATOMIC (SQLITE_IOERR | (31<<8))
        case IOERR_ROLLBACK_ATOMIC = 0x1F0A
        
        /// SQLITE_IOERR_DATA (SQLITE_IOERR | (32<<8))
        case IOERR_DATA = 0x200A
        
        /// SQLITE_IOERR_CORRUPTFS (SQLITE_IOERR | (33<<8))
        case IOERR_CORRUPTFS = 0x210A
        
        
        /// SQLITE_LOCKED_SHAREDCACHE (SQLITE_LOCKED |  (1<<8))
        case LOCKED_SHAREDCACHE = 0x106
        
        /// SQLITE_LOCKED_VTAB (SQLITE_LOCKED |  (2<<8))
        case LOCKED_VTAB = 0x206
        
        
        /// SQLITE_BUSY_RECOVERY (SQLITE_BUSY   |  (1<<8))
        case BUSY_RECOVERY = 0x105
        
        /// SQLITE_BUSY_SNAPSHOT (SQLITE_BUSY   |  (2<<8))
        case BUSY_SNAPSHOT = 0x205
        
        /// SQLITE_BUSY_TIMEOUT (SQLITE_BUSY   |  (3<<8))
        case BUSY_TIMEOUT = 0x305
        
        
        /// SQLITE_CANTOPEN_NOTEMPDIR (SQLITE_CANTOPEN | (1<<8))
        case CANTOPEN_NOTEMPDIR = 0x10E
        
        /// SQLITE_CANTOPEN_ISDIR (SQLITE_CANTOPEN | (2<<8))
        case CANTOPEN_ISDIR = 0x20E
        
        /// SQLITE_CANTOPEN_FULLPATH (SQLITE_CANTOPEN | (3<<8))
        case CANTOPEN_FULLPATH = 0x30E
        
        /// SQLITE_CANTOPEN_CONVPATH (SQLITE_CANTOPEN | (4<<8))
        case CANTOPEN_CONVPATH = 0x40E
        
        /// SQLITE_CANTOPEN_DIRTYWAL (SQLITE_CANTOPEN | (5<<8)) /* Not Used */
        case CANTOPEN_DIRTYWAL = 0x50E
        
        /// SQLITE_CANTOPEN_SYMLINK (SQLITE_CANTOPEN | (6<<8))
        case CANTOPEN_SYMLINK = 0x60E
        
        /// SQLITE_CORRUPT_VTAB (SQLITE_CORRUPT | (1<<8))
        case CORRUPT_VTAB = 0x10B
        
        /// SQLITE_CORRUPT_SEQUENCE (SQLITE_CORRUPT | (2<<8))
        case CORRUPT_SEQUENCE = 0x20B
        
        /// SQLITE_CORRUPT_INDEX (SQLITE_CORRUPT | (3<<8))
        case CORRUPT_INDEX = 0x30B
        
        /// SQLITE_READONLY_RECOVERY (SQLITE_READONLY | (1<<8))
        case READONLY_RECOVERY = 0x108
        
        /// SQLITE_READONLY_CANTLOCK (SQLITE_READONLY | (2<<8))
        case READONLY_CANTLOCK = 0x208
        
        /// SQLITE_READONLY_ROLLBACK (SQLITE_READONLY | (3<<8))
        case READONLY_ROLLBACK = 0x308
        
        /// SQLITE_READONLY_DBMOVED (SQLITE_READONLY | (4<<8))
        case READONLY_DBMOVED = 0x408
        
        /// SQLITE_READONLY_CANTINIT (SQLITE_READONLY | (5<<8))
        case READONLY_CANTINIT = 0x508
        
        /// SQLITE_READONLY_DIRECTORY (SQLITE_READONLY | (6<<8))
        case READONLY_DIRECTORY = 0x608
        
        
        /// SQLITE_ABORT_ROLLBACK (SQLITE_ABORT | (2<<8))
        case ABORT_ROLLBACK = 0x204
        
        
        /// SQLITE_CONSTRAINT_CHECK (SQLITE_CONSTRAINT | (1<<8))
        case CONSTRAINT_CHECK = 0x113
        
        /// SQLITE_CONSTRAINT_COMMITHOOK (SQLITE_CONSTRAINT | (2<<8))
        case CONSTRAINT_COMMITHOOK = 0x213
        
        /// SQLITE_CONSTRAINT_FOREIGNKEY (SQLITE_CONSTRAINT | (3<<8))
        case CONSTRAINT_FOREIGNKEY = 0x313
        
        /// SQLITE_CONSTRAINT_FUNCTION (SQLITE_CONSTRAINT | (4<<8))
        case CONSTRAINT_FUNCTION = 0x413
        
        /// SQLITE_CONSTRAINT_NOTNULL (SQLITE_CONSTRAINT | (5<<8))
        case CONSTRAINT_NOTNULL = 0x513
        
        /// SQLITE_CONSTRAINT_PRIMARYKEY (SQLITE_CONSTRAINT | (6<<8))
        case CONSTRAINT_PRIMARYKEY = 0x613
        
        /// SQLITE_CONSTRAINT_TRIGGER (SQLITE_CONSTRAINT | (7<<8))
        case CONSTRAINT_TRIGGER = 0x713
        
        /// SQLITE_CONSTRAINT_UNIQUE (SQLITE_CONSTRAINT | (8<<8))
        case CONSTRAINT_UNIQUE = 0x813
        
        /// SQLITE_CONSTRAINT_VTAB (SQLITE_CONSTRAINT | (9<<8))
        case CONSTRAINT_VTAB = 0x913
        
        /// SQLITE_CONSTRAINT_ROWID (SQLITE_CONSTRAINT |(10<<8))
        case CONSTRAINT_ROWID = 0xA13
        
        /// SQLITE_CONSTRAINT_PINNED (SQLITE_CONSTRAINT |(11<<8))
        case CONSTRAINT_PINNED = 0xB13
        
        /// SQLITE_CONSTRAINT_DATATYPE (SQLITE_CONSTRAINT |(12<<8))
        case CONSTRAINT_DATATYPE = 0xC13
        
        
        /// SQLITE_NOTICE_RECOVER_WAL (SQLITE_NOTICE | (1<<8))
        case NOTICE_RECOVER_WAL = 0x11B
        
        /// SQLITE_NOTICE_RECOVER_ROLLBACK (SQLITE_NOTICE | (2<<8))
        case NOTICE_RECOVER_ROLLBACK = 0x21B
        
        
        /// SQLITE_WARNING_AUTOINDEX (SQLITE_WARNING | (1<<8))
        case WARNING_AUTOINDEX = 0x11C
        
        
        /// SQLITE_AUTH_USER (SQLITE_AUTH | (1<<8))
        case AUTH_USER = 0x117
        
        
        /// SQLITE_OK_LOAD_PERMANENTLY (SQLITE_OK | (1<<8))
        case OK_LOAD_PERMANENTLY = 0x100
    }
}
