@testable import ExpectToEventuallyEqual
import XCTest

@MainActor
final class ExpectToEventuallyEqualTests: XCTestCase {
    func test_immediateMatch() throws {
        try expectToEventuallyEqual(actual: { "abc" }, expected: "abc")
    }
}
