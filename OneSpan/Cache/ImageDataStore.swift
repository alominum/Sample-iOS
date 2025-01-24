//
//  d.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

protocol ImageDataStore {
    func save(_ data: Data, for url: URL) async
    func retrieve(for url: URL) async throws -> Data
    func reset() async
}
