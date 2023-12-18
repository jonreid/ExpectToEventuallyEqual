import XCTest

public func expectToEventuallyEqual<T: Equatable>(
    actual: () throws -> T,
    expected: T,
    timeout: TimeInterval = 1.0,
    file: StaticString = #filePath,
    line: UInt = #line,
    fail: (String, StaticString, UInt) -> Void = XCTFail
) throws {
    let runLoop = RunLoop.current
    let timeoutDate = Date(timeIntervalSinceNow: timeout)

    var lastActual = try actual()
    var tryCount = 0
    repeat {
        tryCount += 1
        if lastActual == expected {
            return
        }
        runLoop.run(until: Date(timeIntervalSinceNow: 0.01))
        lastActual = try actual()
    } while Date().compare(timeoutDate) == .orderedAscending

    fail(
        messageEventuallyEqualFailed(expected: expected, actual: lastActual, tryCount: tryCount, timeout: timeout),
        file,
        line
    )
}

private func messageEventuallyEqualFailed<T>(
    expected: T,
    actual: T,
    tryCount: Int,
    timeout: TimeInterval
) -> String {
    "\(messageNotEqual(expected: expected, actual: actual)) after \(tryCount) tries, timing out after \(timeout) seconds"
}

public func messageNotEqual<T>(expected: T, actual: T) -> String {
    "Expected \(String(describing: expected)), but was \(String(describing: actual))"
}
