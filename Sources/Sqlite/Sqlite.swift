import SQLite3

class Sqlite {
    static var version: String {
        // 如: 3.28.0
        return SQLITE_VERSION
    }
    
    static var versionNumber: Int32 {
        // 如: 3028000
        return SQLITE_VERSION_NUMBER
    }
    
    static var sourceId: String {
        // 如: 2019-04-15 14:49:49
        return SQLITE_SOURCE_ID
    }
    
    // 检查是否使用了某个编译选项
    static func isCompileOptionUsed(optionName: String) -> Bool {
        return sqlite3_compileoption_used(optionName) == 1
    }
    
    // 获取编译时选项列表
    static func getCompileOptions() -> [String: String] {
        /*
         返回示例:
         [
             "BUG_COMPATIBLE_20160819": "",
             "COMPILER": "clang-10.0.1",
             "DEFAULT_CACHE_SIZE": "2000",
             "DEFAULT_CKPTFULLFSYNC": "",
             "DEFAULT_JOURNAL_SIZE_LIMIT": "32768",
             "DEFAULT_PAGE_SIZE": "4096",
             "DEFAULT_SYNCHRONOUS": "2",
             "DEFAULT_WAL_SYNCHRONOUS": "1",
             "ENABLE_API_ARMOR": "",
             "ENABLE_COLUMN_METADATA": "",
             "ENABLE_DBSTAT_VTAB": "",
             "ENABLE_FTS3": "",
             "ENABLE_FTS3_PARENTHESIS": "",
             "ENABLE_FTS3_TOKENIZER": "",
             "ENABLE_FTS4": "",
             "ENABLE_FTS5": "",
             "ENABLE_JSON1": "",
             "ENABLE_LOCKING_STYLE": "1",
             "ENABLE_PREUPDATE_HOOK": "",
             "ENABLE_RTREE": "",
             "ENABLE_SESSION": "",
             "ENABLE_SNAPSHOT": "",
             "ENABLE_SQLLOG": "",
             "ENABLE_UNKNOWN_SQL_FUNCTION": "",
             "ENABLE_UPDATE_DELETE_LIMIT": "",
             "HAS_CODEC_RESTRICTED": "",
             "HAVE_ISNAN": "",
             "MAX_LENGTH": "2147483645",
             "MAX_MMAP_SIZE": "1073741824",
             "MAX_VARIABLE_NUMBER": "500000",
             "OMIT_AUTORESET": "",
             "OMIT_LOAD_EXTENSION": "",
             "STMTJRNL_SPILL": "131072",
             "THREADSAFE": "2",
             "USE_URI": "",
         ]
         */
        var optionIndex: Int32 = 0
        var options: [String: String] = [:]
        while let optionStr = sqlite3_compileoption_get(optionIndex) {
            let option = String(cString: optionStr)
            let components = option.split(separator: "=")
            if components.count == 2 {
                let key = String(components[0])
                let value = String(components[1])
                options[key] = value
            } else {
                options[option] = ""
            }
            optionIndex += 1
        }
        return options
    }
    
    static var threadSafe: Int32 {
        /*
         sqlite3_threadsafe() 返回 0 到 2
         0：表示禁用互斥，SQLite 是非线程安全的。
         1：表示启用多线程模式，SQLite 是线程安全的，但是只允许一个线程访问数据库。
         2：表示启用序列化模式，SQLite 是线程安全的，并且允许多个线程同时访问数据库，但是只允许一个线程执行写操作。
         */
        return sqlite3_threadsafe()
    }
    
    static var isThreadSafe: Bool {
        return sqlite3_threadsafe() > 0
    }
    
    let db: OpaquePointer
    
    /*
     flags:
         SQLITE_OPEN_READONLY: 打开数据库为只读模式，不允许进行写操作。
         SQLITE_OPEN_READWRITE: 打开数据库为读写模式，允许进行读和写操作。
         SQLITE_OPEN_CREATE: 如果数据库不存在，则创建一个新的数据库。
         SQLITE_OPEN_DELETEONCLOSE: 数据库在关闭时应该被删除。
         SQLITE_OPEN_EXCLUSIVE: 数据库连接是独占的，其他连接不能访问。
         SQLITE_OPEN_AUTOPROXY: 数据库连接应该尝试使用适合当前操作系统和环境的默认代理。
         SQLITE_OPEN_URI: 标志允许数据库名是一个 URI，如文件路径。
         SQLITE_OPEN_MEMORY: 打开一个内存数据库。
         SQLITE_OPEN_MAIN_DB, SQLITE_OPEN_TEMP_DB, SQLITE_OPEN_TRANSIENT_DB: 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主数据库、临时数据库和临时的数据库。
         SQLITE_OPEN_MAIN_JOURNAL, SQLITE_OPEN_TEMP_JOURNAL, SQLITE_OPEN_SUBJOURNAL, SQLITE_OPEN_MASTER_JOURNAL: 这些标志是给虚拟文件系统 (VFS) 使用的，用于打开主日志、临时日志、子日志和主日志。
         SQLITE_OPEN_NOMUTEX: 禁用数据库连接的互斥锁。如果你确定只会在单个线程中使用 SQLite，可以禁用 SQLite 的互斥锁，以提高性能。
         SQLITE_OPEN_FULLMUTEX: 启用数据库连接的全互斥锁。
         SQLITE_OPEN_SHAREDCACHE: 启用数据库连接的共享缓存。
         SQLITE_OPEN_PRIVATECACHE: 启用数据库连接的私有缓存。
         SQLITE_OPEN_WAL: 启用数据库连接的写入日志模式。
         SQLITE_OPEN_FILEPROTECTION_COMPLETE, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNLESSOPEN, SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION, SQLITE_OPEN_FILEPROTECTION_NONE, SQLITE_OPEN_FILEPROTECTION_MASK: 这些标志是用于设置数据库文件保护级别的，仅适用于 iOS 平台。
     */
    init(path: String = ":memory:", flags: Int32 = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE) {
        var dbPointer: OpaquePointer?
        guard sqlite3_open_v2(path, &dbPointer, flags, nil) == SQLITE_OK else {
            fatalError("Failed to open database.")
        }
        db = dbPointer!
    }

    deinit {
        sqlite3_close(db)
    }
}
