import XCTest
@testable import Sqlite
import SQLite3

final class SqliteStmtTests: XCTestCase {
    func test1() throws {
        let db = try Sqlite.Db()
        _ = try db.exec("create table test (a text, b text, c integer, d double, e double)")
        let insertSql = "insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)"
        let insertStmt = try db.prepare(insertSql)
        let stmt = try db.prepare("select * from test")
        XCTAssertFalse(insertStmt.isReadOnly)
        XCTAssertEqual(insertStmt.bindParameterCount, 5)
        XCTAssertNil(insertStmt.bindParameterName(index: 6))
        try db.exec(insertSql, bind: ["first", nil, true, 0.1, 0.2])
        while(try stmt.step()) {
            XCTAssertEqual(stmt.string(index: 0), "first")
            XCTAssertEqual(stmt.optionalString(index: 1), nil)
            XCTAssertEqual(stmt.int(index: 2), 1)
            XCTAssertEqual(stmt.bool(index: 2), true)
        }
        try insertStmt.bind("hi", index: 1)
        try insertStmt.bind(1.1, index: 5)
        try db.begin()
        for i in 1...10 {
            try insertStmt.bind("number \(i)", index: 2)
            try insertStmt.bind(i, index: 3)
            try insertStmt.bind(i, index: 4)
            _ = try insertStmt.step()
        }
        try db.rollback()
        try db.begin()
        for i in 11...20 {
            try insertStmt.bind("number \(i)", index: 2)
            try insertStmt.bind(i, index: 3)
            try insertStmt.bind(i, index: 4)
            _ = try insertStmt.step()
        }
        try db.commit()
        XCTAssertEqual(stmt.columns.count, 5)
        var arr: [[Any]] = []
        while(try stmt.step()) {
            XCTAssertEqual(stmt.string(index: 0), stmt.string(name: "a"))
            XCTAssertEqual(stmt.string(index: 1), stmt.string(name: "b"))
            XCTAssertEqual(stmt.string(index: 5), "")
            XCTAssertEqual(stmt.int(index: 5), -1)
            XCTAssertEqual(stmt.int(name: "notExist"), -1)
            arr.append([
                stmt.string(index: 0),
                stmt.string(index: 1),
                stmt.int(index: 2),
                stmt.double(index: 3),
                stmt.double(index: 4),
            ])
        }
        print(arr)
        XCTAssertEqual(arr.count, 11)
        try db.vacuum()
    }
    
    static var allTests = [
        ("test1", test1),
    ]
}
