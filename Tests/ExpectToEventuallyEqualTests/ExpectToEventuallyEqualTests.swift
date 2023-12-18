@testable import ExpectToEventuallyEqual
import XCTest

final class ExpectToEventuallyEqualTests: XCTestCase {
    func test_immediateMatch() throws {
        try expectToEventuallyEqual(actual: { "abc" }, expected: "abc")
    }
    
    func test_eventualMatch() throws {
        try expectToEventuallyEqual(
            actual: { Changeling.tryAgain(returning: "eventually", after: 5) },
            expected: "eventually"
        )
    }
    
    func test_failureMessage() throws {
        let failSpy = FailSpy()

        try expectToEventuallyEqual(
            actual: { Changeling.tryAgain(returning: "never", after: 15) },
            expected: "eventually",
            fail: failSpy.fail
        )

        XCTAssertEqual(failSpy.callCount, 1, "fail call count")
        XCTAssertTrue(failSpy.message.hasPrefix("Expected eventually, but was nope after "))
        XCTAssertTrue(failSpy.message.hasSuffix(" tries, timing out after 1.0 seconds"))
        XCTAssertEqual(failSpy.file.hasSuffix("/ExpectToEventuallyEqualTests.swift"), true, "file")
        XCTAssertEqual(failSpy.line, 19, "line")
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

private class Changeling {
    static var tries = 0
    
    static func tryAgain(returning: String, after: Int) -> String {
        if tries == after {
            tries = 0
            return returning
        }
        tries += 1
        
        return "nope"
    }
}
