import Foundation
import SQLite3

extension Sqlite {
    public struct SqliteError: OptionSet, Error, LocalizedError {
        public let rawValue: Int32
        public let message: String
        public let sql: String
        
        public var errorDescription: String? {
            return """
            [SQLite Error]
            Code: \(rawValue)
            Message: \(message)
            SQL: \(sql)
            """
        }
        
        public init(rawValue: Int32) {
            self.rawValue = rawValue
            self.message = ""
            self.sql = ""
        }
        
        public init(rawValue: Int32, message: String, sql: String) {
            self.rawValue = rawValue
            self.message = message
            self.sql = sql
        }
        
        /// SQLITE_OK, 0, 操作成功
        public static let OK = SqliteError(rawValue: SQLITE_OK)

        /// SQLITE_ERROR, 1, 通用错误
        public static let ERROR = SqliteError(rawValue: SQLITE_ERROR)

        /// SQLITE_INTERNAL, 2, SQLite 内部逻辑错误
        public static let INTERNAL = SqliteError(rawValue: SQLITE_INTERNAL)

        /// SQLITE_PERM, 3, 访问权限被拒绝
        public static let PERM = SqliteError(rawValue: SQLITE_PERM)

        /// SQLITE_ABORT, 4, 回调函数请求中止操作
        public static let ABORT = SqliteError(rawValue: SQLITE_ABORT)

        /// SQLITE_BUSY, 5, 数据库文件被锁定
        public static let BUSY = SqliteError(rawValue: SQLITE_BUSY)

        /// SQLITE_LOCKED, 6, 数据库中的表被锁定
        public static let LOCKED = SqliteError(rawValue: SQLITE_LOCKED)

        /// SQLITE_NOMEM, 7, 内存分配失败
        public static let NOMEM = SqliteError(rawValue: SQLITE_NOMEM)

        /// SQLITE_READONLY, 8, 试图写入只读数据库
        public static let READONLY = SqliteError(rawValue: SQLITE_READONLY)

        /// SQLITE_INTERRUPT, 9, 操作被 sqlite3_interrupt() 终止
        public static let INTERRUPT = SqliteError(rawValue: SQLITE_INTERRUPT)

        /// SQLITE_IOERR, 10, 发生某种类型的磁盘 I/O 错误
        public static let IOERR = SqliteError(rawValue: SQLITE_IOERR)

        /// SQLITE_CORRUPT, 11, 数据库磁盘映像损坏
        public static let CORRUPT = SqliteError(rawValue: SQLITE_CORRUPT)

        /// SQLITE_NOTFOUND, 12, sqlite3_file_control() 中的未知操作码
        public static let NOTFOUND = SqliteError(rawValue: SQLITE_NOTFOUND)

        /// SQLITE_FULL, 13, 数据库已满，插入操作失败
        public static let FULL = SqliteError(rawValue: SQLITE_FULL)

        /// SQLITE_CANTOPEN, 14, 无法打开数据库文件
        public static let CANTOPEN = SqliteError(rawValue: SQLITE_CANTOPEN)

        /// SQLITE_PROTOCOL, 15, 数据库锁定协议错误
        public static let PROTOCOL = SqliteError(rawValue: SQLITE_PROTOCOL)

        /// SQLITE_EMPTY, 16, 仅供内部使用
        public static let EMPTY = SqliteError(rawValue: SQLITE_EMPTY)

        /// SQLITE_SCHEMA, 17, 数据库架构已更改
        public static let SCHEMA = SqliteError(rawValue: SQLITE_SCHEMA)

        /// SQLITE_TOOBIG, 18, 字符串或 BLOB 超过大小限制
        public static let TOOBIG = SqliteError(rawValue: SQLITE_TOOBIG)

        /// SQLITE_CONSTRAINT, 19, 由于约束违规而中止
        public static let CONSTRAINT = SqliteError(rawValue: SQLITE_CONSTRAINT)

        /// SQLITE_MISMATCH, 20, 数据类型不匹配
        public static let MISMATCH = SqliteError(rawValue: SQLITE_MISMATCH)

