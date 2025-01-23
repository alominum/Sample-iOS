//
//  Breed.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

public struct Dog: Hashable {
    public let id: UUID
    public let breed: String
    public let subBreed: [String]
    public let imageUrl: URL?

    public init(id: UUID = UUID(), breed: String, subBreed: [String] = [], imageUrl: URL?) {
        self.id = id
        self.breed = breed
        self.subBreed = subBreed
        self.imageUrl = imageUrl
    }
}
