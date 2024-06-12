import SQLite3
import SqliteWrapper

extension Sqlite {
    /// 检查是否使用了某个编译选项
    static func isCompileOptionUsed(option: CompileOption) -> Bool {
        return sqlite3_compileoption_used(option.rawValue.withCString { $0 }) == 1
    }
    
    /// 获取编译时选项列表
    public static func getCompileOptions() -> [CompileOption: String] {
        var optionIndex: Int32 = 0
        var options: [CompileOption: String] = [:]
        while let optionStr = sqlite3_compileoption_get(optionIndex) {
            let option = String(cString: optionStr)
            let components = option.split(separator: "=")
            if components.count == 2 {
                let key = String(components[0])
                let value = String(components[1])
                options[CompileOption(rawValue: key)!] = value
            } else {
                options[CompileOption(rawValue:option)!] = ""
            }
            optionIndex += 1
        }
        return options
    }
    
    public static var threadSafe: ThreadSafeLevel {
        return ThreadSafeLevel(rawValue: sqlite3_threadsafe())!
    }
    
    public static var isThreadSafe: Bool {
        return sqlite3_threadsafe() > 0
    }
    
    public static var isSingleThreaded: Bool {
        return sqlite3_threadsafe() == 1
    }
    
    public static var isMultiThreaded: Bool {
        return sqlite3_threadsafe() == 2
    }
    
    public static func config(_ option: DbConfig, _ params: CVarArg...) -> SqliteError {
        return withVaList(params) { pointer in
            return SqliteError(rawValue: sqliteWrapperConfig(option.rawValue, pointer))
        }
    }
    
    /**
     判断 SQL 语句是否完整。
     用于确定当前输入的文本是否形成一个完整的 SQL 语句，或者是否需要在将文本发送到 SQLite 进行解析之前需要额外的输入。
     如果输入字符串看起来是一个完整的 SQL 语句，则返回 1。
     如果语句以分号标记结尾并且不是完整的 CREATE TRIGGER 语句的前缀，则被视为完整的语句。
     分号在字符串字面量、带引号的标识符名称或注释中嵌入时不是独立的标记（它们是嵌入它们的标记的一部分），因此不计为语句终止符。
     在最后一个分号后面的空白和注释将被忽略。
     */
    public static func complete(_ sql: String) -> Bool {
        return sql.withCString { cString in
            return sqlite3_complete16(cString) == 1
        }
    }
    
    /**
     返回当前尚未释放的内存字节数（已经分配但尚未释放的内存）。
     */
    public static func memoryUsed() -> Int64 {
        return sqlite3_memory_used()
    }
    
    /**
     返回自上次重置高水位标记以来[sqlite3_memory_used()]的最大值。
     你可以通过设置 resetFlag 参数来决定是否将高水位标记重置为当前内存使用量。
     memoryHighwater(0) 用来获取当前的内存高水位线（high-water mark），并且不重置它。
    */
    public static func memoryHighwater(_ resetFlag: Int32) -> Int64 {
        return sqlite3_memory_highwater(resetFlag)
    }
    
    @available(OSX 10.10, iOS 8.2, *)
    public static func errStr(_ errCode: Int32) -> String {
        return String(cString: sqlite3_errstr(errCode))
    }
    
    public static func valueBlob(_ value: OpaquePointer!) -> UnsafeRawPointer! {
        return sqlite3_value_blob(value)
    }
    
    public static func valueDouble(_ value: OpaquePointer!) -> Double {
        return sqlite3_value_double(value)
    }
    
    public static func valueInt(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_int(value)
    }
    
    public static func valueInt64(_ value: OpaquePointer!) -> Int64 {
        return sqlite3_value_int64(value)
    }
    
    @available(OSX 10.14, iOS 12.0, *)
    public static func valuePointer(_ value: OpaquePointer!, _ type: UnsafePointer<Int8>!) -> UnsafeMutableRawPointer! {
        return sqlite3_value_pointer(value, type)
    }
    
    public static func valueText(_ value: OpaquePointer!) -> UnsafePointer<UInt8>! {
        return sqlite3_value_text(value)
    }
    
    public static func valueText16(_ value: OpaquePointer!) -> UnsafeRawPointer! {
        return sqlite3_value_text16(value)
    }
    
    public static func valueText16le(_ value: OpaquePointer!) -> UnsafeRawPointer! {
        return sqlite3_value_text16le(value)
    }
    
    public static func valueText16be(_ value: OpaquePointer!) -> UnsafeRawPointer! {
        return sqlite3_value_text16be(value)
    }
    
    public static func valueBytes(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_bytes(value)
    }
    
    public static func valueBytes16(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_bytes16(value)
    }
    
    public static func valueType(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_type(value)
    }
    
    public static func valueNumericType(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_numeric_type(value)
    }
    
    /// 当调用 sqlite3_bind_pointer 或 sqlite3_bind_pointer 函数来绑定参数时，可以使用 sqlite3_value_nochange 来检查该参数是否与先前的绑定相同。如果值相同，它将返回非零值，否则返回零。
    @available(OSX 10.14, iOS 12.0, *)
    public static func valueNoChange(_ value: OpaquePointer!) -> Bool {
        return sqlite3_value_nochange(value) == 0
    }
    
    @available(OSX 10.15, iOS 13.0, *)
    public static func valueFromBind(_ value: OpaquePointer!) -> Int32 {
        return sqlite3_value_frombind(value)
    }
}
