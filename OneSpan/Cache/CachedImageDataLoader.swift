//
//  CachedImageDataLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

final class CachedImageDataLoader: ImageDataLoader {
    private let cache: ImageDataStore

    init(cache: ImageDataStore) {
        self.cache = cache
    }

    func loadImageData(from url: URL) async throws -> Data {
         try await cache.retrieve(for: url)
    }
}
