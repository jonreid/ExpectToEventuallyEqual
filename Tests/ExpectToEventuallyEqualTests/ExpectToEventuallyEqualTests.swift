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
            fail: failSpy.fail
        )

        XCTAssertEqual(failSpy.callCount, 1, "fail call count")
        XCTAssertTrue(failSpy.message.hasPrefix("Expected \"eventually\", but was \"never\" after "), failSpy.message)
        XCTAssertTrue(failSpy.message.hasSuffix(" tries, timing out after 1.0 seconds"), failSpy.message)
        XCTAssertEqual(failSpy.file.hasSuffix("/ExpectToEventuallyEqualTests.swift"), true, "file")
        XCTAssertEqual(failSpy.line, 22, "line")
    }

    func test_message_forString() throws {
        let message = messageEventuallyEqualFailed(expected: "abc", actual: "def", tryCount: 99, timeout: 0.1)
        XCTAssertEqual(message, "Expected \"abc\", but was \"def\" after 99 tries, timing out after 0.1 seconds")
    }

    func test_message_forInt() throws {
        let message = messageEventuallyEqualFailed(expected: 0, actual: 1, tryCount: 99, timeout: 0.1)
        XCTAssertEqual(message, "Expected 0, but was 1 after 99 tries, timing out after 0.1 seconds")
    }
}

private class FailSpy {
    var callCount = 0
    var message = ""
    var file: String = ""
    var line: UInt = 0

    func fail(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        callCount += 1
        self.message = message
        self.file = file.description
        self.line = line
    }
}

private class Changeling<T> {
    private let beforeChange: T
    private var tries = 0

    init(beforeChange: T) {
        self.beforeChange = beforeChange
    }

    func tryAgain(returning: T, after: Int) -> T {
        if tries >= after {
            return returning
        }
        tries += 1
        return beforeChange
    }
}
