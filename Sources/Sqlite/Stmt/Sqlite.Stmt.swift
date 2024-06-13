import Foundation
import SQLite3

extension Sqlite {
    public class Stmt {
        public let stmt: OpaquePointer
        public let db: Db
        public let bindParameterCount: Int32
        public let columnCount: Int32
        public let columns: [String]
        public let columnMap: [String: Int32]
        public private(set) var useCount: Int = 0
        public private(set) var successCount: Int = 0
        public private(set) var busyCount: Int = 0
        
        /**
         返回与准备语句关联的原f始 SQL 字符串
        */
        public lazy var sql: String = {
            return String(cString: sqlite3_sql(stmt))
        }()
        
        @available(OSX 10.12, *)
        public lazy var expandedSql: String = {
            return String(cString: sqlite3_expanded_sql(stmt))
        }()
        
        /**
         返回一个布尔值，指示 stmt 是否为只读。
         
         如果一个准备好的语句对数据库文件没有直接的更改，则 sqlite3_stmt_readonly 接口返回 true（非零）。
         应用程序定义的 SQL 函数或虚拟表可能通过副作用间接地改变数据库。例如，如果应用程序定义了一个名为 "eval()" 的函数，它调用了 sqlite3_exec()，那么下面的 SQL 语句通过副作用会改变数据库文件。
         事务控制语句（例如 [BEGIN]、[COMMIT]、[ROLLBACK]、[SAVEPOINT] 和 [RELEASE]）会导致 sqlite3_stmt_readonly 返回 true，因为这些语句本身并不实际修改数据库，而是控制其他语句何时修改数据库的时机。
         [ATTACH] 和 [DETACH] 语句也会导致 sqlite3_stmt_readonly 返回 true，因为它们虽然会改变数据库连接的配置，但不会修改数据库文件的内容。
         对于 [BEGIN] 语句，sqlite3_stmt_readonly 返回 true，因为 [BEGIN] 只是设置内部标志。但是，[BEGIN IMMEDIATE] 和 [BEGIN EXCLUSIVE] 命令会触及数据库，因此 sqlite3_stmt_readonly 对于这些命令返回 false。
         */
        public lazy var isReadOnly: Bool = {
            return sqlite3_stmt_readonly(stmt) != 0
        }()
        
        /**
         返回一个布尔值，指示 stmt 是否是 EXPLAIN 查询。
         
         如果准备语句 S 是一个 EXPLAIN 语句，则返回 1；如果是 EXPLAIN QUERY PLAN 语句，则返回 2。
         如果 S 是普通语句或空指针，则返回 0。
         */
        @available(OSX 10.15, iOS 13.0, *)
        public var isExplain: Bool {
            return sqlite3_stmt_isexplain(stmt) != 0
        }
        
        /**
         返回一个布尔值，指示 stmt 是否是 EXPLAIN QUERY PLAN 查询。
        */
        @available(OSX 10.15, iOS 13.0, *)
        public var isExplainQueryPlan: Bool {
            return sqlite3_stmt_isexplain(stmt) == 2
        }
        
        /**
         返回一个布尔值，指示准备语句是否正在被其他操作使用。

         - Returns: 如果准备语句已经被执行过至少一次，并且尚未完成或者尚未被重置，则为 true；否则为 false。
         
         如果准备语句 S 至少被调用过一次 sqlite3_step(S)，但尚未运行到完成（即返回了 [SQLITE_DONE]），也没有被重置（即使用了 sqlite3_reset(S)），则 sqlite3_stmt_busy(S) 返回 true（非零）。
         如果 S 是一个空指针，则返回 false。如果 S 不是一个空指针，并且不是指向有效的准备语句对象，则行为是未定义的，可能是不希望的。
         这个接口通常与 sqlite3_next_stmt() 结合使用，来定位数据库连接关联的所有需要被重置的准备语句。例如，可以在诊断程序中使用它来搜索保持事务打开的准备语句。
         */
        public var isBusy: Bool {
            return sqlite3_stmt_busy(stmt) != 0
        }
        
        public var dataCount: Int32 {
            return sqlite3_data_count(stmt)
        }
        
        init(_ pStmt: OpaquePointer, db: Db? = nil) {
            stmt = pStmt
            self.db = db ?? Db(db: sqlite3_db_handle(stmt))
            bindParameterCount = sqlite3_bind_parameter_count(stmt)
            var map: [String: Int32] = [:]
            var arr: [String] = []
            columnCount = sqlite3_column_count(stmt)
            for index in 0 ..< columnCount {
                let columnName = String(cString: sqlite3_column_name(stmt, index))
                arr.append(columnName)
                map[columnName] = index
            }
            columns = arr
            columnMap = map
        }
        
