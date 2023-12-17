@testable import ExpectToEventuallyEqual
import XCTest

final class ExpectToEventuallyEqualTests: XCTestCase {
    func test_immediateMatch() throws {
        try expectToEventuallyEqual(actual: { "abc" }, expected: "abc")
    }
    
    func test_eventualMatch() throws {
        try expectToEventuallyEqual(actual: {
            Changeling.tryAgain(returning: "eventually", after: 5)
        }, expected: "eventually")
    }
    
    func test_failureMessage() throws {
        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            issue.type == .assertionFailure && issue.compactDescription.contains("Expected eventually, but was")
        }
        
        try XCTExpectFailure("The correct value is never returned.",
                             options: options) {
            try expectToEventuallyEqual(actual: {
                Changeling.tryAgain(returning: "never", after: 15)
            }, expected: "eventually")
        }
    }
}

class Changeling {
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
