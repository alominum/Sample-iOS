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
        guard let windowScene = (scene as? UIWindowScene),
              let endpint = ProcessInfo.processInfo.environment["ENDPOINT"],
              ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil,
              let endpointURL = URL(string: endpint) else { return }

        let window = UIWindow(windowScene: windowScene)

        let feedLoader = RemoteFeedLoader(url: endpointURL, client: URLSessionHTTPClient(session: URLSession.shared))

        let remoteImageLoader = RemoteImageDataLoader(client: URLSessionHTTPClient(session: URLSession.shared))

        let cache = InMemoryImageDataStore()
        let localImageLoader = CachedImageDataLoader(cache: cache)

        let remoteLoaderWithCache = ImageDataRemoteCacheComposition(cache: cache, loader: remoteImageLoader)

        let composedImageLoader = ImageDataLoaderWithFallback(primary: localImageLoader, secondary: remoteLoaderWithCache)

        let viewContrtoller = UIComposer.composedVC(titleText: "Dog Breeds", feedLoader: feedLoader, imageLoader: composedImageLoader, cache: cache)
        let navigation = UINavigationController(rootViewController: viewContrtoller)

        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()
    }
}

