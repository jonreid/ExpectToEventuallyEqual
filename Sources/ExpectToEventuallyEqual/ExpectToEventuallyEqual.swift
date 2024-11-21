// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import XCTest

public func expectToEventuallyEqual<T: Equatable>(
    actual: () throws -> T,
    expected: T,
    timeout: TimeInterval = 1.0,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    fail: (String, SourceLocation) -> Void = { XCTFail($0, file: $1.filePath, line: $1.line) }
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
        "\(describeMismatch(T.self, expected: expected, actual: lastActual)) after \(tryCount) tries, timing out after \(timeout) seconds",
        SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}

public struct SourceLocation {
    public let fileID: String
    public let filePath: StaticString
    public let line: UInt
    public let column: UInt
}
