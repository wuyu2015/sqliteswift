extension Sqlite {
    public enum PrepareFlag: Int32 {
        /// SQLITE_PREPARE_PERSISTENT 标志是一个提示，告诉查询规划器准备好的语句将被长时间保留并可能多次重用。
        /// 如果没有此标志，sqlite3_prepare_v3() 和 sqlite3_prepare16_v3() 假设准备好的语句将仅被使用一次或最多几次，
        /// 然后很快就会使用 sqlite3_finalize() 销毁。当前的实现根据此提示避免使用回看内存，以免耗尽有限的回看内存。
        /// SQLite 的将来版本可能会以不同的方式处理此提示。
        case PERSISTENT = 1
        
        /// SQLITE_PREPARE_NORMALIZE 标志是一个无操作。
        case NORMALIZE = 2
        
        /// SQLITE_PREPARE_NO_VTAB 标志导致 SQL 编译器返回错误（错误代码SQLITE_ERROR），
        /// 如果语句使用任何虚拟表。
        case NO_VTAB = 4
    }
}
