// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import ExpectToEventuallyEqual
import XCTest

@MainActor
final class TableViewControllerTests: XCTestCase, Sendable {
    private var sut: TableViewController!
    private var tableDataSource: (any UITableViewDataSource)!

    override func setUp() async throws {
        try await super.setUp()
        let fakeSearchProvider = FakeSearchProvider(searchResults: book1, book2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
        sut.viewModel = ViewModel(fakeSearchProvider)
        sut.loadViewIfNeeded()
        tableDataSource = try XCTUnwrap(sut.tableView.dataSource)
    }

    override func tearDown() async throws {
        sut = nil
        tableDataSource = nil
        try await super.tearDown()
    }

    func test_numberOfRows() async throws {
        // begin-snippet: test-example
        try await expectToEventuallyEqual(
            actual: { @MainActor in tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
            expected: 2
        )
        // end-snippet
    }

    func test_secondRowShowsBookTitle() async throws {
        try await expectToEventuallyEqual(
            actual: { @MainActor in cellForRow(1).textLabel?.text ?? "" },
            expected: "book 2"
        )
    }

    func test_secondRowShowsBookAuthor_FAILURE_DEMONSTRATION() async throws {
        XCTExpectFailure("Demonstrate failure message")
        try await expectToEventuallyEqual(
            actual: { @MainActor in cellForRow(1).detailTextLabel?.text ?? "" },
            expected: "Steven Baker"
        )
    }

    @MainActor
    func cellForRow(_ row: Int) -> UITableViewCell {
        let indexPath = IndexPath(row: row, section: 0)
        return tableDataSource.tableView(sut.tableView, cellForRowAt: indexPath)
    }
}

let book1 = SearchResult(trackName: "book 1", artistName: "author 1")
let book2 = SearchResult(trackName: "book 2", artistName: "Jon Reid")