        @discardableResult
        private func checkResult(_ result: Int32) throws -> Self {
            guard result == SQLITE_OK else {
                throw SqliteError(rawValue: result, message: db.errMsg, sql: expandedSql)
            }
            return self
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Bool) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, value ? 1 : 0))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Int) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, index, Int64(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: UInt) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, index, Int64(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Int8) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, Int32(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: UInt8) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, Int32(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Int16) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, Int32(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: UInt16) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, Int32(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Int32) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, index, value))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: UInt32) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, index, Int64(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Int64) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, index, value))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: UInt64) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, index, sqlite3_int64(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Float) throws -> Self {
            return try checkResult(sqlite3_bind_double(stmt, index, Double(value)))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: Double) throws -> Self {
            return try checkResult(sqlite3_bind_double(stmt, index, value))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ value: String) throws -> Self {
            return try checkResult(sqlite3_bind_text(stmt, index, strdup(value), -1, { free($0) }))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ cString: UnsafePointer<Int8>) throws -> Self {
            return try checkResult(sqlite3_bind_text(stmt, index, cString, -1, { free($0) }))
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ data: [UInt8]) throws -> Self {
            try checkResult(
                data.count <= Int(Int32.max)
                    ? sqlite3_bind_blob(stmt, index, data, Int32(data.count), nil)
                    : sqlite3_bind_blob64(stmt, index, data, UInt64(data.count), nil)
            )
        }
        
        @discardableResult
        public func bind(_ index: Int32, _ pointer: OpaquePointer!) throws -> Self {
            return try checkResult(sqlite3_bind_value(stmt, index, pointer))
        }
        
        @discardableResult
        public func bindNull(_ index: Int32) throws -> Self {
            return try checkResult(sqlite3_bind_null(stmt, index))
        }
        
        @discardableResult
        public func bindZeroBlob(_ index: Int32, length: Int) throws -> Self {
            if #available(OSX 10.12, iOS 10.0, *) {
                return try checkResult(sqlite3_bind_zeroblob64(stmt, index, sqlite3_uint64(length)))
            } else {
                return try checkResult(sqlite3_bind_zeroblob(stmt, index, Int32(length)))
            }
        }
        
        @discardableResult
        public func bind(_ array: [Any?]) throws -> Self {
            guard array.count == bindParameterCount else {
                throw SqliteError.RANGE
            }
            for (index, item) in array.enumerated() {
                switch item {
                case let value as Bool:
                    try bind(Int32(index + 1), value)
                case let value as Int:
                    try bind(Int32(index + 1), value)
                case let value as Int64:
                    try bind(Int32(index + 1), value)
                case let value as UInt64:
                    try bind(Int32(index + 1), value)
                case let value as UInt32:
                    try bind(Int32(index + 1), value)
                case let value as Int32:
                    try bind(Int32(index + 1), value)
                case let value as Float:
                    try bind(Int32(index + 1), value)
                case let value as Double:
                    try bind(Int32(index + 1), value)
                case let value as String:
                    try bind(Int32(index + 1), value)
                case let value as UnsafePointer<Int8>:
                    try bind(Int32(index + 1), value)
                case let value as [UInt8]:
                    try bind(Int32(index + 1), value)
                case nil:
                    try bindNull(Int32(index + 1))
                default:
                    throw SqliteError.ERROR
                }
            }
            return self
        }
        
        /**
         获取准备好的 SQL 语句中指定索引的参数名。
         
         - Parameter index: 参数的索引，从 1 开始。
         - Returns: 参数的名称，如果没有名称则返回 nil。
         
         sqlite3_bind_parameter_name(P,N) 接口返回准备好的语句 P 中的第 N 个 [SQL 参数] 的名称。
         
         以 "?NNN"、":AAA"、"@AAA" 或 "$AAA" 形式的 SQL 参数具有名称，分别是字符串 "?NNN"、":AAA"、"@AAA" 或 "$AAA"。
         换句话说，初始的 ":"、"$"、"@" 或 "?" 会包含在名称中。
         没有后跟整数的 "?" 形式的参数没有名称，并且被称为 "无名" 或 "匿名参数"。
         
         第一个主机参数的索引为 1，而不是 0。
         
         如果值 N 超出范围，或者第 N 个参数是无名的，则返回 NULL。
         返回的字符串始终以 UTF-8 编码，即使命名参数最初在 [sqlite3_prepare16()]、[sqlite3_prepare16_v2()] 或 [sqlite3_prepare16_v3()] 中指定为 UTF-16。
         
         另请参阅：[sqlite3_bind_blob|sqlite3_bind()]、[sqlite3_bind_parameter_count()] 和 [sqlite3_bind_parameter_index()]。
         */
        public func bindParameterName(_ index: Int32) -> String? {
            guard let cString = sqlite3_bind_parameter_name(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         获取准备好的 SQL 语句中具有指定名称的参数的索引。
         
         - Parameter name: 参数的名称。
         - Returns: 参数的索引，如果未找到返回 0。
         */
        public func bindParameterIndex(_ name: String) -> Int32 {
            return sqlite3_bind_parameter_index(stmt, name.withCString { $0 })
        }
        
        public func clearBindings() throws -> Self {
            return try checkResult(sqlite3_clear_bindings(stmt))
        }
        
        /**
         获取当前结果集中指定列的名称。
         
         - Parameter index: 列的索引，从0开始。
         - Returns: 列的名称。
         */
        public func columnName(_ index: Int32) -> String? {
            guard let cString = sqlite3_column_name(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         获取指定列所属的数据库名称。

         - Parameter index: 列的索引，从0开始。
         - Returns: 数据库名称作为字符串，如果列不属于数据库则返回 nil。
         */
        public func columnDatabaseName(_ index: Int32) -> String? {
            guard let cString = sqlite3_column_database_name(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         获取指定列所属的表名称。

         - Parameter index: 列的索引（从零开始）。
         - Returns: 表名称作为字符串，如果列不属于任何表则返回 nil。
         */
        public func columnTableName(_ index: Int32) -> String? {
            guard let cString = sqlite3_column_table_name(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         获取指定列的原始名称（即没有别名的名称）。

         - Parameter index: 列的索引（从零开始）。
         - Returns: 列的原始名称作为字符串。
         */
        public func columnOriginName(_ index: Int32) -> String? {
            guard let cString = sqlite3_column_origin_name(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         返回指定查询结果列的数据类型。

         - 参数 pStmt: 已准备好的语句
         - 参数 N: 列索引（从0开始）
         - 返回: 指向以null结尾的UTF-8字符串的指针，如果数据类型未知，则返回NULL
         */
        public func columnDecltype(_ index: Int32) -> String? {
            guard let cString = sqlite3_column_decltype(stmt, index) else {
                return nil
            }
            return String(cString: cString)
        }
        
        /**
         执行 SQLite 语句，并返回执行结果状态。

         - Returns: 如果成功找到一行数据返回 true，如果执行完毕返回 false。
         - Throws: 如果执行过程中出现错误，抛出异常。
         */
        public func step(retry: Int = 0) throws -> Bool {
            useCount += 1
            db.useCount += 1
            let result = sqlite3_step(stmt)
            switch result {
            case SQLITE_ROW:
                successCount += 1
                db.successCount += 1
                return true
            case SQLITE_DONE:
                try reset()
                successCount += 1
                db.successCount += 1
                return false
            case SQLITE_BUSY, SQLITE_LOCKED:
                busyCount += 1
                db.busyCount += 1
                // 当 retry 小于 0（如 -1），使用 db.busyRetryMax 代替
                for i in 0..<(retry >= 0 ? retry : db.busyRetryMax) {
                    let result = sqlite3_step(stmt)
                    switch result {
                    case SQLITE_ROW:
                        successCount += 1
                        db.successCount += 1
                        return true
                    case SQLITE_DONE:
                        try reset()
                        successCount += 1
                        db.successCount += 1
                        return false
                    case SQLITE_BUSY, SQLITE_LOCKED:
                        busyCount += 1
                        db.busyCount += 1
                        // 等待时间越来越长(毫秒)
                        if i == 0 {
                            // 1st 0.02ms
                            usleep(20)
                        } else if i == 1 {
                            // 2nd 0.25ms
                            usleep(250)
                        } else if i <= 8 {
                            // 0.5ms, 2ms, 8ms, 32ms, 128ms, 512ms, 2048ms(2s)
                            usleep(useconds_t(500.0 * pow(4.0, Double(i - 2))))
                        } else {
                            // 3s ...
                            usleep(3000000)
                        }
                    default:
                        throw SqliteError(rawValue: result, message: db.errMsg, sql: expandedSql)
                    }
                }
                throw SqliteError(rawValue: result, message: db.errMsg, sql: expandedSql)
            default:
                throw SqliteError(rawValue: result, message: db.errMsg, sql: expandedSql)
            }
        }
        
        public func columnIndex(_ name: String) -> Int32? {
            return columnMap[name]
        }
        
        public func bool(_ index: Int32) -> Bool {
            guard index >= 0 && index < columnCount else {
                return false
            }
            return sqlite3_column_int(stmt, index) != 0
        }
        
        public func bool(name: String) -> Bool {
            guard let index = columnIndex(name) else {
                return false
            }
            return sqlite3_column_int(stmt, index) != 0
        }
        
        public func int(_ index: Int32) -> Int32 {
            guard index >= 0 && index < columnCount else {
                return -1
            }
            return sqlite3_column_int(stmt, index)
        }
        
        public func int(name: String) -> Int32 {
            guard let index = columnIndex(name) else {
                return -1
            }
            return sqlite3_column_int(stmt, index)
        }
        
        public func int64(_ index: Int32) -> Int64 {
            guard index >= 0 && index < columnCount else {
                return -1
            }
            return sqlite3_column_int64(stmt, index)
        }
        
        public func int64(name: String) -> Int64 {
            guard let index = columnIndex(name) else {
                return -1
            }
            return sqlite3_column_int64(stmt, index)
        }
        
        public func double(_ index: Int32) -> Double {
            guard index >= 0 && index < columnCount else {
                return -1.0
            }
            return sqlite3_column_double(stmt, index)
        }
        
        public func double(name: String) -> Double {
            guard let index = columnIndex(name) else {
                return -1.0
            }
            return sqlite3_column_double(stmt, index)
        }
        
        public func string(_ index: Int32) -> String {
            guard let textPointer = sqlite3_column_text(stmt, index) else {
                return ""
            }
            return String(cString: textPointer)
        }
        
        public func string(name: String) -> String {
            guard let index = columnIndex(name) else {
                return ""
            }
            return string(index)
        }
        
        public func optionalString(_ index: Int32) -> String? {
            guard let textPointer = sqlite3_column_text(stmt, index) else {
                return nil
            }
            return String(cString: textPointer)
        }
        
        public func optionalString(name: String) -> String? {
            guard let index = columnIndex(name) else {
                return nil
            }
            return optionalString(index)
        }
        
        public func blob(_ index: Int32) -> Data? {
            guard let pointer = sqlite3_column_blob(stmt, index) else {
                return nil
            }
            let length = Int(sqlite3_column_bytes(stmt, index))
            return Data(bytes: pointer, count: length)
        }
        
        public func blob(name: String) -> Data? {
            guard let index = columnIndex(name) else {
                return nil
            }
            return blob(index)
        }
        
        public func value(_ index: Int32) -> OpaquePointer? {
            guard let valuePointer = sqlite3_column_value(stmt, index) else {
                return nil
            }
            return valuePointer
        }
        
        public func value(name: String) -> OpaquePointer? {
            guard let index = columnIndex(name) else {
                return nil
            }
            return value(index)
        }
        
        // sqlite3_column_type() 的返回值可以用来决定应该使用哪个接口来提取列的值。
        public func columnType(_ index: Int32) -> ColumnType {
            return ColumnType(rawValue: sqlite3_column_type(stmt, index))!
        }
        
        /**
         sqlite3_finalize 函数用于销毁一个预处理语句对象，并释放与之相关的资源。在SQLite中，预处理语句对象（prepared statement）是通过 sqlite3_prepare_v2 或 sqlite3_prepare 等函数创建的。
         当不再需要一个预处理语句对象时，应该使用 sqlite3_finalize 函数来销毁它。这个函数接受一个指向预处理语句对象的指针作为参数，并返回一个整数结果码，通常是 SQLITE_OK 表示成功。
         调用 sqlite3_finalize 函数后，与该预处理语句相关的资源将被释放，包括编译后的字节码、临时数据结构等。如果没有调用 sqlite3_finalize 函数而直接关闭数据库连接，SQLite库会在数据库连接关闭时自动销毁所有尚未销毁的预处理语句对象，但这并不是一个良好的做法，因为可能会导致内存泄漏或其他问题。
         在使用完一个预处理语句对象后，应该调用 sqlite3_finalize 来释放资源，这样可以确保程序在执行过程中不会出现资源泄漏或其他问题。
         */
        @discardableResult
        public func finalize() -> Bool {
            return sqlite3_finalize(stmt) == SQLITE_OK
        }
        
        /**
         sqlite3_reset 函数用于重置一个预处理语句（prepared statement）到其初始状态，以便重新执行。
         当调用 sqlite3_step 函数返回 SQLITE_DONE 或 SQLITE_ROW 时，预处理语句的状态会发生改变，此时可以使用 sqlite3_reset 将其重置为初始状态。
         调用 sqlite3_reset 会清除语句的游标状态，使其可以重新执行。这包括清除任何绑定的参数和重置游标以准备执行下一次查询。
         如果预处理语句之前已经执行过，则 sqlite3_reset 会将语句的状态重置为初始状态，以便重新执行。
         */
        public func reset() throws {
            let result = sqlite3_reset(stmt)
            guard result == SQLITE_OK else {
                throw SqliteError(rawValue: result, message: db.errMsg, sql: expandedSql)
            }
        }
        
        public func status(_ op: StmtStatus, reset: Bool = false) -> Int32 {
            return sqlite3_stmt_status(stmt, op.rawValue, reset ? 1 : 0)
        }
    }
}
