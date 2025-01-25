//
//  OneSpanTests.swift
//  OneSpanTests
//
//  Created by Nima Nassehi on 2025-01-24.
//

import XCTest
@testable import OneSpan

//class HTTPClientSpy2: HTTPClient {
//
//    var requestedURLs: [URL] = []
//
//    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
//        requestedURLs.append(url)
//        return (Data(), HTTPURLResponse())
//    }
//}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_performsGETRequestWithURL() async throws {
        let sut = makeSUT()

        let (data, _) = try! await sut.get(from: anyURL)

        XCTAssertNotNil(data)
    }


    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionHTTPClient(session: session)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }



}
