//
//  Breed.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import Foundation

struct Dog: Hashable, Decodable {
    let id: UUID
    let breed: String
    let subBreed: [String]
    let imageUrlApi: URL
    var imageUrl: URL?

    init(id: UUID = UUID(), breed: String, subBreed: [String] = [], imageUrl: URL? = nil) {
        self.id = id
        self.breed = breed
        self.subBreed = subBreed
        self.imageUrlApi = URLRequest(url: URL(string: "https://dog.ceo/api/breed/\(breed)/images/random")!).url! // We have breed, so the Api will be valid all the times.
        self.imageUrl = imageUrl
    }

    mutating func setImageUrl(_ url: URL) {
        self.imageUrl = url
    }

}
