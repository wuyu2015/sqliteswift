import XCTest
@testable import Sqlite

final class SqliteTests: XCTestCase {
    func threadSafe() {
        XCTAssertEqual(Sqlite.threadSafe, Sqlite.ThreadSafeLevel.multiThreaded)
        XCTAssertTrue(Sqlite.isThreadSafe)
        XCTAssertFalse(Sqlite.isSingleThreaded)
        XCTAssertTrue(Sqlite.isMultiThreaded)
    }

    static var allTests = [
        ("threadSafe", threadSafe),
    ]
}
