//
//  FeedItemComposerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 29.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class SUIFeedItemComposerTests: XCTestCase {
    func test_composer_hasComposeAllObjects() throws {
        let loader = MockHTTPClient()
        let sut = SUIFeedItemComposer.compose(id: 100, loader: loader, onDismiss: {

        })

        let interactor = try XCTUnwrap(sut.interactor as? FeedItemInteractor)
        let presentor = try XCTUnwrap(interactor.presentor as? FeedItemPresenter)
        let view = try XCTUnwrap(presentor.view)

        XCTAssertEqual(interactor.id, 100)
        XCTAssertNotNil(view)
        XCTAssertNotNil(sut.interactor)
        XCTAssertNotNil(sut.onDismiss)
    }

    func test_composer_hasNoRetainCycles() throws {
        let loader = MockHTTPClient()
        let sut = SUIFeedItemComposer.compose(id: 100, loader: loader, onDismiss: {

        })
        assertNoMemoryLeaks(sut)
    }
}
