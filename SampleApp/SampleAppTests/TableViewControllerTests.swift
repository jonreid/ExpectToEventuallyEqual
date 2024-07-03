// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import ExpectToEventuallyEqual
import XCTest

class TableViewControllerTests: XCTestCase {
    private var sut: TableViewController!
    private var tableDataSource: (any UITableViewDataSource)!

    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        let fakeSearchProvider = FakeSearchProvider(searchResults: book1, book2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
        sut.viewModel = ViewModel(fakeSearchProvider)
        sut.loadViewIfNeeded()
        tableDataSource = try XCTUnwrap(sut.tableView.dataSource)
    }

    override func tearDownWithError() throws {
        sut = nil
        tableDataSource = nil
        try super.tearDownWithError()
    }

    @MainActor
    func test_numberOfRows() throws {
        // begin-snippet: test-example
        try expectToEventuallyEqual(
            actual: { tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
            expected: 2
        )
        // end-snippet
    }

    @MainActor
    func test_secondRowShowsBookTitle() throws {
        try expectToEventuallyEqual(
            actual: { cellForRow(1).textLabel?.text ?? "" },
            expected: "book 2"
        )
    }

    @MainActor
    func test_secondRowShowsBookAuthor_demonstratingFailure() throws {
        XCTExpectFailure("Demonstrate failure message")
        try expectToEventuallyEqual(
            actual: { cellForRow(1).detailTextLabel?.text ?? "" },
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
