//
//  FeedInteractorTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedInteractorTests: XCTestCase {

    func test_interactor_load_withSuccess_presentsItems() {
        let page1 = makeLoaderSuccessItems()
        let (sut, loader, presenter) = makeSUT()
 
        sut.load()
        loader.loadCompletes(with: .success(page1))

        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])
    }

    func test_interactor_loadTwice_reloadsAndAppendsItems() throws {
        let page1 = makeLoaderSuccessItems(with: 1...5)
        let page2 = makeLoaderSuccessItems(with: 5...10)
        let (sut, loader, presenter) = makeSUT()

        sut.load()
        loader.loadCompletes(with: .success(page1))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])

        sut.load()
        loader.loadCompletes(with: .success(page2))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1), .appending(page2)])
    }

    func test_interactor_reloadAndThenLoad_called() {
        let page1 = makeLoaderSuccessItems(with: 1...5)
        let page2 = makeLoaderSuccessItems(with: 5...10)
        let (sut, loader, presenter) = makeSUT()

        sut.reload()
        loader.loadCompletes(with: .success(page1))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])

        sut.load()
        loader.loadCompletes(with: .success(page2))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1), .appending(page2)])
    }


    func test_interactor_loadTwiceFast_shouldSkipSecondLoad() {
        let page1 = makeLoaderSuccessItems(with: 1...5)
        let page2 = makeLoaderSuccessItems(with: 5...10)
        let (sut, loader, presenter) = makeSUT()

        sut.reload()
        sut.load()

        loader.loadCompletes(with: .success(page1))
        loader.loadCompletes(with: .success(page2))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])
    }

    func test_interactor_load_withSuccess_updatesNextPage() {
        let page1 = makeLoaderSuccessItems()
        let (sut, loader, _) = makeSUT()

        XCTAssertEqual(sut.nextPage, 1, "Precondition")

        sut.load()
        loader.loadCompletes(with: .success(page1))

        XCTAssertEqual(sut.nextPage, 2)
    }

    func test_interactor_load_withFailure_doesNotUpdateNextPage() {
        let (sut, loader, _) = makeSUT()

        XCTAssertEqual(sut.nextPage, 1, "Precondition")

        sut.load()
        loader.loadCompletes(with: .failure(.connectivity))

        XCTAssertEqual(sut.nextPage, 1)
    }

    func test_interactor_load_withFailure_doesNotPresentItemsSecondTime() {
        let page1 = makeLoaderSuccessItems()
        let (sut, loader, presenter) = makeSUT()

        sut.load()
        loader.loadCompletes(with: .success(page1))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])

        sut.load()
        loader.loadCompletes(with: .failure(.connectivity))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1), .error(.connectivity)])
    }

    func test_interactor_reload_withSuccess_replacesItemsAndResetsNextPage() {
        let page1 = makeLoaderSuccessItems()
        let (sut, loader, presenter) = makeSUT()

        sut.load()
        loader.loadCompletes(with: .success(page1))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])
        XCTAssertEqual(sut.nextPage, 2, "Precondition")

        sut.reload()
        loader.loadCompletes(with: .success(page1))

        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1), .progress(true), .progress(false), .reloading(page1)])
        XCTAssertEqual(sut.nextPage, 2)
    }

    func test_interactor_reload_withFailure_doesNotReplacesItemsAndDoesNotResetNextPage() {
        let page1 = makeLoaderSuccessItems()
        let (sut, loader, presenter) = makeSUT()

        sut.load()
        loader.loadCompletes(with: .success(page1))
        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1)])
        XCTAssertEqual(sut.nextPage, 2, "Precondition")

        sut.reload()
        loader.loadCompletes(with: .failure(.connectivity))

        XCTAssertEqual(presenter.messages, [.progress(true), .progress(false), .reloading(page1), .progress(true), .progress(false), .error(.connectivity)])
        XCTAssertEqual(sut.nextPage, 2)
    }

    // MARK: - Helpers
    private func makeSUT() -> (FeedInteractor, MockFeedLoader, SpyFeedPresenter) {
        let loader = MockFeedLoader()
        let presenter = SpyFeedPresenter()
        let sut = FeedInteractor(source: loader)
        sut.presenter = presenter
        return (sut, loader, presenter)
    }

    private func makeLoaderSuccessItems(with range: ClosedRange<Int> = 1...5) -> [JSONImage] {
        return range.map {
            JSONImage(id: "\($0)", author: "Author \($0)", width: 400, height: 400, url: "http://url", download_url: "http://url")
        }
    }
}


extension JSONImage: CustomStringConvertible {
    public var description: String { "Pic \(id)" }
}


final class MockFeedLoader: RemoteFeedLoader {
    private struct SpyTask: HTTPClientTask {
        func resume() {}
        func cancel() {}
    }

    typealias Result = RemoteFeedLoader.Result

    var completionHandlers: [(Result) -> Void] = []

    @discardableResult
    func load(page: Int, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        completionHandlers.append(completion)
        return SpyTask()
    }

    func loadCompletes(with result: Result, at index: Int = 0) {
        guard index < completionHandlers.count else {
            return
        }
        let handler = completionHandlers[index]
        handler(result)
        completionHandlers.remove(at: index)
    }
}

final class SpyFeedPresenter: FeedPresentable {
    enum Message: Equatable, CustomStringConvertible {
        var description: String {
            switch self {
            case let .progress(active):
            return "loading[\(active)]"
            case let .appending(images):
                return "appending[\(images)]"
            case let .reloading(images):
                return "reloading[\(images)]"
            case let .error(error):
                return "error[\(error)]"
            }
        }
        case progress(Bool)
        case appending([JSONImage])
        case reloading([JSONImage])
        case error(RemoteFeedError)
    }

    var messages: [Message] = []

    func renderLoading(_ active: Bool) {
        messages.append(.progress(active))
    }

    func renderReload(_ images: [JSONImage]) {
        messages.append(.reloading(images))
    }

    func renderAppend(_ images: [JSONImage]) {
        messages.append(.appending(images))
    }

    func renderError(_ error: RemoteFeedError) {
        messages.append(.error(error))
    }
}
