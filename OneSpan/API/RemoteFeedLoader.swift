//
//  RemoteFeedLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//


import Foundation

final class RemoteFeedLoader: FeedLoader {

    let client: HTTPClient
    let url: URL

    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() async throws -> [Dog] {
        let (data, response ) = try await client.get(from: url)

        guard response.statusCode == 200 && !data.isEmpty else {
            throw Error.invalidData
        }

        let mappedDogs = try mapToDog(data, response: response)

        // Fetching Breed imsge URL for each dog
        return try await withThrowingTaskGroup(of: Dog.self) { [weak self] group in
            guard let self = self else { return mappedDogs }

            for dog in mappedDogs {
                group.addTask {
                    return try await self.fetchAndUpdateDogImageURLs(dog: dog)
                }
            }

            var updatedDogs: [Dog] = []
            for try await dog in group {
                updatedDogs.append(dog)
            }

            return updatedDogs
        }
    }

    private func fetchAndUpdateDogImageURLs(dog: Dog) async throws -> Dog {
        let (data, response ) = try await client.get(from: dog.imageUrlApi)
        if let imageUrl = try? self.mapToString(data, response: response) {
            return Dog(id: dog.id, breed: dog.breed, subBreed: dog.subBreed, imageUrl: URL(string: imageUrl)!)
        }
        return dog
    }


    // MARK: - Helpers
    private func mapToDog(_ data: Data, response: HTTPURLResponse) throws -> [Dog] {

        let message = try FeedMapper<[String: [String]]>.decode(data, response)
        let dogs = message.map { Dog(breed: $0, subBreed: $1) }
        return dogs

    }

    private func mapToString(_ data: Data, response: HTTPURLResponse) throws -> String {
        let string = try FeedMapper<String>.decode(data, response)
        return string
    }
}