        /// SQLITE_MISUSE, 21, 库的错误使用
        public static let MISUSE = SqliteError(rawValue: SQLITE_MISUSE)

        /// SQLITE_NOLFS, 22, 使用主机不支持的 OS 功能
        public static let NOLFS = SqliteError(rawValue: SQLITE_NOLFS)

        /// SQLITE_AUTH, 23, 授权被拒绝
        public static let AUTH = SqliteError(rawValue: SQLITE_AUTH)

        /// SQLITE_FORMAT, 24, 不使用
        public static let FORMAT = SqliteError(rawValue: SQLITE_FORMAT)

        /// SQLITE_RANGE, 25, sqlite3_bind 的第二个参数超出范围
        public static let RANGE = SqliteError(rawValue: SQLITE_RANGE)

        /// SQLITE_NOTADB, 26, 打开的文件不是数据库文件
        public static let NOTADB = SqliteError(rawValue: SQLITE_NOTADB)

        /// SQLITE_NOTICE, 27, 来自 sqlite3_log() 的通知
        public static let NOTICE = SqliteError(rawValue: SQLITE_NOTICE)

        /// SQLITE_WARNING, 28, 来自 sqlite3_log() 的警告
        public static let WARNING = SqliteError(rawValue: SQLITE_WARNING)

        /// SQLITE_ROW, 100, sqlite3_step() 有另一行数据可用
        public static let ROW = SqliteError(rawValue: SQLITE_ROW)

        /// SQLITE_DONE, 101, sqlite3_step() 执行完成
        public static let DONE = SqliteError(rawValue: SQLITE_DONE)


        /// SQLITE_ERROR_MISSING_COLLSEQ (SQLITE_ERROR | (1<<8))
        public static let ERROR_MISSING_COLLSEQ = SqliteError(rawValue: 0x101)

        /// SQLITE_ERROR_RETRY (SQLITE_ERROR | (2<<8))
        public static let ERROR_RETRY = SqliteError(rawValue: 0x201)

        /// SQLITE_ERROR_SNAPSHOT (SQLITE_ERROR | (3<<8))
        public static let ERROR_SNAPSHOT = SqliteError(rawValue: 0x301)


        /// SQLITE_IOERR_READ (SQLITE_IOERR | (1<<8))
        public static let IOERR_READ = SqliteError(rawValue: 0x10A)

        /// SQLITE_IOERR_SHORT_READ (SQLITE_IOERR | (2<<8))
        public static let IOERR_SHORT_READ = SqliteError(rawValue: 0x20A)

        /// SQLITE_IOERR_WRITE (SQLITE_IOERR | (3<<8))
        public static let IOERR_WRITE = SqliteError(rawValue: 0x30A)

        /// SQLITE_IOERR_FSYNC (SQLITE_IOERR | (4<<8))
        public static let IOERR_FSYNC = SqliteError(rawValue: 0x40A)

        /// SQLITE_IOERR_DIR_FSYNC (SQLITE_IOERR | (5<<8))
        public static let IOERR_DIR_FSYNC = SqliteError(rawValue: 0x50A)

        /// SQLITE_IOERR_TRUNCATE (SQLITE_IOERR | (6<<8))
        public static let IOERR_TRUNCATE = SqliteError(rawValue: 0x60A)

        /// SQLITE_IOERR_FSTAT (SQLITE_IOERR | (7<<8))
        public static let IOERR_FSTAT = SqliteError(rawValue: 0x70A)

        /// SQLITE_IOERR_UNLOCK (SQLITE_IOERR | (8<<8))
        public static let IOERR_UNLOCK = SqliteError(rawValue: 0x80A)

        /// SQLITE_IOERR_RDLOCK (SQLITE_IOERR | (9<<8))
        public static let IOERR_RDLOCK = SqliteError(rawValue: 0x90A)

        /// SQLITE_IOERR_DELETE (SQLITE_IOERR | (10<<8))
        public static let IOERR_DELETE = SqliteError(rawValue: 0xA0A)

