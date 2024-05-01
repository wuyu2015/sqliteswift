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
    
    public static func config(_ option: DbConfig, _ params: CVarArg...) -> ErrorCode {
        return withVaList(params) { pointer in
            return ErrorCode(rawValue: sqliteWrapperConfig(option.rawValue, pointer))!
        }
    }
}
