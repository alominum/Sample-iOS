//
//  DogLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

protocol FeedLoader {
    typealias Result = Swift.Result<[Dog], Error>

    func load(completion: @escaping (Result) -> Void)
}
