//
//  OneSpanTests.swift
//  OneSpanTests
//
//  Created by Nima Nassehi on 2025-01-24.
//

import XCTest
@testable import OneSpan

final class URLSessionHTTPClientTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }

    func test_getFromURL_FailsOnRequestError() async throws {
        let error = TestError.capturedError
        let sut = makeSUT()
        URLProtocolStub.stub(data: nil, response: nil, error: error)

        do {
            _ = try await sut.get(from: anyURL)
            XCTFail("It supposed to throw an error but did not!")
        } catch (let receivedError) {
            XCTAssertNotNil(receivedError)
        }
    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async throws {
        let data = anyData
        let response = anyHTTPURLResponse
        let sut = makeSUT()
        URLProtocolStub.stub(data: data, response: response, error: nil)

        let receivedValues = try await sut.get(from: anyURL)

        XCTAssertEqual(receivedValues.0, data)
        XCTAssertEqual(receivedValues.1.statusCode, response.statusCode)
        XCTAssertEqual(receivedValues.1.url, response.url)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() async throws {
        let sut = makeSUT()
        let response = anyHTTPURLResponse
        let emptyData = Data()
        URLProtocolStub.stub(data: nil, response: response, error: nil)

        let receivedValues = try await sut.get(from: anyURL)

        XCTAssertEqual(receivedValues.0, emptyData)
        XCTAssertEqual(receivedValues.1.statusCode, response.statusCode)
        XCTAssertEqual(receivedValues.1.url, response.url)
    }

    func test_cancelGetFromURLTask_cancelsURLRequest() async {
        let sut = makeSUT()

        let task = Task {
            do {
                _ = try await sut.get(from: anyURL)
                XCTFail("Expected to throw cancellation error, but succeeded instead.")
            } catch {
                let urlError = error as? URLError
                XCTAssertTrue(urlError?.code == .cancelled, "Expected cancellation, got \(error) instead.")
            }
        }

        task.cancel()

        await task.value
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
