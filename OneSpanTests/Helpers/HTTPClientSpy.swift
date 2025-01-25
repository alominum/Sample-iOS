//
//  HTTPClientSpy.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-25.
//

import Foundation
@testable import OneSpan

class HTTPClientSpy: HTTPClient {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    private var _stub: Stub?
    private var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }

    private let queue = DispatchQueue(label: "HTTPClientSpy.queue")

    private func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }

    private var requests: [(url: URL, response: (data: Data,response: HTTPURLResponse)?)] = []
    var requestedURLs: [URL] { requests.map { $0.url } }

    func stubResponse(withStatusCode code: Int, data: Data) {
        let response = HTTPURLResponse(
            url: URL(string: "any url")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        stub(data: data, response: response, error: nil)
    }

    func stubError(_ error: Error) {
        stub(data: nil, response: nil, error: error)
    }

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        queue.sync {
            requests.append((url: url, response: nil))
        }


        if let error = stub?.error {
            throw error
        }

        guard let response = stub?.response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        guard let data = stub?.data,
              let response = stub?.response as? HTTPURLResponse
        else {
            throw URLError(.badServerResponse)
        }

        return (data, response)
    }
}
