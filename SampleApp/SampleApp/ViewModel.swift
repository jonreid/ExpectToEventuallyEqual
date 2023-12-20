class ViewModel {
    private let searchAPI: SearchProviding
    private(set) var result: [DisplayResult] = [.loading]

    init(_ searchAPI: SearchProviding) {
        self.searchAPI = searchAPI
    }

    func load() async {
        guard let response = try? await searchAPI.searchForBooks(term: "historicism") else {
            result = [.error]
            return
        }
        result = response.results.map { $0.toDisplayResult }
        if result.isEmpty {
            result = [.noMatch]
        }
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
            return "An error occcurred"
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
