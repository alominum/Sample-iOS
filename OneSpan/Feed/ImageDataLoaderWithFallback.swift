//
//  ImageDataLoaderWithFallback.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

struct ImageDataLoaderWithFallback: ImageDataLoader {
    let primary: ImageDataLoader
    let secondary: ImageDataLoader

    func loadImageData(from url: URL) async throws -> Data {
        guard let data = try? await primary.loadImageData(from: url) else {
            let data = try await secondary.loadImageData(from: url)
            return data
        }
        return data
    }
}
