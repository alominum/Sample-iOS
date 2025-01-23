//
//  SceneDelegate.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let viewContrtoller = UIComposer.composedVC()
        let navigation = UINavigationController(rootViewController: viewContrtoller)

        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()
    }
}

