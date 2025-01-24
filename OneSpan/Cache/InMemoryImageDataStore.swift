//
//  InMemoryImageDataStore.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

actor InMemoryImageDataStore: ImageDataStore {
    enum CacheError: Error {
        case notFound
    }

    private var store: [URL: Data] = [:]
    
    func save(_ data: Data, for url: URL) {
        print("\(url) ---------> 📦")
        store[url] = data
    }

    func retrieve(for url: URL) throws -> Data {
        guard let data = store[url] else {
            throw CacheError.notFound
        }
        print("📤 =========> \(url)")
        return data
    }

    func reset() async {
        print("\(store.count) image removed from cache.")
        store.removeAll()
    }
}
