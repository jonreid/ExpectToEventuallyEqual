// SPDX-License-Identifier: MIT

@testable import ExpectToEventuallyEqual
import XCTest

final class DescribeTests: XCTestCase {
    func test_describeStringWithQuotes_enclosesInQuotes_escapingBackslashAndQuote() throws {
        XCTAssertEqual(describe(String.self, value: "a\"b"), "\"a\\\"b\"")
    }

    func test_describeStringWithNewline_enclosesInQuotes_escapingBackslash() throws {
        XCTAssertEqual(describe(String.self, value: "a\nb"), "\"a\\nb\"")
    }

    func test_describeStringWithCarriageReturn_enclosesInQuotes_escapingBackslash() throws {
        XCTAssertEqual(describe(String.self, value: "a\rb"), "\"a\\rb\"")
    }

    func test_describeStringWithTab_enclosesInQuotes_escapingBackslash() throws {
        XCTAssertEqual(describe(String.self, value: "a\tb"), "\"a\\tb\"")
    }
}
