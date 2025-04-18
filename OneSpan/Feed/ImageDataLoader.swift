//
//  DogLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

protocol ImageDataLoader {
    func loadImageData(from url: URL) async throws -> Data
}

extension ImageDataLoader {
    func fallback(_ fallback:ImageDataLoader) -> ImageDataLoader {
        ImageDataLoaderWithFallback(primary: self, secondary: fallback)
    }

    func retry(_ retryCount: UInt) -> ImageDataLoader {
        var loader: ImageDataLoader = self
        for _ in 0..<retryCount {
            loader = loader.fallback(self)
        }
        return loader
    }
}
