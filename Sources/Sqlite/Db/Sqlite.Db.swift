import SqliteWrapper

extension Sqlite {
    public class Db {
        public let db: OpaquePointer
        
        /**
         ROWID:
         每个 SQLite 表中的条目（除了 WITHOUT ROWID 表）都有一个唯一的 64 位有符号整数键，称为 "rowid"。
         Rowid 始终作为一个未声明的列名为 ROWID、OID 或 ROWID 存在，只要这些名称不被明确声明的列使用。如果表具有 INTEGER PRIMARY KEY 类型的列，那么该列也是 rowid 的另一个别名。
         sqlite3_last_insert_rowid 函数:
         sqlite3_last_insert_rowid(D) 函数通常返回在数据库连接 D 上最近成功的对 rowid 表或虚拟表的 INSERT 的 rowid。
         对 WITHOUT ROWID 表的插入不记录在内。
         如果在数据库连接 D 上从未发生过对 rowid 表的成功插入，则 sqlite3_last_insert_rowid(D) 返回零。
         除了在插入数据库表时自动设置之外，此函数返回的值也可以通过 sqlite3_set_last_insert_rowid() 显式设置。
         对于一些虚拟表实现，它们在提交事务时可能会向 rowid 表插入行（例如，将内存中累积的数据刷新到磁盘）。在这种情况下，后续对此函数的调用会返回与这些内部 INSERT 操作关联的 rowid，导致不直观的结果。遇到这种情况的虚拟表实现可以通过在返回控制权给用户之前使用 sqlite3_set_last_insert_rowid() 恢复原始的 rowid 值来避免此问题。
         插入触发器:
         如果触发器内发生 INSERT 操作，那么此函数将返回插入的行的 rowid，只要触发器正在运行。触发器程序结束后，此函数的返回值将恢复到触发器触发之前的值。
         约束冲突:
         由于约束冲突而失败的 INSERT 不算是成功的 [INSERT]，不会改变此函数返回的值。因此，INSERT OR FAIL、INSERT OR IGNORE、INSERT OR ROLLBACK 和 INSERT OR ABORT 在插入失败时不会更改此接口的返回值。当 INSERT OR REPLACE 遇到约束冲突时，它不会失败。INSERT 继续完成后，删除导致约束问题的行，因此 INSERT OR REPLACE 总是会更改此接口的返回值。
         事务回滚:
         对于此函数，即使插入后随后被回滚，插入也被认为是成功的。
         最后，该函数可以通过 last_insert_rowid() SQL function 在 SQL 语句中访问。如果在 sqlite3_last_insert_rowid() 函数运行时，另一个线程在同一数据库连接上执行新的 INSERT，从而更改了最后插入的 [rowid]，那么 sqlite3_last_insert_rowid() 返回的值是不可预测的，可能不等于旧的或新的最后插入的 [rowid]。
         */
        public var lastId: Int64 {
            get {
                return sqlite3_last_insert_rowid(db)
            }
            set {
                sqlite3_set_last_insert_rowid(db, newValue)
            }
        }
        
        /**
         这个函数返回最近一次在指定数据库连接上完成的 INSERT、UPDATE 或 DELETE语句修改、插入或删除的行数。
         执行其他类型的 SQL 语句不会修改该函数返回的值。
         */
        public var changes: Int32 {
            return sqlite3_changes(db)
        }
        
        /**
         此函数返回自数据库连接打开以来完成的所有 INSERT、UPDATE 或 DELETE 语句插入、修改或删除的总行数，包括作为触发器程序的一部分执行的行为。
         执行其他类型的 SQL 语句不会影响 totalChanges() 返回的值。
         */
        public var totalChanges: Int32 {
            return sqlite3_total_changes(db)
        }
        
