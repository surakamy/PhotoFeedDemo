//
//  FeedCardCellControllerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 21.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedCardPresentableView: XCTestCase {
    func test() {
        
    }
}

class FeedCardViewableInteractor: XCTestCase {

    func test_view_show_requestLoading() {
        let card = FeedCardModel(id: 0, author: "Test", source: nil)
        let interactor = SpyInteractor()
        let sut = FeedCardCellController(id: card.id, interactor: interactor, onSelect: { _ in })

        let cell = UICollectionViewCell(frame: .zero)
        sut.show(cell: cell)

        XCTAssertEqual(interactor.messages, ["requestLoading"])
    }

    func test_view_cancel_cancelsLoading() {
        let card = FeedCardModel(id: 0, author: "Test", source: nil)
        let interactor = SpyInteractor()
        let sut = FeedCardCellController(id: card.id, interactor: interactor, onSelect: { _ in })

        sut.cancel()

        XCTAssertEqual(interactor.messages, ["cancelLoading"])
    }

    func test_view_onSelect_callsHandler() {
        var handlerReceivedValue = -1
        let card = FeedCardModel(id: 100, author: "Test", source: nil)
        let interactor = SpyInteractor()
        let sut = FeedCardCellController(id: card.id, interactor: interactor, onSelect: { num in
            handlerReceivedValue = num
        })

        sut.select()

        XCTAssertEqual(handlerReceivedValue, 100)
    }
}


private class SpyInteractor: FeedCardInteractable {

    var messages: [String] = []

    func requestLoading() {
        messages += ["requestLoading"]
    }

    func cancelLoading() {
        messages += ["cancelLoading"]
    }
}
