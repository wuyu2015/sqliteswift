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
}
