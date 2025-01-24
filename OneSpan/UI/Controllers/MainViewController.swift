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

    private var imageTasks: [IndexPath: Task<Void, Never>] = [:]

    private let feedLoader: FeedLoader
    private var refreshController: RefreshButtonController?
    private let imageLoader: FeedImageDataLoader

    init?(coder: NSCoder, titleText: String, feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
        super.init(coder: coder)
        self.title = titleText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(titleText:detailText:) instead.")
    }

    private var tableModel: [TableCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        tableView.dataSource = self

        setupUI()

        refreshController = RefreshButtonController(feedLoader: feedLoader, loadingView: loadingIndicator, button: refreshButton)

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
        let model = tableModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogTableCell", for: indexPath) as! DogTableCell

        cell.breedName.text = model.title.capitalized
        cell.subBreedNames.text = model.breedsDescription
        cell.dogImageView.image = nil
        cell.retryButton.isHidden = true
        cell.dogImageContainer.isLoading = true

        let loadImage = { [weak self] in
            guard let self = self, let imageUrl = model.imageURL else { return }


            self.imageTasks[indexPath] = Task {
                do {
                    let imageData = try await self.imageLoader.loadImageData(from: imageUrl)
                    let image = UIImage(data: imageData)
                    await MainActor.run {
                        cell.fadeIn(image)
                        cell.retryButton.isHidden = (image != nil)
                        cell.dogImageContainer.isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        cell.dogImageContainer.isLoading = false
                    }
                }
            }

        }

        cell.onRetry = loadImage

        loadImage()

        return cell
    }
}

// MARK: - Prefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let model = tableModel[indexPath.row]
            imageTasks[indexPath] = Task {
                do {
                    guard let url = model.imageURL else { return }
                    _ = try await self.imageLoader.loadImageData(from: url)
                } catch {

                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            if let task = imageTasks[indexPath] {
                task.cancel()
                imageTasks[indexPath] = nil
            }
        }
    }

}
