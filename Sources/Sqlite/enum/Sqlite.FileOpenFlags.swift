extension Sqlite {
    public enum FileOpenFlag: Int32 {
        /// SQLITE_OPEN_READONLY: 打开数据库为只读模式，不允许进行写操作。
        case READONLY = 0x00000001
        /// SQLITE_OPEN_READWRITE: 打开数据库为读写模式，允许进行读和写操作。
        case READWRITE = 0x00000002
        /// SQLITE_OPEN_CREATE: 如果数据库不存在，则创建一个新的数据库。
        case CREATE = 0x00000004
        /// SQLITE_OPEN_DELETEONCLOSE: 数据库在关闭时应该被删除。
        case DELETEONCLOSE = 0x00000008
        /// SQLITE_OPEN_EXCLUSIVE: 数据库连接是独占的，其他连接不能访问。
        case EXCLUSIVE = 0x00000010
        /// SQLITE_OPEN_AUTOPROXY: 数据库连接应该尝试使用适合当前操作系统和环境的默认代理。
        case AUTOPROXY = 0x00000020
        /// SQLITE_OPEN_URI: 标志允许数据库名是一个 URI，如文件路径。
        case URI = 0x00000040
        /// SQLITE_OPEN_MEMORY: 打开一个内存数据库。
        case MEMORY = 0x00000080
        
        // 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主数据库、临时数据库和临时的数据库。
        case MAIN_DB = 0x00000100 /* VFS only */
        case TEMP_DB = 0x00000200 /* VFS only */
        case TRANSIENT_DB = 0x00000400 /* VFS only */
        
        // 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主日志、临时日志、子日志和主日志。
        case MAIN_JOURNAL = 0x00000800 /* VFS only */
        case TEMP_JOURNAL = 0x00001000 /* VFS only */
        case SUBJOURNAL = 0x00002000 /* VFS only */
        case MASTER_JOURNAL = 0x00004000 /* VFS only */
        
        /// SQLITE_OPEN_NOMUTEX: 禁用数据库连接的互斥锁。如果你确定只会在单个线程中使用 SQLite，可以禁用 SQLite 的互斥锁，以提高性能。
        case NOMUTEX = 0x00008000
        /// SQLITE_OPEN_FULLMUTEX: 启用数据库连接的全互斥锁。
        case FULLMUTEX = 0x00010000
        /// SQLITE_OPEN_SHAREDCACHE: 启用数据库连接的共享缓存。
        case SHAREDCACHE = 0x00020000
        /// SQLITE_OPEN_PRIVATECACHE: 启用数据库连接的私有缓存。
        case PRIVATECACHE = 0x00040000
        /// SQLITE_OPEN_WAL: 启用数据库连接的写入日志模式。
        case WAL = 0x00080000
        
        // SQLITE_OPEN_FILEPROTECTION_COMPLETE, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNLESSOPEN, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION, SQLITE_OPEN_FILEPROTECTION_NONE, SQLITE_OPEN_FILEPROTECTION_MASK: 这些标志是用于设置数据库文件保护级别的，仅适用于 iOS 平台。
        case FILEPROTECTION_COMPLETE = 0x00100000
        case FILEPROTECTION_COMPLETEUNLESSOPEN = 0x00200000
        case FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION = 0x00300000
        case FILEPROTECTION_NONE = 0x00400000
        case FILEPROTECTION_MASK = 0x00F00000
    }
}
