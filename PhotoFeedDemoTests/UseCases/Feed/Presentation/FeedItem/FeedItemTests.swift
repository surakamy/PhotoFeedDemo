//
//  FeedItemTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 23.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedItemViewComposerTests: XCTestCase {
    func test_composer_linksObjects() throws {
        let client = MockHTTPClient()
        let controller = FeedItemViewComposer.compose(id: 100, loader: client, onDismiss: {})

        let view = try XCTUnwrap(controller as? FeedItemViewController)
        let interactor = try XCTUnwrap(view.interactor as? FeedItemInteractor)
        let presenter = try XCTUnwrap(interactor.presentor as? FeedItemPresenter)

        XCTAssertNotNil(presenter.view)
        XCTAssertNotNil(view.onDismiss)

        assertNoMemoryLeaks(client)
        assertNoMemoryLeaks(controller)
    }
}

class FeedItemControllerTests: XCTestCase {
    func test_() throws {
        let interactor = SpyFeedItemInteractor()
        let sut = FeedItemViewController()
        sut.interactor = interactor

        sut.loadViewIfNeeded()

        XCTAssertEqual(interactor.messages, ["load"])
    }
}

class FeedItemPresenterViewTests: XCTestCase {
    func test_presenter_displaysImage() throws {
        let view = SpyFeedItemView()
        let sut = FeedItemPresenter(view: view)

        let image = makeImage()
        sut.render(image: image)

        XCTAssertEqual(view.messages, [image])
    }
}

class FeedItemInteractorPresentorTests: XCTestCase {

    func test_interactor_generatesEndpoint() {
        let client = MockHTTPClient()
        let sut = FeedItemInteractor(id: 100, downloader: client, presentor: nil)
        XCTAssertEqual(sut.makeEndPoint(), URL(string: "https://picsum.photos/id/100/400/400")!)
    }

    func test_loads_onSuccess_rendersImage() throws {
        let client = MockHTTPClient()
        let presenter = SpyFeedItemPresenter()
        let sut = FeedItemInteractor(id: 100, downloader: client, presentor: presenter)

        sut.load()

        let receivedData = makeImage()
        try client.completes(with: 200, data: receivedData)

        XCTAssertEqual(presenter.messages, [receivedData])
    }

    func test_loads_onFailure_rendersNothing() throws {
        let client = MockHTTPClient()
        let presenter = SpyFeedItemPresenter()
        let sut = FeedItemInteractor(id: 100, downloader: client, presentor: presenter)

        sut.load()

        try client.completes(with: HTTPClientError.connectivity)

        XCTAssertEqual(presenter.messages, [])
    }
}

final class SpyFeedItemInteractor: FeedItemInteractable {
    var messages: [String] = []

    func load() {
        messages.append("load")
    }
}

final class SpyFeedItemView: FeedItemViewable {
    var messages: [Data] = []

    func display(image: Data) {
        messages.append(image)
    }
}

final class SpyFeedItemPresenter: FeedItemPresentable {
    var messages: [Data] = []
    func render(image: Data) {
        messages.append(image)
    }
}

private func makeImage() -> Data {
    Data(1...10)
}
