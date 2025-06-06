//
//  RemoteImageDataLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

final class RemoteImageDataLoader: ImageDataLoader {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    func loadImageData(from url: URL) async throws -> Data {
        let (data, response) = try await client.get(from: url)
        guard response.statusCode == 200 && !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
