//
//  HTTPClient.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL) async throws -> (Data,HTTPURLResponse)
}
