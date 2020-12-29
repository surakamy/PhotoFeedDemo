//
//  MockHTTPClient.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import Foundation
import PhotoFeedDemo
import XCTest

final class MockHTTPClient: HTTPClient {
    enum MockErrors: Error {
        case tooFewRequestsFired
    }
    typealias Response = HTTPClient.Response

    class Task: HTTPClientTask {
        var isCancelled: Bool = false
        func resume() {}
        func cancel() { isCancelled = true }
    }

    var messages: [(request: URLRequest, handler:(Response) -> Void)] = []
    var urls: [URL] { messages.compactMap { $0.request.url } }

    @discardableResult
    func dispatch(_ request: URLRequest, then handler: @escaping (Response) -> Void) -> HTTPClientTask {
        let dispathed = (request: request, handler: handler)
        messages.append(dispathed)
        return Task()
    }

    func completes(with statusCode: Int, data: Data, at index: Int = 0) throws {
        if index >= urls.count {
            throw MockErrors.tooFewRequestsFired
        }
        let http = HTTPURLResponse(
            url: urls[index],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!

        messages[index].handler(
            .success((data, http))
        )
    }

    func completes(with error: Error, at index: Int = 0) throws {
        if index >= urls.count {
            throw MockErrors.tooFewRequestsFired
        }
        messages[index].handler(
            .failure(error)
        )
    }
}
