import SQLite3

extension Sqlite {
    public struct OpenFlag: OptionSet {
        public let rawValue: Int32
        
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        
        /// SQLITE_OPEN_READONLY: 打开数据库为只读模式，不允许进行写操作。
        static let READONLY = OpenFlag(rawValue: SQLITE_OPEN_READONLY)
        /// SQLITE_OPEN_READWRITE: 打开数据库为读写模式，允许进行读和写操作。
        static let READWRITE = OpenFlag(rawValue: SQLITE_OPEN_READWRITE)
        /// SQLITE_OPEN_CREATE: 如果数据库不存在，则创建一个新的数据库。
        static let CREATE = OpenFlag(rawValue: SQLITE_OPEN_CREATE)
        /// SQLITE_OPEN_DELETEONCLOSE: 数据库在关闭时应该被删除。
        static let DELETEONCLOSE = OpenFlag(rawValue: SQLITE_OPEN_DELETEONCLOSE)
        /// SQLITE_OPEN_EXCLUSIVE: 数据库连接是独占的，其他连接不能访问。
        static let EXCLUSIVE = OpenFlag(rawValue: SQLITE_OPEN_EXCLUSIVE)
        /// SQLITE_OPEN_AUTOPROXY: 数据库连接应该尝试使用适合当前操作系统和环境的默认代理。
        static let AUTOPROXY = OpenFlag(rawValue: SQLITE_OPEN_AUTOPROXY)
        /// SQLITE_OPEN_URI: 标志允许数据库名是一个 URI，如文件路径。
        static let URI = OpenFlag(rawValue: SQLITE_OPEN_URI)
        /// SQLITE_OPEN_MEMORY: 打开一个内存数据库。
        static let MEMORY = OpenFlag(rawValue: SQLITE_OPEN_MEMORY)

        // 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主数据库、临时数据库和临时的数据库。
        static let MAIN_DB = OpenFlag(rawValue: SQLITE_OPEN_MAIN_DB) /* VFS only */
        static let TEMP_DB = OpenFlag(rawValue: SQLITE_OPEN_TEMP_DB) /* VFS only */
        static let TRANSIENT_DB = OpenFlag(rawValue: SQLITE_OPEN_TRANSIENT_DB) /* VFS only */

        // 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主日志、临时日志、子日志和主日志。
        static let MAIN_JOURNAL = OpenFlag(rawValue: SQLITE_OPEN_MAIN_JOURNAL) /* VFS only */
        static let TEMP_JOURNAL = OpenFlag(rawValue: SQLITE_OPEN_TEMP_JOURNAL) /* VFS only */
        static let SUBJOURNAL = OpenFlag(rawValue: SQLITE_OPEN_SUBJOURNAL) /* VFS only */
        static let MASTER_JOURNAL = OpenFlag(rawValue: SQLITE_OPEN_MASTER_JOURNAL) /* VFS only */

        /// SQLITE_OPEN_NOMUTEX: 禁用数据库连接的互斥锁。如果你确定只会在单个线程中使用 SQLite，可以禁用 SQLite 的互斥锁，以提高性能。
        static let NOMUTEX = OpenFlag(rawValue: SQLITE_OPEN_NOMUTEX)
        /// SQLITE_OPEN_FULLMUTEX: 启用数据库连接的全互斥锁。
        static let FULLMUTEX = OpenFlag(rawValue: SQLITE_OPEN_FULLMUTEX)
        /// SQLITE_OPEN_SHAREDCACHE: 启用数据库连接的共享缓存。
        static let SHAREDCACHE = OpenFlag(rawValue: SQLITE_OPEN_SHAREDCACHE)
        /// SQLITE_OPEN_PRIVATECACHE: 启用数据库连接的私有缓存。
        static let PRIVATECACHE = OpenFlag(rawValue: SQLITE_OPEN_PRIVATECACHE)
        /// SQLITE_OPEN_WAL: 启用数据库连接的写入日志模式。
        static let WAL = OpenFlag(rawValue: SQLITE_OPEN_WAL)

        // SQLITE_OPEN_FILEPROTECTION_COMPLETE, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNLESSOPEN, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION, SQLITE_OPEN_FILEPROTECTION_NONE, SQLITE_OPEN_FILEPROTECTION_MASK: 这些标志是用于设置数据库文件保护级别的，仅适用于 iOS 平台。
        static let FILEPROTECTION_COMPLETE = OpenFlag(rawValue: SQLITE_OPEN_FILEPROTECTION_COMPLETE)
        static let FILEPROTECTION_COMPLETEUNLESSOPEN = OpenFlag(rawValue: SQLITE_OPEN_FILEPROTECTION_COMPLETEUNLESSOPEN)
        static let FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION = OpenFlag(rawValue: SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION)
        static let FILEPROTECTION_NONE = OpenFlag(rawValue: SQLITE_OPEN_FILEPROTECTION_NONE)
        static let FILEPROTECTION_MASK = OpenFlag(rawValue: SQLITE_OPEN_FILEPROTECTION_MASK)
    }
}
