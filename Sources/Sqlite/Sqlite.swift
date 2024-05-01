import SQLite3

public enum Sqlite {
    // 如: 3.28.0
    public static let version: String = SQLITE_VERSION
    
    // 如: 3028000
    public static let versionNumber: Int32 = SQLITE_VERSION_NUMBER
    
    // 如: 2019-04-15 14:49:49 378230ae7f4b721c8b8d83c8ceb891449685cd23b1702a57841f1be40b5daapl
    public static let sourceId: String = SQLITE_SOURCE_ID
}
