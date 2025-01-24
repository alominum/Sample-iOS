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

    @IBAction func refresh() {
        loadingIndicator.startAnimating()
        loader?.load(completion: { result in
            switch result {
            case .success(let dogs):
                self.tableModel = dogs.map{ TableCellViewModel($0) }
//                print(dogs)
            case .failure(let error):
                print("Error loading: \(error)")
            }

            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        })
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
