//
//  FeedTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 16.12.2020.
//

import XCTest
import PhotoFeedDemo

class PicsumFeedLoaderTests: XCTestCase {


    func test_loader_requestsFirstPage() {
        let mock = MockHTTPClient()
        let sut = PicsumFeedLoader(client: mock)

        sut.load(page: 1, completion: { _ in })

        XCTAssertTrue(mock.messages.count == 1)
        XCTAssertEqual(mock.urls[0], URL(string: "https://picsum.photos/v2/list?page=1&limit=21")!)
    }

    func test_loader_requestsFirstAndSecondPages() {
        let mock = MockHTTPClient()
        let sut = PicsumFeedLoader(client: mock)

        sut.load(page: 1, completion: { _ in })
        sut.load(page: 2, completion: { _ in })

        XCTAssertTrue(mock.messages.count == 2)
        XCTAssertEqual(mock.urls[0], URL(string: "https://picsum.photos/v2/list?page=1&limit=21")!)
        XCTAssertEqual(mock.urls[1], URL(string: "https://picsum.photos/v2/list?page=2&limit=21")!)
    }

    func test_loader_response_WhenSucceed() throws {
        let mock = MockHTTPClient()
        let sut = PicsumFeedLoader(client: mock)

        let expectation = self.expectation(description: "Feed Loader result")
        var receivedImages: [JSONImage] = []

        sut.load(page: 1, completion: { response in
            expectation.fulfill()

            if case let Result.success(items) = response {
                receivedImages = items
            } else {
                XCTFail("Failed with \(response)")
            }
        })

        let received = """
        [{"id":"0","author":"Alejandro Escamilla","width":5616,"height":3744,"url":"https://unsplash.com/photos/yC-Yzbqy7PY","download_url":"https://picsum.photos/id/0/5616/3744"},{"id":"1","author":"Alejandro Escamilla","width":5616,"height":3744,"url":"https://unsplash.com/photos/LNRyGwIJr5c","download_url":"https://picsum.photos/id/1/5616/3744"}]
        """.data(using: .utf8)!

        let expectedImages = [
            JSONImage(id: "0", author: "Alejandro Escamilla", width: 5616, height: 3744, url: "https://unsplash.com/photos/yC-Yzbqy7PY", download_url: "https://picsum.photos/id/0/5616/3744"),
            JSONImage(id: "1", author: "Alejandro Escamilla", width: 5616, height: 3744, url: "https://unsplash.com/photos/LNRyGwIJr5c", download_url: "https://picsum.photos/id/1/5616/3744"),
        ]

        try mock.completes(with: 200, data: received)

        waitForExpectations(timeout: 0.01)
        XCTAssertEqual(receivedImages, expectedImages)
    }

    func test_loader_response_whenFailed() throws {
        let mock = MockHTTPClient()
        let sut = PicsumFeedLoader(client: mock)

        let expectation = self.expectation(description: "Feed Loader result")
        var receivedError: RemoteFeedError? = nil

        sut.load(page: 1, completion: { response in
            expectation.fulfill()

            if case let Result.failure(error) = response {
                receivedError = error
            } else {
                XCTFail("Failed with \(response)")
            }
        })
        let error = NSError(domain: "ANY", code: -1, userInfo: [NSLocalizedDescriptionKey: "Any error"])

        try mock.completes(with: error)

        waitForExpectations(timeout: 0.01)
        XCTAssertEqual(receivedError, RemoteFeedError.connectivity)
    }

}
