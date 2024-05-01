import SqliteWrapper

extension Sqlite {
    public class Db {
        let db: OpaquePointer
        
        init(path: String = ":memory:", flags: [FileOpenFlag] = [.READWRITE, .CREATE]) {
            var dbPointer: OpaquePointer?
            guard sqlite3_open_v2(path, &dbPointer, flags.reduce(0) { $0 | $1.rawValue }, nil) == SQLITE_OK else {
                fatalError("Failed to open database.")
            }
            db = dbPointer!
        }
        
        func dbConfig(_ option: Config, _ params: CVarArg...) -> ErrorCode {
            return withVaList(params) { pointer in
                return ErrorCode(rawValue: sqliteWrapperDbConfig(db, option.rawValue, pointer))!
            }
        }

        deinit {
            sqlite3_close(db)
        }
    }
}
