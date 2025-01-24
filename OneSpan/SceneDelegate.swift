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

        let feedLoader = RemoteFeedLoader(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, client: URLSessionHTTPClient(session: URLSession.shared))

        let remoteImageLoader = RemoteImageDataLoader(client: URLSessionHTTPClient(session: URLSession.shared))

        let cache = InMemoryImageDataStore()
        let localImageLoader = CachedImageDataLoader(cache: cache)

        let remoteWithCacheLoader = ImageDataLoaderCacheAdapter(cache: cache, loader: remoteImageLoader)

        let composedImageLoader = ImageDataLoaderWithFallback(primary: localImageLoader, secondary: remoteWithCacheLoader)

        let viewContrtoller = UIComposer.composedVC(titleText: "Dog Breeds", feedLoader: feedLoader, imageLoader: composedImageLoader)
        let navigation = UINavigationController(rootViewController: viewContrtoller)

        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()
    }
}

