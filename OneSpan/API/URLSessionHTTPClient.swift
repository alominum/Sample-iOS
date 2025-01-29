//
//  URLSessionHTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {

    enum URLSessionHTTPClientError: Error {
        case invalidResponse
        case statusCodeNot200
    }

    private var session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLSessionHTTPClientError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw URLSessionHTTPClientError.statusCodeNot200
        }

        return (data, httpResponse)
    }

}
