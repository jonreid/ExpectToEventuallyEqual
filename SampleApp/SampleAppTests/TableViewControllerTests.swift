@testable import SampleApp
import ExpectToEventuallyEqual
import XCTest

class TableViewControllerTests: XCTestCase {
    private var sut: TableViewController!
    private var tableDataSource: UITableViewDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let fakeSearchProvider = FakeSearchProvider()
        fakeSearchProvider.stubSuccess(book1, book2)
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

    func test_numberOfRows() throws {
        try expectToEventuallyEqual(
            actual: { tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
            expected: 2
        )
    }

    func test_secondRowShowsBookTitle() throws {
        try expectToEventuallyEqual(
            actual: { cellForRow(1).textLabel?.text ?? "" },
            expected: "book 2"
        )
    }

    func test_secondRowShowsBookAuthor_demonstratingFailure() throws {
        try expectToEventuallyEqual(
            actual: { cellForRow(1).detailTextLabel?.text ?? "" },
            expected: "Steven Baker"
        )
    }

    func cellForRow(_ row: Int) -> UITableViewCell {
        let indexPath = IndexPath(row: row, section: 0)
        return tableDataSource.tableView(sut.tableView, cellForRowAt: indexPath)
    }
}

let book1 = SearchResult(trackName: "book 1", artistName: "author 1")
let book2 = SearchResult(trackName: "book 2", artistName: "Jon Reid")