//
//  HTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data,HTTPURLResponse)
}
