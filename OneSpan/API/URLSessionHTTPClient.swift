//
//  URLSessionHTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {

//    private struct TaskWrapper: HTTPClientTask {
//        let wrapped: Task<(Data, HTTPURLResponse), any Error>
//
//        func cancel() {
//            wrapped.cancel()
//        }
//    }

    private var session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response."])
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "Unexpected status code: \(httpResponse.statusCode)"
            ])
        }

        return (data, httpResponse)
    }

}
