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
        let windowScene = (scene as? UIWindowScene)
        let endpint = "https://dog.ceo/api/breeds/list/all" //ProcessInfo.processInfo.environment["ENDPOINT"]!
        let endpointURL = URL(string: endpint)! // else { return }

        let window = UIWindow(windowScene: windowScene!)

        let urlSessionClient = URLSessionHTTPClient(session: URLSession.shared)
        let feedLoader = RemoteFeedLoader(url: endpointURL, client: urlSessionClient)

        let remoteImageLoader = RemoteImageDataLoader(client: urlSessionClient).retry(3)

        let cache = InMemoryImageDataStore()
        let localImageLoader = CachedImageDataLoader(cache: cache)

        let remoteLoaderWithCache = ImageDataLoaderCacheComposition(cache: cache, loader: remoteImageLoader)

        let composedImageLoader = ImageDataLoaderWithFallback(primary: localImageLoader, secondary: remoteLoaderWithCache)

        let viewContrtoller = UIComposer.composedVC(titleText: "Dog Breeds", feedLoader: feedLoader, imageLoader: composedImageLoader, cache: cache)
        let navigation = UINavigationController(rootViewController: viewContrtoller)

        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()
    }
}


