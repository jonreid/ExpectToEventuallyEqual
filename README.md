[![Build](https://github.com/jonreid/ExpectToEventuallyEqual/actions/workflows/build.yml/badge.svg)](https://github.com/jonreid/ExpectToEventuallyEqual/actions/workflows/build.yml)

<!-- toc -->
## Contents

  * [Checking Markdown Update](#checking-markdown-update)<!-- endToc -->

## Checking Markdown Update

<!-- snippet: task -->
<a id='snippet-task'></a>
```swift
Task {
    await viewModel.load()
    self.tableView.reloadData()
}
```
<sup><a href='/SampleApp/SampleApp/TableViewController.swift#L10-L15' title='Snippet source file'>snippet source</a> | <a href='#snippet-task' title='Start of snippet'>anchor</a></sup>
<!-- endSnippet -->

<!-- snippet: number-of-rows -->
<a id='snippet-number-of-rows'></a>
```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.result.count
}
```
<sup><a href='/SampleApp/SampleApp/TableViewController.swift#L18-L22' title='Snippet source file'>snippet source</a> | <a href='#snippet-number-of-rows' title='Start of snippet'>anchor</a></sup>
<!-- endSnippet -->

<!-- snippet: test-example -->
<a id='snippet-test-example'></a>
```swift
try expectToEventuallyEqual(
    actual: { tableDataSource.tableView(sut.tableView, numberOfRowsInSection: 0) },
    expected: 2
)
```
<sup><a href='/SampleApp/SampleAppTests/TableViewControllerTests.swift#L27-L32' title='Snippet source file'>snippet source</a> | <a href='#snippet-test-example' title='Start of snippet'>anchor</a></sup>
<!-- endSnippet -->
