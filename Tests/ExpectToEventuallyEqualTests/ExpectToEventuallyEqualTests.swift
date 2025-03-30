// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import ExpectToEventuallyEqual
import XCTest

@MainActor
final class ExpectToEventuallyEqualTests: XCTestCase, Sendable {
    func test_immediateMatch() async throws {
        try await expectToEventuallyEqual(actual: { "abc" }, expected: "abc")
    }

    func test_eventualMatch() async throws {
        let changeling = Changeling(beforeChange: "nope")

        try await expectToEventuallyEqual(
            actual: { changeling.tryAgain(returning: "eventually", after: 5) },
            expected: "eventually"
        )
    }

    func test_failure() async throws {
        let changeling = Changeling(beforeChange: "nope")
        let failSpy = FailSpy()

        try await expectToEventuallyEqual(
            actual: { changeling.tryAgain(returning: "never", after: 15) },
            expected: "eventually",
            timeout: 0.4,
            failure: failSpy
        )

        XCTAssertEqual(failSpy.callCount, 1, "fail call count")
        let message = try XCTUnwrap(failSpy.messages.first)
        let location = try XCTUnwrap(failSpy.locations.first)
        XCTAssertTrue(message.hasPrefix("Expected \"eventually\", but was \"never\" after "), message)
        XCTAssertTrue(message.hasSuffix(" tries, timing out after 0.4 seconds"), message)
        XCTAssertEqual("\(location.filePath)".hasSuffix("/ExpectToEventuallyEqualTests.swift"), true, "file")
        XCTAssertEqual(location.line, 27, "line")
    }
}

private final class Changeling<T> {
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
