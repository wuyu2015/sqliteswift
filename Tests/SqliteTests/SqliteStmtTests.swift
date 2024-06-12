import XCTest
@testable import Sqlite
import SQLite3

final class SqliteStmtTests: XCTestCase {
    func test1() throws {
        let db = try Sqlite.Db()
        XCTAssertTrue(db.dbReadable("main"))
        XCTAssertTrue(db.dbWritable("main"))
        XCTAssertFalse(db.dbReadOnly("main"))
        XCTAssertFalse(db.dbReadable("main2"))
        XCTAssertFalse(db.dbWritable("main2"))
        XCTAssertFalse(db.dbReadOnly("main2"))
        XCTAssertFalse(try db.isTableExists("test"))
        try db.exec("create table test (a text, b text, c integer, d double, e double)")
        XCTAssertTrue(try db.isTableExists("test"))
        let insertSql = "insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)"
        try db.exec(insertSql, bind: ["first", nil, true, 0.1, "0.2"])
        let insertStmt = try db.prepare(insertSql)
        XCTAssertFalse(insertStmt.isReadOnly)
        XCTAssertEqual(insertStmt.bindParameterCount, 5)
        XCTAssertNil(insertStmt.bindParameterName(6))
        let stmt = try db.prepare("select * from test")
        while(try stmt.step()) {
            XCTAssertEqual(stmt.string(0), "first")
            XCTAssertEqual(stmt.optionalString(1), nil)
            XCTAssertEqual(stmt.int(2), 1)
            XCTAssertEqual(stmt.bool(2), true)
        }
        try insertStmt.bind(1, "hi")
        try insertStmt.bind(5, 1.1)
        try db.begin()
        for i in 1...10 {
            try insertStmt.bind(2, "number \(i)")
            try insertStmt.bind(3, i)
            try insertStmt.bind(4, "\(i)")
            _ = try insertStmt.step()
        }
        try db.rollback()
        try db.begin()
        for i in 11...20 {
            try insertStmt.bind(2, "number \(i)")
            try insertStmt.bind(3, i)
            try insertStmt.bind(4, i)
            _ = try insertStmt.step()
        }
        try db.commit()
        XCTAssertEqual(stmt.columns.count, 5)
        var arr: [[Any]] = []
        while(try stmt.step()) {
            XCTAssertEqual(stmt.string(0), stmt.string(name: "a"))
            XCTAssertEqual(stmt.string(1), stmt.string(name: "b"))
            XCTAssertEqual(stmt.string(5), "")
            XCTAssertEqual(stmt.int(5), -1)
            XCTAssertEqual(stmt.int(name: "notExist"), -1)
            arr.append([
                stmt.string(0),
                stmt.string(1),
                stmt.int(2),
                stmt.double(3),
                stmt.double(4),
            ])
        }
        print(arr)
        XCTAssertEqual(arr.count, 11)
        do {
            try db.vacuum()
        } catch let err as Sqlite.SqliteError {
            print(err.localizedDescription) // TODO: cannot VACUUM - SQL statements in progress
        }
    }
    
    static var allTests = [
        ("test1", test1),
    ]
}
