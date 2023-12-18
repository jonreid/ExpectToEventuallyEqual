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

func messageEventuallyEqualFailed<T>(
    expected: T,
    actual: T,
    tryCount: Int,
    timeout: TimeInterval
) -> String {
    "\(messageNotEqual(T.self, expected: expected, actual: actual)) after \(tryCount) tries, timing out after \(timeout) seconds"
}

func messageNotEqual<T>(_ type: T.Type, expected: T, actual: T) -> String {
    return "Expected \(describe(type, value: expected)), but was \(describe(type, value: actual))"
}

private func describe<T>(_ type: T.Type, value: T) -> String {
    let description = String(describing: value)
    if type != String.self {
        return description
    }
    return "\"\(description)\""
}
