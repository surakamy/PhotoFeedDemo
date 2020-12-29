//
//  FeedComposerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedComposerTests: XCTestCase {
    func test_composer_constructsNecessaryObjects() throws {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = PicsumFeedLoader(client: client)

        let controller = FeedViewComposer.compose(feedLoader: loader, imageLoader: client, onSelect: { _ in })

        let interactor = try XCTUnwrap(controller.interactor as? FeedInteractor)
        let presenter = try XCTUnwrap(interactor.presenter as? FeedPresenter)

        XCTAssertNotNil(controller.onSelectFeedCard)
        XCTAssertNotNil(presenter.viewFeed)
        XCTAssertNotNil(presenter.viewRefresh)

        assertNoMemoryLeaks(presenter)
        assertNoMemoryLeaks(controller)
        assertNoMemoryLeaks(interactor)
        assertNoMemoryLeaks(client)
    }
}
