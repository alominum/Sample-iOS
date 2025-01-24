//
//  FeedItemMapper.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//

import Foundation

class FeedMapper<T: Decodable> {

    private struct BreedsResponse: Decodable {
        let message: T
        let status: String
    }

    static func decode(_ data: Data, _ response: HTTPURLResponse) throws -> T {
        guard response.statusCode == 200 , let root = try? JSONDecoder().decode(BreedsResponse.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.message
    }
}
