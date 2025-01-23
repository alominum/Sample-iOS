//
//  TableViewController.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var refreshButtonContainer: UIView!
    @IBOutlet var refreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        setupUI()

    }

    private func setupUI() {
        refreshButtonContainer.addShaddow()
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "DogTableCell", for: indexPath)
    }
}

extension MainViewController: UITableViewDelegate {

}
