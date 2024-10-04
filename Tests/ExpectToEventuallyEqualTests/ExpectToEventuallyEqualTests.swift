// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import ExpectToEventuallyEqual
import XCTest

final class ExpectToEventuallyEqualTests: XCTestCase {
    func test_immediateMatch() throws {
        try expectToEventuallyEqual(actual: { "abc" }, expected: "abc")
    }

    func test_eventualMatch() throws {
        let changeling = Changeling(beforeChange: "nope")

        try expectToEventuallyEqual(
            actual: { changeling.tryAgain(returning: "eventually", after: 5) },
            expected: "eventually"
        )
    }

    func test_failure() throws {
        let changeling = Changeling(beforeChange: "nope")
        let failSpy = FailSpy()

        try expectToEventuallyEqual(
            actual: { changeling.tryAgain(returning: "never", after: 15) },
            expected: "eventually",
            timeout: 0.4,
            fail: failSpy.fail
        )

        XCTAssertEqual(failSpy.callCount, 1, "fail call count")
        XCTAssertTrue(failSpy.message.hasPrefix("Expected \"eventually\", but was \"never\" after "), failSpy.message)
        XCTAssertTrue(failSpy.message.hasSuffix(" tries, timing out after 0.4 seconds"), failSpy.message)
        XCTAssertEqual("\(failSpy.location.filePath)".hasSuffix("/ExpectToEventuallyEqualTests.swift"), true, "file")
        XCTAssertEqual(failSpy.location.line, 26, "line")
    }
}

private class FailSpy {
    var callCount = 0
    var message = ""
    var location = SourceLocation(fileID: "", filePath: "", line: 0, column: 0)

    func fail(_ message: String, location: SourceLocation) {
        callCount += 1
        self.message = message
        self.location = location
    }
}

private class Changeling<T> {
    private let beforeChange: T
    private var tries = 0

    init(beforeChange: T) {
        self.beforeChange = beforeChange
    }

    func tryAgain(returning afterChange: T, after: Int) -> T {
        guard tries < after else {
            return afterChange
        }
        tries += 1
        return beforeChange
    }
}
