// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import Foundation

@MainActor
public func expectToEventuallyEqual<T: Equatable>(
    actual: () async throws -> T,
    expected: T,
    timeout: TimeInterval = 1.0,
    fileID: String = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    fail: (String, SourceLocation) -> Void = FailureReporter.fail
) async throws {
    let timeoutDate = Date(timeIntervalSinceNow: timeout)

    var lastActual = try await actual()
    var tryCount = 0
    repeat {
        tryCount += 1
        if lastActual == expected {
            return
        }
        try await Task.sleep(nanoseconds: 10_000_000)
        lastActual = try await actual()
    } while Date().compare(timeoutDate) == .orderedAscending

    fail(
        "\(describeMismatch(T.self, expected: expected, actual: lastActual)) after \(tryCount) tries, timing out after \(timeout) seconds",
        SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column)
    )
}
