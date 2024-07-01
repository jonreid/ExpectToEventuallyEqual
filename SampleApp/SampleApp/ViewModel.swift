// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

actor ViewModel {
    private let searchAPI: SearchProviding

    init(_ searchAPI: SearchProviding) {
        self.searchAPI = searchAPI
    }

    func load() async -> [DisplayResult] {
        guard let response = try? await searchAPI.searchForBooks(term: "historicism") else {
            return [.error]
        }
        let results = response.results.map { $0.toDisplayResult }
        if results.isEmpty {
            return [.noMatch]
        }
        return results
    }
}

extension SearchResult {
    var toDisplayResult: DisplayResult {
        .book(title: trackName, author: artistName)
    }
}

enum DisplayResult {
    case book(title: String, author: String)
    case error
    case loading
    case noMatch
}

extension DisplayResult {
    var text: String {
        switch self {
        case let .book(title, _):
            return title
        case .error:
            return "An error occurred"
        case .loading:
            return "Loading…"
        case .noMatch:
            return "No match"
        }
    }

    var detailText: String {
        switch self {
        case let .book(_, author):
            return author
        default:
            return ""
        }
    }
}
