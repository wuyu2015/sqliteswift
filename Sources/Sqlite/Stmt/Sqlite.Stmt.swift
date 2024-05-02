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
            if #available(OSX 10.12, *) {
                return try checkResult(sqlite3_bind_zeroblob64(stmt, updateBindIndex(index), sqlite3_uint64(length)))
            } else {
                return try checkResult(sqlite3_bind_zeroblob(stmt, updateBindIndex(index), Int32(length)))
            }
        }
    }
}
