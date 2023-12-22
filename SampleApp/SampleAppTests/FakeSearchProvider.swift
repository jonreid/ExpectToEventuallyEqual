// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import XCTest

class FakeSearchProvider: SearchProviding {
    private let file: StaticString
    private let line: UInt
    private var stubbedResponse: SearchResponse?

    init(file: StaticString = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    func stubSuccess(_ searchResults: SearchResult...) {
        stubbedResponse = SearchResponse(results: searchResults)
    }

    func searchForBooks(term: String) async throws -> SearchResponse {
        if let stubbedResponse {
            return stubbedResponse
        }
        XCTFail("FakeSearchProvider needs stubSuccess", file: file, line: line)
        return SearchResponse(results: [])
    }
}
