import SQLite3

public enum Sqlite {
    private static func checkResult(_ result: Int32) throws {
        guard result == SQLITE_OK else {
            throw ErrorCode(rawValue: result)
        }
    }
    
    // 如: 3.28.0
    public static let version: String = SQLITE_VERSION
    
    // 如: 3028000
    public static let versionNumber: Int32 = SQLITE_VERSION_NUMBER
    
    // 如: 2019-04-15 14:49:49 378230ae7f4b721c8b8d83c8ceb891449685cd23b1702a57841f1be40b5daapl
    public static let sourceId: String = SQLITE_SOURCE_ID
    
    public static var tempDirectory: String? {
        get {
            guard let tempDir = sqlite3_temp_directory else {
                return nil
            }
            return String(cString: tempDir)
        }
        set {
            if let newValue = newValue {
                let cString = strdup(newValue)
                sqlite3_temp_directory = cString
            } else {
                sqlite3_temp_directory = nil
            }
        }
    }
    
    public static var dataDirectory: String? {
        get {
            guard let directory = sqlite3_data_directory else {
                return nil
            }
            return String(cString: directory)
        }
        set {
            if let newValue = newValue {
                let cString = strdup(newValue)
                sqlite3_data_directory = cString
            } else {
                sqlite3_data_directory = nil
            }
        }
    }
    
    public static func sleep(_ ms: Int) throws {
        try checkResult(sqlite3_sleep(Int32(ms)))
    }
    
    @available(OSX 10.8, *)
    public func releaseMemory(_ amount: Int32) -> Int32 {
        return sqlite3_release_memory(amount)
    }
    
    @available(OSX 10.7, *)
    public func setSoftHeapLimit(_ limit: Int64) -> Int64 {
        return sqlite3_soft_heap_limit64(limit)
    }
    
    /// 将应用程序定义函数的结果设置为指向的长度为 N 字节的 BLOB。
    public static func resultBlob(_ context: OpaquePointer!, _ value: UnsafeRawPointer!, _ length: Int32, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_blob(context, value, length, destructor)
    }

    public static func resultBlob64(_ context: OpaquePointer!, _ value: UnsafeRawPointer!, _ length: sqlite3_uint64, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_blob64(context, value, length, destructor)
    }

    /// 将应用程序定义函数的结果设置为指定的浮点值。
    public static func resultDouble(_ context: OpaquePointer!, _ value: Double) {
        sqlite3_result_double(context, value)
    }

    /// 使实现的 SQL 函数抛出异常，其中 SQLite 使用第二个参数指向的字符串作为错误消息文本。错误消息字符串被解释为 UTF-8。
    public static func resultError(_ context: OpaquePointer!, _ errorMessage: UnsafePointer<Int8>!, _ length: Int32) {
        sqlite3_result_error(context, errorMessage, length)
    }

    /// 使实现的 SQL 函数抛出异常，其中 SQLite 使用第二个参数指向的字符串作为错误消息文本。错误消息字符串被解释为 UTF-16。
    public static func resultError16(_ context: OpaquePointer!, _ errorMessage: UnsafeRawPointer!, _ length: Int32) {
        sqlite3_result_error16(context, errorMessage, length)
    }

    /// 导致 SQLite 抛出表示字符串或 BLOB 太长的错误。
    public static func resultErrorTooBig(_ context: OpaquePointer!) {
        sqlite3_result_error_toobig(context)
    }

    /// 导致 SQLite 抛出表示内存分配失败的错误。
    public static func resultErrorNoMem(_ context: OpaquePointer!) {
        sqlite3_result_error_nomem(context)
    }

    public static func resultErrorCode(_ context: OpaquePointer!, _ errorCode: Int32) {
        sqlite3_result_error_code(context, errorCode)
    }

    /// 将应用程序定义函数的返回值设置为指定的 32 位有符号整数值。
    public static func resultInt(_ context: OpaquePointer!, _ value: Int32) {
        sqlite3_result_int(context, value)
    }

