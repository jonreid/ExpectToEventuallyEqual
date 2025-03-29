// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import ExpectToEventuallyEqual
import Testing
import UIKit

@MainActor
@Suite("TableViewController tests - Swift Testing")
struct TableViewControllerTests_SwiftTesting {
    private let sut: TableViewController
    private let tableDataSource: (any UITableViewDataSource)

    init() throws {
        let book1 = SearchResult(trackName: "book 1", artistName: "author 1")
        let book2 = SearchResult(trackName: "book 2", artistName: "Jon Reid")
        let fakeSearchProvider = FakeSearchProvider(searchResults: book1, book2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
        sut.viewModel = ViewModel(fakeSearchProvider)
        sut.loadViewIfNeeded()
        tableDataSource = try #require(sut.tableView.dataSource)
    }

    @Test("Number of rows")
    func numberOfRows() async throws {
        try await expectToEventuallyEqual(
            actual: { tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
            expected: 2
        )
    }

    @Test("Second row shows book title")
    func secondRowShowsBookTitle() async throws {
        try await expectToEventuallyEqual(
            actual: { cellForRow(1).textLabel?.text ?? "" },
            expected: "book 2"
        )
    }

    @Test("FAILURE DEMONSTRATION: Second row shows book author")
    func FAILURE_DEMONSTRATION_secondRowShowsBookAuthor() async throws {
        try await expectToEventuallyEqual(
            actual: { cellForRow(1).detailTextLabel?.text ?? "" },
            expected: "Steven Baker"
        )
    }

    private func cellForRow(_ row: Int) -> UITableViewCell {
        let indexPath = IndexPath(row: row, section: 0)
        return tableDataSource.tableView(sut.tableView, cellForRowAt: indexPath)
    }
}
