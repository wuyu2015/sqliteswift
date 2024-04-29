import XCTest

import SqliteTests

var tests = [XCTestCaseEntry]()
tests += SqliteTests.allTests()
XCTMain(tests)
