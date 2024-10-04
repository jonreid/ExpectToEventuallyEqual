// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import XCTest

final class FakeSearchProvider: SearchProviding {
    private let stubbedResponse: SearchResponse

    init(searchResults: SearchResult...) {
        stubbedResponse = SearchResponse(results: searchResults)
    }

    func searchForBooks(term: String) async throws -> SearchResponse {
        return stubbedResponse
    }
}