        /**
         打开一个新的数据库连接
         
         flags 参数可以采用以下三个值之一，可选地与 SQLITE_OPEN_NOMUTEX、SQLITE_OPEN_FULLMUTEX、SQLITE_OPEN_SHAREDCACHE、SQLITE_OPEN_PRIVATECACHE 和/或 SQLITE_OPEN_URI 标志组合使用：

         SQLITE_OPEN_READONLY：以只读模式打开数据库。如果数据库不存在，则返回错误。
         SQLITE_OPEN_READWRITE：如果可能的话，以读写模式打开数据库；如果文件受操作系统写保护，则只读模式打开。无论哪种情况，都要求数据库已经存在，否则返回错误。
         
         SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE：以读写模式打开数据库，如果数据库不存在则创建。这是 sqlite3_open() 和 sqlite3_open16() 始终使用的行为。
         
         如果 flags 参数不是上述组合之一，也没有与其他 SQLITE_OPEN_READONLY | SQLITE_OPEN_* 位组合，则行为是未定义的。
         
         如果文件名为 ":memory:"，则会为连接创建一个私有的临时内存数据库。当数据库连接关闭时，此内存数据库将消失。未来版本的 SQLite 可能会使用其他以 ":" 字符开头的特殊文件名。建议当数据库文件名实际上以 ":" 字符开头时，应该将文件名前缀为路径名，如 "./"，以避免歧义。

         如果文件名为空字符串，则会创建一个私有的临时磁盘数据库。此私有数据库将在数据库连接关闭时自动删除。
         
         [URI 文件名] 若启用了解释，则文件名参数以 "file:" 开头，则文件名将被解释为 URI。如果第三个参数传递给 sqlite3_open_v2() 中设置了 SQLITE_OPEN_URI 标志，或者已使用 SQLITE_CONFIG_URI 选项通过 sqlite3_config() 方法或 SQLITE_USE_URI 编译时选项全局启用了它，则启用 URI 文件名解释。URI 文件名解释默认是关闭的，但是未来版本的 SQLite 可能会默认启用 URI 文件名解释。
         
         URI 文件名按照 RFC 3986 进行解析。如果 URI 包含权限，则权限必须是空字符串或字符串 "localhost"。如果权限不是空字符串或 "localhost"，则返回错误给调用者。如果 URI 包含片段组件，则会被忽略。SQLite 使用 URI 的路径组件作为包含数据库的磁盘文件的名称。如果路径以 '/' 字符开头，则它被解释为绝对路径。如果路径不以 '/' 开头（即省略了 URI 中的权限部分），则路径被解释为相对路径。在 Windows 上，绝对路径的第一个组件是驱动器规范（例如 "C:"）。

         [核心 URI 查询参数] URI 的查询组件可以包含由 SQLite 本身或 [VFS | 自定义 VFS 实现] 解释的参数。SQLite 及其内置 [VFSes] 解释以下查询参数：

         vfs： "vfs" 参数可以用于指定一个提供操作系统接口的 VFS 对象的名称，该接口应用于访问磁盘上的数据库文件。
         
         如果此选项设置为空字符串，则使用默认的 VFS 对象。指定未知的 VFS 是一个错误。如果 sqlite3_open_v2() 使用了 vfs 选项参数，则该选项中指定的 VFS 优先于作为 sqlite3_open_v2() 的第四个参数传递的值。
         
         mode： mode 参数可以设置为 "ro"、"rw"、"rwc" 或 "memory"。尝试将其设置为其他任何值都是错误的。如果指定为 "ro"，则数据库以只读模式打开，就像将 SQLITE_OPEN_READONLY 标志设置在 sqlite3_open_v2() 的第三个参数中一样。
         
         如果 mode 选项设置为 "rw"，则数据库以读写模式（但不创建）打开，就像设置了 SQLITE_OPEN_READWRITE（但没有设置 SQLITE_OPEN_CREATE）一样。值 "rwc" 等效于同时设置 SQLITE_OPEN_READWRITE 和 SQLITE_OPEN_CREATE。如果 mode 选项设置为 "memory"，则使用永远不从磁盘读取或写入的纯 [内存数据库]。指定比在 sqlite3_open_v2() 的第三个参数中传递的标志更不严格的 mode 参数值是错误的。
         
         cache： cache 参数可以设置为 "shared" 或 "private"。将其设置为 "shared" 等效于在传递给 sqlite3_open_v2() 的 flags 参数中设置 SQLITE_OPEN_SHAREDCACHE 位。将缓存参数设置为 "private" 等效于设置 SQLITE_OPEN_PRIVATECACHE 位。
         
         如果 sqlite3_open_v2() 中的 URI 文件名中存在 "cache" 参数，则其值将覆盖通过设置 SQLITE_OPEN_PRIVATECACHE 或 SQLITE_OPEN_SHAREDCACHE 标志请求的任何行为。
         
         psow： psow 参数指示数据库文件所在的存储介质是否适用于 [powersafe overwrite] 属性。
         
         nolock： nolock 参数是一个布尔查询参数，如果设置了，则在回滚日志模式下禁用文件锁定。这对于访问不支持锁定的文件系统上的数据库很有用。注意：如果两个或多个进程写入同一个数据库，并且其中一个进程使用了 nolock=1，可能会导致数据库损坏。
         
         immutable： immutable 参数是一个布尔查询参数，表示数据库文件存储在只读介质上。当 immutable 设置时，SQLite 假定数据库文件无法更改，即使是拥有更高权限的进程也是如此，因此数据库以只读模式打开，并且所有锁定和更改检测都被禁用。注意：在实际上是可更改的数据库文件上设置 immutable 属性可能导致查询结果不正确和/或 [SQLITE_CORRUPT] 错误。另请参阅：[SQLITE_IOCAP_IMMUTABLE]。
         
         在 URI 文件名的查询组件中指定未知参数不是一个错误。未来版本的 SQLite 可能会理解更多的查询参数。有关更多信息，请参阅“[对 SQLite 有特殊含义的查询参数]”。
         
         [URI 文件名示例] URI 文件名示例
         file:data.db：在当前目录中打开文件 "data.db"。
         file:/home/fred/data.db
         file:///home/fred/data.db
         file://localhost/home/fred/data.db：打开数据库文件 "/home/fred/data.db"。
         file://darkstar/home/fred/data.db：错误。 "darkstar" 不是一个被识别的权限。
         file:///C:/Documents%20and%20Settings/fred/Desktop/data.db：仅 Windows：在 C 驱动器上的 fred 桌面中打开文件 "data.db"。请注意，在此示例中的 %20 转义实际上并不是严格必需的 - URI 文件名中的空格字符可以按字面意义使用。
         file:data.db?mode=ro&cache=private：在当前目录中以只读模式打开文件 "data.db"。不管默认是否启用了共享缓存模式，都使用私有缓存。
         file:/home/fred/data.db?vfs=unix-dotfile：打开文件 "/home/fred/data.db"。使用特殊的 VFS "unix-dotfile"，该 VFS 使用点文件代替 posix 建议的锁定。
         file:data.db?mode=readonly：错误。"readonly" 不是 "mode" 参数的有效选项。
         
         在 URI 的路径和查询组件中支持 URI 十六进制转义序列（%HH）。十六进制转义序列由一个百分号 - "%" - 后跟两个十六进制数字指定的八位字值组成。在解释 URI 文件名的路径或查询组件之前，它们会被编码为 UTF-8，并且所有十六进制转义序列都被替换为一个包含相应字节的单个字节。如果此过程生成无效的 UTF-8 编码，则结果是未定义的。
         
         注意： 在 sqlite3_open() 和 sqlite3_open_v2() 的文件名参数中使用的编码必须是 UTF-8，而不是当前定义的任何代码页。包含国际字符的文件名必须在传递给 sqlite3_open() 或 sqlite3_open_v2() 之前转换为 UTF-8。

         注意： 在调用 sqlite3_open() 或 sqlite3_open_v2() 之前必须设置临时目录。否则，可能会导致需要使用临时文件的各种功能失败。

         另请参阅：[sqlite3_temp_directory]
         */
        init(path: String = ":memory:", flags: [OpenFlag] = [.READWRITE, .CREATE]) {
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
        
        public func errCode() -> ErrorCode {
            return ErrorCode(rawValue: sqlite3_errcode(db))!
        }
        
        public func extendedErrCode() -> ErrorCode {
            return ErrorCode(rawValue: sqlite3_extended_errcode(db))!
        }
        
        public func errMsg() -> String {
            return String(cString: sqlite3_errmsg(db))
        }
        
        public func setLimit(_ limit: Limit, _ newVal: Int32) -> ErrorCode {
            return ErrorCode(rawValue: sqlite3_limit(db, limit.rawValue, newVal))!
        }
        
        deinit {
            sqlite3_close(db)
        }
    }
}
