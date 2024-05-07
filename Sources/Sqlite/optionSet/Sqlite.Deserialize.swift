import SQLite3

extension Sqlite {
    public struct Deserialize: OptionSet {
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        static let FREEONCLOSE = OpenFlag(rawValue: SQLITE_DESERIALIZE_FREEONCLOSE)
        static let RESIZEABLE = OpenFlag(rawValue: SQLITE_DESERIALIZE_RESIZEABLE)
        static let READONLY = OpenFlag(rawValue: SQLITE_DESERIALIZE_READONLY)
    }
}