        /// SQLITE_IOERR_BLOCKED (SQLITE_IOERR | (11<<8))
        public static let IOERR_BLOCKED = SqliteError(rawValue: 0xB0A)

        /// SQLITE_IOERR_NOMEM (SQLITE_IOERR | (12<<8))
        public static let IOERR_NOMEM = SqliteError(rawValue: 0xC0A)

        /// SQLITE_IOERR_ACCESS (SQLITE_IOERR | (13<<8))
        public static let IOERR_ACCESS = SqliteError(rawValue: 0xD0A)

        /// SQLITE_IOERR_CHECKRESERVEDLOCK (SQLITE_IOERR | (14<<8))
        public static let IOERR_CHECKRESERVEDLOCK = SqliteError(rawValue: 0xE0A)

        /// SQLITE_IOERR_LOCK (SQLITE_IOERR | (15<<8))
        public static let IOERR_LOCK = SqliteError(rawValue: 0xF0A)

        /// SQLITE_IOERR_CLOSE (SQLITE_IOERR | (16<<8))
        public static let IOERR_CLOSE = SqliteError(rawValue: 0x100A)

        /// SQLITE_IOERR_DIR_CLOSE (SQLITE_IOERR | (17<<8))
        public static let IOERR_DIR_CLOSE = SqliteError(rawValue: 0x110A)

        /// SQLITE_IOERR_SHMOPEN (SQLITE_IOERR | (18<<8))
        public static let IOERR_SHMOPEN = SqliteError(rawValue: 0x120A)

        /// SQLITE_IOERR_SHMSIZE (SQLITE_IOERR | (19<<8))
        public static let IOERR_SHMSIZE = SqliteError(rawValue: 0x130A)

        /// SQLITE_IOERR_SHMLOCK (SQLITE_IOERR | (20<<8))
        public static let IOERR_SHMLOCK = SqliteError(rawValue: 0x140A)

        /// SQLITE_IOERR_SHMMAP (SQLITE_IOERR | (21<<8))
        public static let IOERR_SHMMAP = SqliteError(rawValue: 0x150A)

        /// SQLITE_IOERR_SEEK (SQLITE_IOERR | (22<<8))
        public static let IOERR_SEEK = SqliteError(rawValue: 0x160A)

        /// SQLITE_IOERR_DELETE_NOENT (SQLITE_IOERR | (23<<8))
        public static let IOERR_DELETE_NOENT = SqliteError(rawValue: 0x170A)

        /// SQLITE_IOERR_MMAP (SQLITE_IOERR | (24<<8))
        public static let IOERR_MMAP = SqliteError(rawValue: 0x180A)

        /// SQLITE_IOERR_GETTEMPPATH (SQLITE_IOERR | (25<<8))
        public static let IOERR_GETTEMPPATH = SqliteError(rawValue: 0x190A)

        /// SQLITE_IOERR_CONVPATH (SQLITE_IOERR | (26<<8))
        public static let IOERR_CONVPATH = SqliteError(rawValue: 0x1A0A)

        /// SQLITE_IOERR_VNODE (SQLITE_IOERR | (27<<8))
        public static let IOERR_VNODE = SqliteError(rawValue: 0x1B0A)

        /// SQLITE_IOERR_AUTH (SQLITE_IOERR | (28<<8))
        public static let IOERR_AUTH = SqliteError(rawValue: 0x1C0A)

        /// SQLITE_IOERR_BEGIN_ATOMIC (SQLITE_IOERR | (29<<8))
        public static let IOERR_BEGIN_ATOMIC = SqliteError(rawValue: 0x1D0A)

        /// SQLITE_IOERR_COMMIT_ATOMIC (SQLITE_IOERR | (30<<8))
        public static let IOERR_COMMIT_ATOMIC = SqliteError(rawValue: 0x1E0A)

        /// SQLITE_IOERR_ROLLBACK_ATOMIC (SQLITE_IOERR | (31<<8))
        public static let IOERR_ROLLBACK_ATOMIC = SqliteError(rawValue: 0x1F0A)

