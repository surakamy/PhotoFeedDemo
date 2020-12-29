//
//  FeedViewStoreTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 27.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedViewStoreTests: XCTestCase {

    func test_callsInteractorImplementation() throws {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewStore(interactor: interactor)

        sut.load()
        sut.reload()

        XCTAssertEqual(interactor.messages, [.load, .reload])
    }

    func test_storeOnScrolledAnyButLastCard_doesNotLoadsNewPage() throws {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewStore(interactor: interactor)
        sut.cards = makeCards()
        let firstCard = try XCTUnwrap(sut.cards.first)
        
        sut.scrolled(to: firstCard)

        XCTAssertEqual(interactor.messages, [])
    }

    func test_storeOnScrolledToLastCard_loadsNewPage() throws {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewStore(interactor: interactor)
        sut.cards = makeCards()
        let lastCard = try XCTUnwrap(sut.cards.last)

        sut.scrolled(to: lastCard)

        XCTAssertEqual(interactor.messages, [.load])
    }


    func test_storeOnReload_replacesCards() {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewStore(interactor: interactor)
        let model = FeedViewModel([JSONImage(id: "100", author: "Test", width: 0, height: 0, url: "", download_url: "")])
        let cardStore = FeedCardStore(id: 100, interactor: nil, onSelect: nil)

        XCTAssertEqual(sut.cards, [])
        sut.displayReload(model)
        XCTAssertEqual(sut.cards, [cardStore])
        sut.displayReload(model)
        XCTAssertEqual(sut.cards, [cardStore])
    }

    func test_storeOnReload_appendsCards() {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewStore(interactor: interactor)
        let model100 = FeedViewModel([JSONImage(id: "100", author: "Test", width: 0, height: 0, url: "", download_url: "")])
        let model200 = FeedViewModel([JSONImage(id: "200", author: "Test", width: 0, height: 0, url: "", download_url: "")])
        let cardStore100 = FeedCardStore(id: 100, interactor: nil, onSelect: nil)
        let cardStore200 = FeedCardStore(id: 200, interactor: nil, onSelect: nil)

        XCTAssertEqual(sut.cards, [])
        sut.displayAppend(model100)
        XCTAssertEqual(sut.cards, [cardStore100])
        sut.displayAppend(model200)
        XCTAssertEqual(sut.cards, [cardStore100, cardStore200])
    }

    private func makeCards() -> [FeedCardStore] {
        (1...10).map { FeedCardStore(id: $0, interactor: nil, onSelect: nil)}
    }
}
