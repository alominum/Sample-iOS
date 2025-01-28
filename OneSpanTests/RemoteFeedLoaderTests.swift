//
//  OneSpanTests.swift
//  OneSpanTests
//
//  Created by Nima Nassehi on 2025-01-25.
//
//
import XCTest
@testable import OneSpan

final class RemoteFeedLoaderTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }

    func test_init_doesNotRequestData() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() async {
        let url = anyURL
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() async {
        let url = anyURL
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load()
        _ = try? await sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() async {
        let (sut, client) = makeSUT()
        client.stubError(TestError.capturedError)

        do {
            _ = try await sut.load()
            XCTFail("Expected get error!")
        } catch {
            XCTAssertEqual(error as? XCTestCase.TestError, TestError.capturedError)
        }
    }

    func test_load_deliversErrorOnNon200HttpResponse() async {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        for code in samples {
            do {
                client.stubResponse(withStatusCode: code, data: anyData)
                _ = try await sut.load()
                XCTFail("Expected get error but passed!")

            } catch {
                XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
            }
        }
    }

    func test_load_deliversErrorOn200HttpResponseWithInvalidJSON() async {
        let (sut, client) = makeSUT()
        client.stubResponse(withStatusCode: 200, data: anyData)

        do {
            _ = try await sut.load()
            XCTFail("Expected get error but passed!")
        } catch {
            XCTAssertEqual(error as? RemoteFeedLoader.Error, RemoteFeedLoader.Error.invalidData)
        }
    }

    func test_load_deliversNoItemOn200HttpResponseWithEmptyJSON() async throws {
        let (sut, client) = makeSUT()
        client.stubResponse(withStatusCode: 200, data: emptyDogFeed())

        let dogs = try await sut.load()
        XCTAssertEqual(dogs, [])
    }

    func test_load_deliversItemsOn200HTTPResponseAndValidJson() async throws {
        let (sut, client) = makeSUT()
        client.stubResponse(withStatusCode: 200, data: twoDogsFeed())

        let dogs = try await sut.load()
        XCTAssert(dogs.count == 2)
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "a-url")!,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackMemoryLeak(sut)
        trackMemoryLeak(client)
        return (sut, client)
    }

    private func emptyDogFeed() -> Data {
        let json = ["message": [:],
                    "status": "success"] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func twoDogsFeed() -> Data {
        let json = ["message":
                        ["affenpinscher": [],
                         "buhund": [
                            "norwegian"]
                        ],
                    "status": "success"] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
