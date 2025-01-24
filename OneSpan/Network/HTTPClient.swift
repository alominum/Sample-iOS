//
//  HTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data,HTTPURLResponse)
}
