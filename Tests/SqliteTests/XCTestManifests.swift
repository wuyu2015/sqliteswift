import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SqliteTests.allTests),
        testCase(SqliteEnumTests.allTests),
        testCase(SqliteStmtTests.allTests),
    ]
}
#endif
