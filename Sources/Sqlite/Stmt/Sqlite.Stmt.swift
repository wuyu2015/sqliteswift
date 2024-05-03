import Foundation
import SQLite3

extension Sqlite {
    public struct Stmt {
        public let stmt: OpaquePointer
        var bindIndex: Int32 = 0
        
        /**
         返回一个布尔值，指示 stmt 是否为只读。
         
         如果一个准备好的语句对数据库文件没有直接的更改，则 sqlite3_stmt_readonly 接口返回 true（非零）。
         应用程序定义的 SQL 函数或虚拟表可能通过副作用间接地改变数据库。例如，如果应用程序定义了一个名为 "eval()" 的函数，它调用了 sqlite3_exec()，那么下面的 SQL 语句通过副作用会改变数据库文件。
         事务控制语句（例如 [BEGIN]、[COMMIT]、[ROLLBACK]、[SAVEPOINT] 和 [RELEASE]）会导致 sqlite3_stmt_readonly 返回 true，因为这些语句本身并不实际修改数据库，而是控制其他语句何时修改数据库的时机。
         [ATTACH] 和 [DETACH] 语句也会导致 sqlite3_stmt_readonly 返回 true，因为它们虽然会改变数据库连接的配置，但不会修改数据库文件的内容。
         对于 [BEGIN] 语句，sqlite3_stmt_readonly 返回 true，因为 [BEGIN] 只是设置内部标志。但是，[BEGIN IMMEDIATE] 和 [BEGIN EXCLUSIVE] 命令会触及数据库，因此 sqlite3_stmt_readonly 对于这些命令返回 false。
         */
        public var isReadOnly: Bool {
            return sqlite3_stmt_readonly(stmt) != 0
        }
        
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
        
        public var bingParameterCount: Int32 {
            return sqlite3_bind_parameter_count(stmt)
        }
        
        public var columnCount: Int32 {
            return sqlite3_column_count(stmt)
        }
        
        public var dataCount: Int32 {
            return sqlite3_data_count(stmt)
        }
        
        init(_ pStmt: OpaquePointer) {
            stmt = pStmt
        }
        
        private func checkResult(_ result: Int32) throws -> Self {
            guard result == SQLITE_OK else {
                throw ErrorCode(rawValue: result)
            }
            return self
        }
        
        private mutating func updateBindIndex(_ index: Int) -> Int32 {
            bindIndex = index > 0 ? Int32(index) : bindIndex + 1
            return bindIndex
        }
        
        /**
         返回与准备语句关联的原f始 SQL 字符串。
         
         - Returns: 与 stmt 关联的原始 SQL 字符串，如果语句无效或没有关联的 SQL 字符串则返回 nil。
        */
        public func sql() -> String? {
            guard let cString = sqlite3_sql(stmt) else {
                return nil
            }
            return String(cString: cString)
        }
        
