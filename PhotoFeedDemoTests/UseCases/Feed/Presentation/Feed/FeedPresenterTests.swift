//
//  FeedPresenterTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedPresenterTests: XCTestCase {

    func test_renderReload_callsDisplayReload() {
        let view = SpyFeedView()
        let sut = FeedPresenter()
        sut.viewFeed = view

        let items = makeLoaderSuccessItems()
        sut.renderReload(items)

        let expected = FeedViewModel(items)
        XCTAssertEqual(view.messages, [.reload(expected)])
    }

    func test_renderAppend_callsDisplayAppend() {
        let view = SpyFeedView()
        let sut = FeedPresenter()
        sut.viewFeed = view

        let items = makeLoaderSuccessItems()
        sut.renderAppend(items)

        let expected = FeedViewModel(items)
        XCTAssertEqual(view.messages, [.append(expected)])
    }

    func test_renderError_callsDisplayError() {
        let view = SpyFeedView()
        let sut = FeedPresenter()
        sut.viewFeed = view

        sut.renderError(.connectivity)

        XCTAssertEqual(view.messages, [.error])
    }

    private func makeLoaderSuccessItems(with range: ClosedRange<Int> = 1...5) -> [JSONImage] {
        return range.map {
            JSONImage(id: "\($0)", author: "Author \($0)", width: 400, height: 400, url: "http://url", download_url: "http://url")
        }
    }
}

private final class SpyFeedView: FeedView {
    enum Message: Equatable, CustomStringConvertible {
        var description: String {
            switch self {
            case let .loading(active):
            return "loading[\(active)]"
            case let .reload(model):
                return "reload[\(model)]"
            case let .append(model):
                return "append[\(model)]"
            case .error:
                return "error"
            }
        }
        case loading(Bool)
        case reload(FeedViewModel)
        case append(FeedViewModel)
        case error
    }

    var messages: [Message] = []

    func displayLoading(_ active: Bool) {
        messages.append(.loading(active))
    }

    func displayReload(_ viewModel: FeedViewModel) {
        messages.append(.reload(viewModel))
    }

    func displayAppend(_ viewModel: FeedViewModel) {
        messages.append(.append(viewModel))
    }

    func displayError() {
        messages.append(.error)
    }
}

extension FeedCardCellController: CustomStringConvertible {
    public var description: String {
        "[\(self.id)]"
    }

}
