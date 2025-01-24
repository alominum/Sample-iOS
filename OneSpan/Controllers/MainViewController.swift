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

class MainViewController: UIViewController {
    private var activeRefreshTask: Task<Void, Never>?

    var delegate: ViewControllerDelegate?
    private var loader: FeedLoader?
    private var tableModel: [TableCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButtonContainer: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        loader = RemoteFeedLoader(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, client: URLSessionHTTPClient(session: URLSession.shared))

        setupUI()

        refresh()
    }

    private func setupUI() {
        refreshButtonContainer.addShaddow()
        loadingIndicator.hidesWhenStopped = true

    }

    func text() async {
        print("REFRESHING")
    }

    @IBAction func refresh() {
        loadingIndicator.startAnimating()

        activeRefreshTask = Task {
            do {
                let dogs = try await loader?.load() ?? []
                await MainActor.run {
                    self.tableModel = dogs.map{ TableCellViewModel($0) }
                    loadingIndicator.stopAnimating()
                    print(self.tableModel)
                }
            } catch {
                print(error)
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                }
            }
        }
//        delegate?.didRequestRefresh()
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogTableCell", for: indexPath) as! DogTableCell
        cell.configure(with: tableModel[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate {

}
