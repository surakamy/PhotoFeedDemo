//
//  SUIFeedViewComposerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 27.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class SUIFeedViewComposerTests: XCTestCase {
    func test_composer_constructsNecessaryObjects() throws {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = PicsumFeedLoader(client: client)

        let store = SUIFeedViewComposer.compose(feedLoader: loader, imageLoader: client, onSelect: { _ in })


        let interactor = try XCTUnwrap(store.interactor as? FeedInteractor)
        let presenter = try XCTUnwrap(interactor.presenter as? FeedPresenter)


        XCTAssertNotNil(store.onSelectFeedCard)
        XCTAssertNotNil(presenter.viewFeed)

        assertNoMemoryLeaks(store)
        assertNoMemoryLeaks(presenter)
        assertNoMemoryLeaks(interactor)
        assertNoMemoryLeaks(client)
    }
}
