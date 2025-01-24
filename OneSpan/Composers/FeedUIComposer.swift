//
//  FeedUIComposer.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

final class UIComposer {
    private init() {}

    static func composedVC(titleText: String, feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> MainViewController {
        let controller = makeMainViewController(titleText: titleText, feedLoader: feedLoader, imageLoader: imageLoader)
        return controller
    }

    private static func makeMainViewController(titleText: String, feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "MainViewController") { coder in
            MainViewController(coder: coder, titleText: titleText, feedLoader: feedLoader, imageLoader: imageLoader)
        }
        return controller
    }
}
