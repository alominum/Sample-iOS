//
//  FeedUIComposer.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//

import UIKit

final class UIComposer {
    private init() {}

    static func composedVC(title: String) -> MainViewController {
        let controller = makeMainViewController(title: title)
        return controller
    }

    private static func makeMainViewController(title: String) -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! MainViewController
        controller.title = title
        return controller
    }
}
