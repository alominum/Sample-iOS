//
//  Helpers.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "posible Memory leak", file: file, line: line)
        }
    }

    var anyURL: URL {
        URL(string: "Any-url.com")!
    }

    enum TestError: Error, Equatable {
        case capturedError
        case cancelled
        case invalidResponse
    }

    var anyHTTPURLResponse: HTTPURLResponse {
        HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    var anyData: Data {
        Data("any data".utf8)
    }
}