    /// 将应用程序定义函数的返回值设置为指定的 64 位有符号整数值。
    public static func resultInt64(_ context: OpaquePointer!, _ value: sqlite3_int64) {
        sqlite3_result_int64(context, value)
    }

    /// 将应用程序定义函数的返回值设置为 NULL。
    public static func resultNull(_ context: OpaquePointer!) {
        sqlite3_result_null(context)
    }

    /// 将应用程序定义函数的返回值设置为文本字符串，其编码分别为 UTF-8。
    public static func resultText(_ context: OpaquePointer!, _ value: UnsafePointer<Int8>!, _ length: Int32, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_text(context, value, length, destructor)
    }

    public static func resultText64(_ context: OpaquePointer!, _ value: UnsafePointer<Int8>!, _ length: sqlite3_uint64, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!, _ encoding: UInt8) {
        sqlite3_result_text64(context, value, length, destructor, encoding)
    }

    /// 将应用程序定义函数的返回值设置为文本字符串，其编码分别为UTF-16 本地字节顺序。
    public static func resultText16(_ context: OpaquePointer!, _ value: UnsafeRawPointer!, _ length: Int32, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_text16(context, value, length, destructor)
    }

    /// 将应用程序定义函数的返回值设置为文本字符串，其编码分别为 UTF-16 小端。
    public static func resultText16le(_ context: OpaquePointer!, _ value: UnsafeRawPointer!, _ length: Int32, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_text16le(context, value, length, destructor)
    }

    /// 将应用程序定义函数的返回值设置为文本字符串，其编码分别为 UTF-16 大端。
    public static func resultText16be(_ context: OpaquePointer!, _ value: UnsafeRawPointer!, _ length: Int32, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_text16be(context, value, length, destructor)
    }

    /// 将应用程序定义函数的结果设置为指定的 [sqlite3_value] 对象的副本。
    public static func resultValue(_ context: OpaquePointer!, _ value: OpaquePointer!) {
        sqlite3_result_value(context, value)
    }

    /// 将应用程序定义函数的结果设置为包含所有零字节且大小为 N 字节的 BLOB。
    public static func resultZeroBlob(_ context: OpaquePointer!, _ length: Int32) {
        sqlite3_result_zeroblob(context, length)
    }

    /// 将应用程序定义函数的结果设置为包含所有零字节且大小为 N 字节的 BLOB。
    @available(OSX 10.12, iOS 10.0, *)
    public static func resultZeroBlob64(_ context: OpaquePointer!, _ length: sqlite3_uint64) -> Int32 {
        return sqlite3_result_zeroblob64(context, length)
    }

    /// 将结果设置为 SQL NULL 值，并将主机语言指针 P 或类型 T 与该 NULL 值相关联，使得指针可以在应用程序定义的 SQL 函数中使用 sqlite3_value_pointer() 进行检索。如果参数 D 不为 NULL，则它是指向 P 参数的析构函数，SQLite 在完成 P 时会调用 D，并将 P 作为其唯一参数。
    @available(OSX 10.14, iOS 12.0, *)
    public static func resultPointer(_ context: OpaquePointer!, _ value: UnsafeMutableRawPointer!, _ typeId: UnsafePointer<Int8>!, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) {
        sqlite3_result_pointer(context, value, typeId, destructor)
    }
    
    public static func status(_ op: Status, reset: Bool = false) throws -> (current: Int64, highwater: Int64) {
        if #available(macOS 10.11, iOS 9.0, *) {
            var current: Int64 = 0
            var highwater: Int64 = 0
            let result = sqlite3_status64(op.rawValue, &current, &highwater, reset ? 1 : 0)
            try checkResult(result)
            return (current, highwater)
        } else {
            var current: Int32 = 0
            var highwater: Int32 = 0
            let result = sqlite3_status(op.rawValue, &current, &highwater, reset ? 1 : 0)
            try checkResult(result)
            return (Int64(current), Int64(highwater))
        }
    }
}
