//
//  RemoteFeedImageDataLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//


import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    func loadImageData(from url: URL) async throws -> Data {
        let (data, response ) = try await client.get(from: url)
        guard response.statusCode == 200 && !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
