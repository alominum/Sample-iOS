//
//  OneSpanTests.swift
//  OneSpanTests
//
//  Created by Nima Nassehi on 2025-01-24.
//
//
//import XCTest
//@testable import OneSpan
//
//class HTTPClientSpy: HTTPClient {
//
//    var requestedURLs: [URL] = []
//
//    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
//        requestedURLs.append(url)
//        return (Data(), HTTPURLResponse())
//    }
//}
//
//
//final class RemoteFeedLoaderTests: XCTestCase {
//
//    func test_init_DoesNotSendRequest() {
//        let (_, client) = makeSUT()
//
//        XCTAssertTrue(client.requestedURLs.isEmpty)
//    }
//
//    func test_load_requestsDataFromURL() {
//        let url = anyURL
//        let (sut, client) = makeSUT(url: url)
//
////        let dogs = sut.load()
//
//        XCTAssertEqual(client.requestedURLs, [url])
//    }
//
//    // MARK: - Helpers
//    private func makeSUT(url: URL = URL(string: "a-url")!,
//                         file: StaticString = #filePath,
//                         line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
//        let client = HTTPClientSpy()
//        let sut = RemoteFeedLoader(url: url, client: client)
//        trackMemoryLeak(sut)
//        trackMemoryLeak(client)
//        return (sut, client)
//    }
//
//}
