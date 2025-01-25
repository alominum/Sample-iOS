//
//  RefreshController.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

final class RefreshController {
    var actionable: Actionable?
    var loadingView: Animatable?
    private let feedLoader: FeedLoader

    var onRefresh: (([Dog]) -> Void)?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func setActiors(loadingView: Animatable, actionable: Actionable) {
        self.actionable = actionable
        self.loadingView = loadingView
        let refreshAction = UIAction(title: "Refresh") { (action) in
            self.refresh()
        }
        self.actionable?.addAction(refreshAction, for: .touchUpInside)
    }

    func refresh() {
        loadingView?.startAnimating()

        Task {
            do {
                let dogs = try await feedLoader.load()
                await MainActor.run {
                    onRefresh?(dogs)
                    loadingView?.stopAnimating()
                }
            } catch {
                print(error)
                await MainActor.run {
                    loadingView?.stopAnimating()
                }
            }
        }
    }

}
