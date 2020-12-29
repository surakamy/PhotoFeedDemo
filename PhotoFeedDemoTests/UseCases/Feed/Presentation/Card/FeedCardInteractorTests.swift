//
//  FeedCardInteractor.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 20.12.2020.
//

import XCTest
@testable import PhotoFeedDemo


class FeedCardInteractorTests: XCTestCase {

    func test_interactor_requestLoading_keepsThatRequest() throws {
        let (sut, _, _) = makeSUT()

        XCTAssertNil(sut.request, "Precondition")
        sut.requestLoading()
        XCTAssertNotNil(sut.request)
    }

    func test_interactor_cancelLoading_cancelsActiveRequest() throws {
        let (sut, _, _) = makeSUT()

        let task = MockHTTPClient.Task()
        sut.request = task
        sut.cancelLoading()
        XCTAssertNil(sut.request)
        XCTAssertTrue(task.isCancelled)
    }


    func test_interactor_requestLoading_completesWithSuccess_setsImage() throws {
        let (sut, loader, _) = makeSUT()
        sut.requestLoading()

        let expectedImage = makeImage()
        try loader.completes(with: 200, data: expectedImage)

        XCTAssertEqual(sut.image, expectedImage)
    }

    func test_interactor_requestLoading_completesWithFailure_doesNotSetsImage() throws {
        let (sut, loader, _) = makeSUT()

        sut.requestLoading()
        try loader.completes(with: HTTPClientError.connectivity)
        XCTAssertNil(sut.image)
    }

    private func makeSUT() -> (FeedCardInteractor, MockHTTPClient, URL) {
        let loader = MockHTTPClient()
        let interactor = FeedCardInteractor(card: makeModel(), loader: loader)
        return (interactor, loader, makeURL())
    }

}

class FeedCardInteractorPresenterTests: XCTestCase {

    func test_interactor_requestDownload_dataIsStored_rendersImage() {
        let (sut, presenter, _, _) = makeSUT()
        sut.image = makeImage()
        sut.requestLoading()
        XCTAssertEqual(presenter.messages, ["renderLoading[false]", "renderImage"])
    }

    func test_interactor_requestDownload_dataIsNotStored_rendersDownloading() {
        let (sut, presenter, _, _) = makeSUT()
        sut.image = nil
        sut.requestLoading()
        XCTAssertEqual(presenter.messages, ["renderLoading[true]"])
    }

    func test_interactor_requestLoading_completesWithSuccess_rendersImageToPresenter() throws {
        let (sut, presenter, loader, _) = makeSUT()
        sut.requestLoading()
        XCTAssertEqual(presenter.messages, ["renderLoading[true]"])

        let expectedImage = makeImage()
        try loader.completes(with: 200, data: expectedImage)

        XCTAssertEqual(presenter.messages, ["renderLoading[true]", "renderImage"])
    }

    private func makeSUT() -> (FeedCardInteractor, SpyPresenter, MockHTTPClient, URL) {
        let presenter = SpyPresenter()
        let loader = MockHTTPClient()
        let interactor = FeedCardInteractor(card: makeModel(), loader: loader)
        interactor.presenter = presenter
        return (interactor, presenter, loader, makeURL())
    }

}

private class SpyPresenter: FeedCardPresentable {
    var view: FeedCardViewable? = nil

    var messages: [String] = []

    func renderLoading(_ active: Bool) {
        messages += ["renderLoading[\(active)]"]
    }

    func renderImage(_ data: Data) {
        messages += ["renderImage"]
    }
}

private func makeImage() -> Data {
    Data(1...2)
}

private func makeURL() -> URL {
    URL(string: "http://\(UUID()).com")!
}

private func makeModel() ->FeedCardModel {
    FeedCardModel(id: 1, author: "Test", source: makeURL())
}
