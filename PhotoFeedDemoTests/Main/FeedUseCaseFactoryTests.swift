//
//  FeedUseCaseFactoryTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedUseCaseFactoryTests: XCTestCase {

    func test_factory_constructsEveryNecessaryComponet() throws {
        let sut = UIKitFactory.makeFeed(Router(navController: UINavigationController()))

        let feedController = try XCTUnwrap(sut as? FeedViewController)
        let interactor = try XCTUnwrap(feedController.interactor as? FeedInteractor)
        let presenter = try XCTUnwrap(interactor.presenter as? FeedPresenter)

        XCTAssertNotNil(feedController.refreshController)
        XCTAssertNotNil(feedController.imageLoader)
        XCTAssertNotNil(interactor.source)
        XCTAssertNotNil(presenter.viewFeed)
        XCTAssertNotNil(presenter.viewRefresh)
    }

    func test_factory_hasNoRetainCycles() throws {
        let sut = UIKitFactory.makeFeed(Router(navController: UINavigationController()))

        let feedController = try XCTUnwrap(sut as? FeedViewController)
        let interactor = try XCTUnwrap(feedController.interactor as? FeedInteractor)
        let presenter = try XCTUnwrap(interactor.presenter as? FeedPresenter)

        assertNoMemoryLeaks(feedController)
        assertNoMemoryLeaks(feedController.refreshController)
        assertNoMemoryLeaks(interactor)
        assertNoMemoryLeaks(presenter)
    }
}
