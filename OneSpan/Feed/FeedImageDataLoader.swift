//
//  DogLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

//protocol FeedImageDataLoaderTask {
//    func cancel()
//}

protocol FeedImageDataLoader {
    func loadImageData(from url: URL) async throws -> Data
}
