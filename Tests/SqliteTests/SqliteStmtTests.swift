import XCTest
@testable import Sqlite
import SQLite3

final class SqliteStmtTests: XCTestCase {
    func test1() throws {
        let db = try Sqlite.Db()
        _ = try db.exec("create table test (a text, b text, c integer, d double, e double)")
        let insertStmt = try db.prepare("insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)")
        XCTAssertFalse(insertStmt.isReadOnly)
        XCTAssertEqual(insertStmt.bindParameterCount, 5)
        XCTAssertNil(insertStmt.bindParameterName(index: 6))
        try insertStmt.bind(["first", "number 0", 0, 0.1, 0.2])
        try insertStmt.bind("hi", index: 1)
        try insertStmt.bind(1.1, index: 5)
        for i in 1...10 {
            try insertStmt.bind("number \(i)", index: 2)
            try insertStmt.bind(i, index: 3)
            try insertStmt.bind(i, index: 4)
            _ = try insertStmt.step()
            try insertStmt.reset()
        }
        
        let stmt = try db.prepare("select * from test")
        XCTAssertEqual(stmt.columns.count, 5)
        while(try stmt.step()) {
            XCTAssertEqual(stmt.string(index: 0), stmt.string(name: "a"))
            XCTAssertEqual(stmt.string(index: 1), stmt.string(name: "b"))
            XCTAssertEqual(stmt.string(index: 5), "")
            XCTAssertEqual(stmt.int(index: 6), -1)
            XCTAssertEqual(stmt.int(name: "notExist"), -1)
        }
    }
    
    static var allTests = [
        ("test1", test1),
    ]
}
