// ExpectToEventuallyEqual by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

class TableViewController: UITableViewController {
    lazy var viewModel = ViewModel(SearchProvider())
    private let cellReuseIdentifier = "book"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BookCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // begin-snippet: task
        Task {
            await viewModel.load()
            self.tableView.reloadData()
        }
        // end-snippet
    }

    // begin-snippet: number-of-rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.result.count
    }
    // end-snippet

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        guard indexPath.row < viewModel.result.count else { return cell }
        let result = viewModel.result[indexPath.row]
        cell.textLabel?.text = result.text
        cell.detailTextLabel?.text = result.detailText
        return cell
    }
}

class BookCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
