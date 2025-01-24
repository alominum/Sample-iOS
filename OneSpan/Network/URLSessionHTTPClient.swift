//
//  URLSessionHTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }

    private var session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public typealias Result = HTTPClient.Result

    private struct UnExpectedError: Error {}

    public func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, reseponse, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let reseponse = reseponse as? HTTPURLResponse {
                    return (data, reseponse)
                } else {
                    throw UnExpectedError()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
