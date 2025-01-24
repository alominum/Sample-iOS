
//
//  ImageDataRemoteCacheAdapter.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

struct ImageDataLoaderCacheAdapter: ImageDataLoader {
    let cache: ImageDataStore
    let loader: ImageDataLoader

    func loadImageData(from url: URL) async throws -> Data {
        let data = try await loader.loadImageData(from: url)
        await cache.save(data, for: url)
        return data
    }
}
