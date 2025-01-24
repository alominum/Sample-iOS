//
//  TableViewController.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButtonContainer: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var tableModel: [DogCellController] = [] {
        didSet {
            self.tableView.reloadData()
            oldValue.count > 0 ? self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) : ()
        }
    }

    private let refreshController: RefreshController

    init?(coder: NSCoder, refreshController: RefreshController) {
        self.refreshController = refreshController
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(titleText:detailText:) instead.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.dataSource = self

        setupUI()

        refreshController.setElements(loadingView: loadingIndicator, button: refreshButton)
        refreshController.refresh()
    }

    private func setupUI() {
        refreshButtonContainer.addShaddow()
        loadingIndicator.hidesWhenStopped = true
    }

}

// MARK: - Datasource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(for: indexPath).view(for: tableView, at: indexPath)
    }
}

// MARK: - Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelImageLoading(for: indexPath)
    }
}

// MARK: - Prefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(for: indexPath).preload()
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelImageLoading)
    }

    //MARK: - Helpers
    fileprivate func cellController(for indexPath: IndexPath) -> DogCellController {
        tableModel[indexPath.row]
    }

    private func cancelImageLoading(for indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoading()
    }

}
