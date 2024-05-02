import SQLite3

extension Sqlite {
    public struct Stmt {
        public let stmt: OpaquePointer
        
        init(_ opaquePointer: OpaquePointer) {
            stmt = opaquePointer
        }
        
        /**
         返回与准备语句关联的原始 SQL 字符串。
         
         - Returns: 与 stmt 关联的原始 SQL 字符串，如果语句无效或没有关联的 SQL 字符串则返回 nil。
        */
        public func sql() -> String? {
            guard let cString = sqlite3_sql(stmt) else {
                return nil
            }
            return String(cString: cString)
        }
    }
}
