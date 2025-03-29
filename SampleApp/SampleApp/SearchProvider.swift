// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import Foundation

protocol SearchProviding: Sendable {
    func searchForBooks(term: String) async throws -> SearchResponse
}

struct SearchResponse: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let trackName: String
    let artistName: String
}

enum SearchError: Error {
    case errorResponse(HTTPURLResponse)
    case internalError
}

struct SearchProvider: SearchProviding {
    func searchForBooks(term: String) async throws -> SearchResponse {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?media=ebook&term=\(encodedTerm)")
        else {
            throw SearchError.internalError
        }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        let httpResponse = response as! HTTPURLResponse
        guard httpResponse.statusCode == 200 else {
            throw SearchError.errorResponse(httpResponse)
        }
        return try JSONDecoder().decode(SearchResponse.self, from: data)
    }
}