        /// SQLITE_IOERR_DATA (SQLITE_IOERR | (32<<8))
        public static let IOERR_DATA = SqliteError(rawValue: 0x200A)

        /// SQLITE_IOERR_CORRUPTFS (SQLITE_IOERR | (33<<8))
        public static let IOERR_CORRUPTFS = SqliteError(rawValue: 0x210A)


        /// SQLITE_LOCKED_SHAREDCACHE (SQLITE_LOCKED |  (1<<8))
        public static let LOCKED_SHAREDCACHE = SqliteError(rawValue: 0x106)

        /// SQLITE_LOCKED_VTAB (SQLITE_LOCKED |  (2<<8))
        public static let LOCKED_VTAB = SqliteError(rawValue: 0x206)


        /// SQLITE_BUSY_RECOVERY (SQLITE_BUSY   |  (1<<8))
        public static let BUSY_RECOVERY = SqliteError(rawValue: 0x105)

        /// SQLITE_BUSY_SNAPSHOT (SQLITE_BUSY   |  (2<<8))
        public static let BUSY_SNAPSHOT = SqliteError(rawValue: 0x205)

        /// SQLITE_BUSY_TIMEOUT (SQLITE_BUSY   |  (3<<8))
        public static let BUSY_TIMEOUT = SqliteError(rawValue: 0x305)


        /// SQLITE_CANTOPEN_NOTEMPDIR (SQLITE_CANTOPEN | (1<<8))
        public static let CANTOPEN_NOTEMPDIR = SqliteError(rawValue: 0x10E)

        /// SQLITE_CANTOPEN_ISDIR (SQLITE_CANTOPEN | (2<<8))
        public static let CANTOPEN_ISDIR = SqliteError(rawValue: 0x20E)

        /// SQLITE_CANTOPEN_FULLPATH (SQLITE_CANTOPEN | (3<<8))
        public static let CANTOPEN_FULLPATH = SqliteError(rawValue: 0x30E)

        /// SQLITE_CANTOPEN_CONVPATH (SQLITE_CANTOPEN | (4<<8))
        public static let CANTOPEN_CONVPATH = SqliteError(rawValue: 0x40E)

        /// SQLITE_CANTOPEN_DIRTYWAL (SQLITE_CANTOPEN | (5<<8)) /* Not Used */
        public static let CANTOPEN_DIRTYWAL = SqliteError(rawValue: 0x50E)

        /// SQLITE_CANTOPEN_SYMLINK (SQLITE_CANTOPEN | (6<<8))
        public static let CANTOPEN_SYMLINK = SqliteError(rawValue: 0x60E)

        /// SQLITE_CORRUPT_VTAB (SQLITE_CORRUPT | (1<<8))
        public static let CORRUPT_VTAB = SqliteError(rawValue: 0x10B)

        /// SQLITE_CORRUPT_SEQUENCE (SQLITE_CORRUPT | (2<<8))
        public static let CORRUPT_SEQUENCE = SqliteError(rawValue: 0x20B)

        /// SQLITE_CORRUPT_INDEX (SQLITE_CORRUPT | (3<<8))
        public static let CORRUPT_INDEX = SqliteError(rawValue: 0x30B)

        /// SQLITE_READONLY_RECOVERY (SQLITE_READONLY | (1<<8))
        public static let READONLY_RECOVERY = SqliteError(rawValue: 0x108)

        /// SQLITE_READONLY_CANTLOCK (SQLITE_READONLY | (2<<8))
        public static let READONLY_CANTLOCK = SqliteError(rawValue: 0x208)

        /// SQLITE_READONLY_ROLLBACK (SQLITE_READONLY | (3<<8))
        public static let READONLY_ROLLBACK = SqliteError(rawValue: 0x308)

        /// SQLITE_READONLY_DBMOVED (SQLITE_READONLY | (4<<8))
        public static let READONLY_DBMOVED = SqliteError(rawValue: 0x408)

