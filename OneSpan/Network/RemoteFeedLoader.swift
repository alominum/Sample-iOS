//
//  RemoteFeedLoader.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//


import Foundation

final class RemoteFeedLoader: FeedLoader {

    let client: HTTPClient
    let url: URL

    enum Error: Swift.Error {
        case connectivity
        case invalidData
        case invalidResponse
    }

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success((let data, let response)):
                let mappedDogs = self.mapToDog(data, response: response)
                switch mappedDogs {
                    case .success(let dogs):
                        dogs.forEach(  fetchDogImageURLs(dog:) )

                    case.failure(let error):
                        completion(.failure(error))
                }

                completion(self.mapToDog(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private func fetchDogImageURLs(dog: Dog) {

        client.get(from: dog.imageUrlApi) {  [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success((let data, let response)):
                guard let imageUrl = try? self.mapToString(data, response: response).get() else {
                    return
                }
                print(imageUrl)
            case .failure:
                break
            }

        }

    }

    private func mapToDog(_ data: Data, response: HTTPURLResponse) -> FeedLoader.Result {
        do {
            let message = try FeedMapper<[String: [String]]>.decode(data, response)
            let dogs = message.map { Dog(breed: $0, subBreed: $1) }
            return .success(dogs)
        } catch {
            return .failure(error)
        }
    }

    private func mapToString(_ data: Data, response: HTTPURLResponse) -> Result<String, Error> {
        do {
            let string = try FeedMapper<String>.decode(data, response)
            return .success(string)
        } catch {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
    }
}
