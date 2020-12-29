//
//  FeedCardComposerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedCardComposerTests: XCTestCase {

    func test_composer_constructsNecessaryObjects() throws {
        let model = FeedCardModel(id: 0, author: "Test", source: nil)
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let controller = FeedCardViewComposer.compose(card: model, imageLoader: client, onSelect: { _ in })

        let interactor = try XCTUnwrap(controller.interactor as? FeedCardInteractor)
        let presenter = try XCTUnwrap(interactor.presenter as? FeedCardPresenter)

        XCTAssertNotNil(interactor.presenter)
        XCTAssertNotNil(presenter.view)
    }

    func test_composer_hasNoMemoryLeaks() throws {
        let model = FeedCardModel(id: 0, author: "Test", source: nil)
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let cell = UICollectionViewCell(frame: .zero)
        let controller = FeedCardViewComposer.compose(card: model, imageLoader: client, onSelect: { _ in })
        controller.show(cell: cell)

        let interactor = try XCTUnwrap(controller.interactor as? FeedCardInteractor)

        assertNoMemoryLeaks(interactor)
        assertNoMemoryLeaks(controller)
        assertNoMemoryLeaks(cell)
        assertNoMemoryLeaks(client)
    }

}
