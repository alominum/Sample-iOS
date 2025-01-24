//
//  DogLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

protocol FeedLoader {
    func load() async throws -> [Dog]
}
