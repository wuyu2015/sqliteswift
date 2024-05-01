import XCTest

import SqliteTests

var tests = [XCTestCaseEntry]()
tests += SqliteTests.allTests()
tests += SqliteEnumTests.allTests()
XCTMain(tests)
