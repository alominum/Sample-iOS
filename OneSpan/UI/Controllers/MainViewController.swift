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

    private var cellControllers = [IndexPath: DogCellController]()

    private var refreshController: RefreshButtonController?
    private let imageLoader: FeedImageDataLoader

    init?(coder: NSCoder, titleText: String, feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.imageLoader = imageLoader
        self.refreshController = RefreshButtonController(feedLoader: feedLoader)
        super.init(coder: coder)
        self.title = titleText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(titleText:detailText:) instead.")
    }

    private var tableModel: [TableCellViewModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.dataSource = self

        setupUI()

        refreshController?.setElements(loadingView: loadingIndicator, button: refreshButton)
        refreshController?.onRefresh = { [weak self] dogs in
            self?.tableModel = dogs.map{ TableCellViewModel($0) }
        }

        refreshController?.refresh()
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
        removeCellController(for: indexPath)
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
        indexPaths.forEach(removeCellController)
    }

    //MARK: - Helpers

    fileprivate func cellController(for indexPath: IndexPath) -> DogCellController {
        let model = tableModel[indexPath.row]
        let cellController = DogCellController(model: model, imageLoader: imageLoader)
        cellControllers[indexPath] = cellController
        return cellController
    }

    private func removeCellController(for indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }

}
