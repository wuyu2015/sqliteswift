import SqliteWrapper

extension Sqlite {
    public class Db {
        public let db: OpaquePointer
        public var lastId: Int64 {
            get {
                return sqlite3_last_insert_rowid(db)
            }
            set {
                sqlite3_set_last_insert_rowid(db, newValue)
            }
        }
        
        init(path: String = ":memory:", flags: [FileOpenFlag] = [.READWRITE, .CREATE]) {
            var dbPointer: OpaquePointer?
            guard sqlite3_open_v2(path, &dbPointer, flags.reduce(0) { $0 | $1.rawValue }, nil) == SQLITE_OK else {
                fatalError("Failed to open database.")
            }
            db = dbPointer!
        }
        
        /**
         数据库连接配置
         */
        public func dbConfig(_ option: Config, _ params: CVarArg...) -> ErrorCode {
            return withVaList(params) { pointer in
                return ErrorCode(rawValue: sqliteWrapperDbConfig(db, option.rawValue, pointer))!
            }
        }
        
        /**
         在默认配置下，SQLite API 函数返回 30 个整数 [ErrorCode] 之一。
         但是，经验表明，许多这些结果代码过于粗略。
         它们没有提供程序员可能希望得到的关于问题的更多信息。
         为了解决这个问题，SQLite 的新版本（3.3.8 及更高版本）
         包括对额外结果代码的支持，这些结果代码提供了更详细的错误信息。
         这些[extended result codes]可通过使用 [sqlite3_extended_result_codes()] API
         在每个数据库连接的基础上启用或禁用。或者，可以使用
         [sqlite3_extended_errcode()] 获得最近错误的扩展代码。
         */
        public func extendedResultCodes(_ onoff: Bool) -> ErrorCode {
            return ErrorCode(rawValue: sqlite3_extended_result_codes(db, onoff ? 1 : 0))!
        }
        
        /**
         这个函数返回最近一次在指定数据库连接上完成的 INSERT、UPDATE 或 DELETE语句修改、插入或删除的行数。
         执行其他类型的 SQL 语句不会修改该函数返回的值。
         */
        public func changes() -> Int32 {
            return sqlite3_changes(db)
        }
        
        /**
         此函数返回自数据库连接打开以来完成的所有 INSERT、UPDATE 或 DELETE 语句插入、修改或删除的总行数，包括作为触发器程序的一部分执行的行为。
         执行其他类型的 SQL 语句不会影响 totalChanges() 返回的值。
         */
        public func totalChanges() -> Int32 {
            return sqlite3_total_changes(db)
        }
        
        public func interrupt() {
            sqlite3_interrupt(db)
        }
        
        /**
         注册 SQLITE_BUSY 的回调函数
         sqlite3_busy_handler(D,X,P) 函数设置一个回调函数 X，当试图访问与数据库连接 D 关联的数据库表时，如果另一个线程或进程已经锁定了该表，可能会调用回调函数，并且带有参数 P。
         如果繁忙回调为空，则在遇到锁定时立即返回 SQLITE_BUSY。如果繁忙回调不为空，则可能会使用两个参数调用回调函数。
         繁忙处理程序的第一个参数是 sqlite3_busy_handler() 的第三个参数的副本。繁忙处理程序回调的第二个参数是相同锁定事件的繁忙处理程序先前已被调用的次数。如果繁忙回调返回 0，则不会尝试访问数据库，并且将 SQLITE_BUSY 返回给应用程序。如果回调返回非零值，则会尝试再次访问数据库，循环重复。
         每个数据库连接只能定义一个繁忙处理程序。设置新的繁忙处理程序会清除先前设置的任何处理程序。
         */
        public func busyHandler(
            _ callback: (@convention(c) (UnsafeMutableRawPointer?, Int32) -> Int32)?, context: UnsafeMutableRawPointer?) -> Int32 {
            return sqlite3_busy_handler(db, callback, context)
        }
        
        /**
         设置忙时超时
         设置一个 [sqlite3_busy_handler | 忙时处理器]，当一个表被锁定时会休眠指定的时间。
         处理器将休眠多次，直到累计的休眠时间至少达到 "ms" 毫秒。
         在至少 "ms" 毫秒的休眠后，处理器返回 0，导致 [sqlite3_step()] 返回 [SQLITE_BUSY]。
         */
        public func busyTimeout(_ ms: Int32) -> ErrorCode {
            return ErrorCode(rawValue: sqlite3_busy_timeout(db, ms))!
        }
        
        /**
         跟踪和分析执行 SQL 语句的过程
         M 是一个属性掩码，用于指定何时调用回调函数。可以是零或者多个 SQLITE_TRACE 常量的按位或。
         X 是回调函数，当指定的事件发生时被调用。如果 X 是 NULL，或者 M 的值为零，则跟踪被禁用。
         P 是上下文指针，它会被传递给回调函数。
         */
        @available(OSX 10.12, *)
        public func trace(_ uMask: UInt32, _ xCallback: (@convention(c) (UInt32, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Int32)!, _ pCtx: UnsafeMutableRawPointer!) -> Int32 {
            return sqlite3_trace_v2(db, uMask, xCallback, pCtx)
        }
        
        /**
         这个接口允许你注册一个回调函数，在长时间运行的数据库操作期间定期调用该函数。比如说，你在执行一个大型查询时，可以用它来更新 GUI，让用户知道查询的进度。
         这个函数有四个参数：数据库连接 D、一个整数 N、一个回调函数 X，以及一个上下文指针 P。每次调用回调函数 X 之间，大约会执行 N 个虚拟机指令。如果 N 小于1，那么进度处理程序将被禁用。
         只能为每个数据库连接定义一个进度处理程序。设置新的进度处理程序会取消旧的处理程序。将回调函数 X 设置为 NULL 会禁用进度处理程序。将 N 设置为小于1的值也会禁用它。
         如果进度回调函数返回一个非零值，操作会被中断。这个功能可以用来实现 GUI 进度对话框上的“取消”按钮。
         请注意，进度处理程序回调不能执行任何会修改数据库连接的操作。
         */
        public func setProgressHandler(_ numberOfInstructions: Int32, _ callback: (@convention(c) (UnsafeMutableRawPointer?) -> Int32)!, _ context: UnsafeMutableRawPointer!) {
            sqlite3_progress_handler(db, numberOfInstructions, callback, context)
        }
        
        deinit {
            sqlite3_close(db)
        }
    }
}
