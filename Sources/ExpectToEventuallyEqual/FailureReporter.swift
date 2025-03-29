// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import XCTest

#if canImport(Testing)
import Testing
#endif

public enum FailureReporter {
    public static func fail(message: String, location: SourceLocation) {
        if isRunningSwiftTest() {
#if canImport(Testing)
            Issue.record(Testing.Comment(rawValue: message), sourceLocation: location.toTestingSourceLocation())
#endif
            return
        }

        XCTFail(message, file: location.filePath, line: location.line)
    }

    private static func isRunningSwiftTest() -> Bool {
#if canImport(Testing)
        Test.current != nil
#else
        false
#endif
    }
}

public struct SourceLocation {
    public let fileID: String
    public let filePath: StaticString
    public let line: UInt
    public let column: UInt

#if canImport(Testing)
    public func toTestingSourceLocation() -> Testing.SourceLocation {
        Testing.SourceLocation(fileID: fileID, filePath: "\(filePath)", line: Int(line), column: Int(column))
    }
#endif
}
