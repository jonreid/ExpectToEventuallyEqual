// ExpectToEventuallyEqual by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import ExpectToEventuallyEqual
import XCTest

final class DescribeMismatchTests: XCTestCase {
    func test_describeMismatch_forString() throws {
        let message = describeMismatch(String.self, expected: "abc", actual: "def")
        XCTAssertEqual(message, "Expected \"abc\", but was \"def\"")
    }

    func test_describeMismatch_forInt() throws {
        let message = describeMismatch(Int.self, expected: 0, actual: 1)
        XCTAssertEqual(message, "Expected 0, but was 1")
    }

    func test_describeMismatch_forOptionalInt() throws {
        let message = describeMismatch(Int?.self, expected: 3, actual: nil)
        XCTAssertEqual(message, "Expected Optional(3), but was nil")
    }

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

    func test_describeOptionalStringWithTab_enclosesInQuotes_escapingBackslash() throws {
        XCTAssertEqual(describe(String?.self, value: "a\tb"), "Optional(\"a\\tb\")")
    }
}