        /// SQLITE_READONLY_CANTINIT (SQLITE_READONLY | (5<<8))
        public static let READONLY_CANTINIT = SqliteError(rawValue: 0x508)

        /// SQLITE_READONLY_DIRECTORY (SQLITE_READONLY | (6<<8))
        public static let READONLY_DIRECTORY = SqliteError(rawValue: 0x608)


        /// SQLITE_ABORT_ROLLBACK (SQLITE_ABORT | (2<<8))
        public static let ABORT_ROLLBACK = SqliteError(rawValue: 0x204)


        /// SQLITE_CONSTRAINT_CHECK (SQLITE_CONSTRAINT | (1<<8))
        public static let CONSTRAINT_CHECK = SqliteError(rawValue: 0x113)

        /// SQLITE_CONSTRAINT_COMMITHOOK (SQLITE_CONSTRAINT | (2<<8))
        public static let CONSTRAINT_COMMITHOOK = SqliteError(rawValue: 0x213)

        /// SQLITE_CONSTRAINT_FOREIGNKEY (SQLITE_CONSTRAINT | (3<<8))
        public static let CONSTRAINT_FOREIGNKEY = SqliteError(rawValue: 0x313)

        /// SQLITE_CONSTRAINT_FUNCTION (SQLITE_CONSTRAINT | (4<<8))
        public static let CONSTRAINT_FUNCTION = SqliteError(rawValue: 0x413)

        /// SQLITE_CONSTRAINT_NOTNULL (SQLITE_CONSTRAINT | (5<<8))
        public static let CONSTRAINT_NOTNULL = SqliteError(rawValue: 0x513)

        /// SQLITE_CONSTRAINT_PRIMARYKEY (SQLITE_CONSTRAINT | (6<<8))
        public static let CONSTRAINT_PRIMARYKEY = SqliteError(rawValue: 0x613)

        /// SQLITE_CONSTRAINT_TRIGGER (SQLITE_CONSTRAINT | (7<<8))
        public static let CONSTRAINT_TRIGGER = SqliteError(rawValue: 0x713)

        /// SQLITE_CONSTRAINT_UNIQUE (SQLITE_CONSTRAINT | (8<<8))
        public static let CONSTRAINT_UNIQUE = SqliteError(rawValue: 0x813)

        /// SQLITE_CONSTRAINT_VTAB (SQLITE_CONSTRAINT | (9<<8))
        public static let CONSTRAINT_VTAB = SqliteError(rawValue: 0x913)

        /// SQLITE_CONSTRAINT_ROWID (SQLITE_CONSTRAINT |(10<<8))
        public static let CONSTRAINT_ROWID = SqliteError(rawValue: 0xA13)

        /// SQLITE_CONSTRAINT_PINNED (SQLITE_CONSTRAINT |(11<<8))
        public static let CONSTRAINT_PINNED = SqliteError(rawValue: 0xB13)

        /// SQLITE_CONSTRAINT_DATATYPE (SQLITE_CONSTRAINT |(12<<8))
        public static let CONSTRAINT_DATATYPE = SqliteError(rawValue: 0xC13)


        /// SQLITE_NOTICE_RECOVER_WAL (SQLITE_NOTICE | (1<<8))
        public static let NOTICE_RECOVER_WAL = SqliteError(rawValue: 0x11B)

        /// SQLITE_NOTICE_RECOVER_ROLLBACK (SQLITE_NOTICE | (2<<8))
        public static let NOTICE_RECOVER_ROLLBACK = SqliteError(rawValue: 0x21B)


        /// SQLITE_WARNING_AUTOINDEX (SQLITE_WARNING | (1<<8))
        public static let WARNING_AUTOINDEX = SqliteError(rawValue: 0x11C)


        /// SQLITE_AUTH_USER (SQLITE_AUTH | (1<<8))
        public static let AUTH_USER = SqliteError(rawValue: 0x117)


        /// SQLITE_OK_LOAD_PERMANENTLY (SQLITE_OK | (1<<8))
        public static let OK_LOAD_PERMANENTLY = SqliteError(rawValue: 0x100)
    }
}
