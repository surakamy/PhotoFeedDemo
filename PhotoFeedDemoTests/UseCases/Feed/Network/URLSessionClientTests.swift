//
//  URLSessionClientTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import XCTest
import PhotoFeedDemo


class MockURLSessionDataTask: HTTPClientTask {
    func resume() {}
    func cancel() {}
}

class MockClientSession: ClientSession {
    @discardableResult
    func data(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPClientTask {
        completionHandler(nil, nil, nil)
        return MockURLSessionDataTask()
    }
}

class URLSessionClientTests: XCTestCase {

    func test_client_firesHandler() {
        let mock = MockClientSession()
        let sut = URLSessionClient(session: mock)

        let endpoint = URL(string: "https://sample.com")!
        let request = URLRequest(url: endpoint)

        let expectation = self.expectation(description: "Handler")

        sut.dispatch(request) { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.01)
    }
}
