// ExpectToEventuallyEqual by Jon Reid (https://qualitycoding.org) and Steven Baker (https://stevenrbaker.com)
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import SampleApp
import ExpectToEventuallyEqual
import Testing
import Nimble
import UIKit

struct TableViewControllerTests {
    private var sut: TableViewController
    private var tableDataSource: (any UITableViewDataSource)

    @MainActor
    init() {
        let fakeSearchProvider = FakeSearchProvider(searchResults: book1, book2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
        sut.viewModel = ViewModel(fakeSearchProvider)
        sut.loadViewIfNeeded()
        tableDataSource = sut.tableView.dataSource!
    }

    @MainActor
    @Test
    func numberOfRows() throws {
        try expectToEventuallyEqual(
            actual: { tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
            expected: 2
        )
        print("++++ end of test")
    }

    @MainActor
    @Test
    func numberOfRowsNimbleSync() async throws {
        // this fails (it uses basically the same logic as ExpectToEventuallyEqual)
        expect(tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0)).toEventually(equal(2))
        print("++++ end of test")
    }

    @MainActor
    @Test
    func numberOfRowsNimbleAsync() async throws {
        // this passes (it uses Task.yield instead of the runloop)
        await expect(tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0)).toEventually(equal(2))
        print("++++ end of test")
    }

    @MainActor
    @Test
    func secondRowShowsBookTitle() throws {
        try expectToEventuallyEqual(
            actual: { cellForRow(1).textLabel?.text ?? "" },
            expected: "book 2"
        )
    }

    @MainActor
    @Test
    func secondRowShowsBookAuthor_FAILURE_DEMONSTRATION() throws {
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
