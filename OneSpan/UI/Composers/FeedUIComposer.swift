//
//  FeedUIComposer.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

final class UIComposer {
    private init() {}

    static func composedVC(titleText: String, feedLoader: FeedLoader, imageLoader: ImageDataLoader, cache: ImageDataStore) -> MainViewController {
        makeMainViewController(titleText: titleText, feedLoader: feedLoader, imageLoader: imageLoader, cache: cache)
    }

    private static func makeMainViewController(titleText: String, feedLoader: FeedLoader, imageLoader: ImageDataLoader, cache: ImageDataStore) -> MainViewController {
        let refreshController = RefreshController(feedLoader: feedLoader)

        let bundle = Bundle(for: MainViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "MainViewController") { coder in
            MainViewController(coder: coder, refreshController: refreshController)
        }
        controller.title = titleText

        refreshController.onRefresh = { [weak controller] dogs in
            Task {
                await cache.reset()
            }
            controller?.tableModel = dogs.map{ TableCellViewModel($0) }.map{ CellController(model: $0, imageLoader: imageLoader) }
        }

        return controller
    }
}