        public mutating func bind(_ value: Int, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, updateBindIndex(index), Int64(value)))
        }
        
        public mutating func bind(_ value: UInt64, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, updateBindIndex(index), sqlite3_int64(value)))
        }
        
        public mutating func bind(_ value: Int64, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, updateBindIndex(index), value))
        }
        
        public mutating func bind(_ value: UInt32, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_int64(stmt, updateBindIndex(index), Int64(value)))
        }
        
        public mutating func bind(_ value: Int32, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_int(stmt, updateBindIndex(index), value))
        }
        
        public mutating func bind(_ value: Float, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_double(stmt, updateBindIndex(index), Double(value)))
        }
        
        public mutating func bind(_ value: Double, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_double(stmt, updateBindIndex(index), value))
        }
        
        public mutating func bind(_ value: String, index: Int = 0) throws -> Self {
            let cString = value.withCString { (ptr: UnsafePointer<Int8>) -> UnsafePointer<Int8> in
                return ptr
            }
            return try checkResult(sqlite3_bind_text(stmt, updateBindIndex(index), cString, -1, nil))
        }
        
        public mutating func bind(_ cString: UnsafePointer<Int8>, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_text(stmt, updateBindIndex(index), cString, -1, nil))
        }
        
        public mutating func bind(_ data: [UInt8], index: Int = 0) throws -> Self {
            return try checkResult(
                data.count <= Int(Int32.max)
                    ? sqlite3_bind_blob(stmt, updateBindIndex(index), data, Int32(data.count), nil)
                    : sqlite3_bind_blob64(stmt, updateBindIndex(index), data, UInt64(data.count), nil)
            )
        }
        
        public mutating func bind(_ pointer: OpaquePointer!, index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_value(stmt, updateBindIndex(index), pointer))
        }
        
        public mutating func bindNull(index: Int = 0) throws -> Self {
            return try checkResult(sqlite3_bind_null(stmt, updateBindIndex(index)))
        }
        
        public mutating func bindZeroBlob(index: Int = 0, length: Int) throws -> Self {
            if #available(OSX 10.12, iOS 10.0, *) {
                return try checkResult(sqlite3_bind_zeroblob64(stmt, updateBindIndex(index), sqlite3_uint64(length)))
            } else {
                return try checkResult(sqlite3_bind_zeroblob(stmt, updateBindIndex(index), Int32(length)))
            }
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
        public func bindParameterName(index: Int32) -> String? {
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
        
        public mutating func clearBinding() throws -> Self {
            bindIndex = 0
            return try checkResult(sqlite3_clear_bindings(stmt))
        }
        
        /**
         获取当前结果集中指定列的名称。
         
         - Parameter index: 列的索引，从0开始。
         - Returns: 列的名称。
         */
        public func columnName(index: Int32) -> String? {
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
        public func columnDatabaseName(index: Int32) -> String? {
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
        public func columnTableName(index: Int32) -> String? {
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
        public func columnOriginName(index: Int32) -> String? {
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
        public func columnDecltype(index: Int32) -> String? {
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
        public func step() throws -> Bool {
            let result = sqlite3_step(stmt)
            switch result {
            case SQLITE_ROW:
                return true
            case SQLITE_DONE:
                return false
            default:
                throw ErrorCode(rawValue: result)
            }
        }
        
        public func columnBlob(index: Int32) -> Data? {
            guard let pointer = sqlite3_column_blob(stmt, index) else {
                return nil
            }
            let length = Int(sqlite3_column_bytes(stmt, index))
            return Data(bytes: pointer, count: length)
        }
        
        public func columnDouble(index: Int32) -> Double {
            return sqlite3_column_double(stmt, index)
        }
        
        public func columnInt(index: Int32) -> Int32 {
            return sqlite3_column_int(stmt, index)
        }
        
        public func columnInt64(index: Int32) -> Int64 {
            return sqlite3_column_int64(stmt, index)
        }
        
        public func columnText(index: Int32) -> String {
            guard let textPointer = sqlite3_column_text(stmt, index) else {
                return ""
            }
            return String(cString: textPointer)
        }
        
        public func columnValue(index: Int32) -> OpaquePointer? {
            guard let valuePointer = sqlite3_column_value(stmt, index) else {
                return nil
            }
            return valuePointer
        }
        
        // sqlite3_column_type() 的返回值可以用来决定应该使用哪个接口来提取列的值。
        public func columnType(index: Int32) -> ColumnType {
            return ColumnType(rawValue: sqlite3_column_type(stmt, index))!
        }
        
        /**
         sqlite3_finalize 函数用于销毁一个预处理语句对象，并释放与之相关的资源。在SQLite中，预处理语句对象（prepared statement）是通过 sqlite3_prepare_v2 或 sqlite3_prepare 等函数创建的。
         当不再需要一个预处理语句对象时，应该使用 sqlite3_finalize 函数来销毁它。这个函数接受一个指向预处理语句对象的指针作为参数，并返回一个整数结果码，通常是 SQLITE_OK 表示成功。
         调用 sqlite3_finalize 函数后，与该预处理语句相关的资源将被释放，包括编译后的字节码、临时数据结构等。如果没有调用 sqlite3_finalize 函数而直接关闭数据库连接，SQLite库会在数据库连接关闭时自动销毁所有尚未销毁的预处理语句对象，但这并不是一个良好的做法，因为可能会导致内存泄漏或其他问题。
         在使用完一个预处理语句对象后，应该调用 sqlite3_finalize 来释放资源，这样可以确保程序在执行过程中不会出现资源泄漏或其他问题。
         */
        public func finalize() throws {
            let result = sqlite3_finalize(stmt)
            if result == SQLITE_OK {
                throw ErrorCode(rawValue: result)
            }
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
                throw ErrorCode(rawValue: result)
            }
        }
        
    }
}
