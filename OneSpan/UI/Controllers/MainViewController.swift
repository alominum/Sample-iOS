//
//  TableViewController.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

protocol ViewControllerDelegate {
    func didRequestRefresh()
}

final class RefreshController: NSObject {

}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButtonContainer: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var feedTask: Task<Void, Never>?
    private var imageTasks: [IndexPath: Task<Void, Never>] = [:]

    var delegate: ViewControllerDelegate?
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?

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

        feedLoader = RemoteFeedLoader(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, client: URLSessionHTTPClient(session: URLSession.shared))
        imageLoader = RemoteFeedImageDataLoader(client: URLSessionHTTPClient(session: URLSession.shared))

        setupUI()

        refresh()
    }

    private func setupUI() {
        refreshButtonContainer.addShaddow()
        loadingIndicator.hidesWhenStopped = true

    }

    @IBAction func refresh() {
        loadingIndicator.startAnimating()

        feedTask = Task {
            do {
                let dogs = try await feedLoader?.load() ?? []
                await MainActor.run {
                    self.tableModel = dogs.map{ TableCellViewModel($0) }
                    loadingIndicator.stopAnimating()
                }
            } catch {
                print(error)
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                }
            }
        }
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
                    let imageData = try await self.imageLoader?.loadImageData(from: imageUrl)
                    let image = imageData.map(UIImage.init) ?? nil
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
                    _ = try await self.imageLoader?.loadImageData(from: url)
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
