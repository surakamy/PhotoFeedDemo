//
//  FeedViewControllerTests.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import XCTest
@testable import PhotoFeedDemo

class FeedViewInteractorTests: XCTestCase {

    func test_view_reloadsOnViewDidLoad() {
        let (sut, interactor) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(interactor.messages, [.reload])
    }

    func test_view_scrollToBottom_callsInteractor() {
        let (sut, interactor) = makeSUT()

        sut.loadViewIfNeeded()

        sut.simulatePagingRequest()

        XCTAssertEqual(interactor.messages, [.reload, .load])
    }

    func test_view_scrolToBottomTwice_callsInteractor() {
        let (sut, interactor) = makeSUT()

        sut.loadViewIfNeeded()

        sut.simulatePagingRequest()

        XCTAssertEqual(interactor.messages, [.reload, .load])

        sut.simulatePagingRequest()

        XCTAssertEqual(interactor.messages, [.reload, .load, .load])
    }

    private func makeSUT() -> (FeedViewController, SpyFeedInteractor) {
        let interactor = SpyFeedInteractor()
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.interactor = interactor
        return (sut, interactor)
    }
}

class FeedViewControllerTests: XCTestCase {

    func test_diffableDatasource_assignedToCollectionView() throws {
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.loadViewIfNeeded()

        let datasource = try XCTUnwrap(sut.collectionView.dataSource)
        XCTAssertEqual(ObjectIdentifier(datasource), ObjectIdentifier(sut.dataSource))
    }

    func test_collectionView_dequeues_cell() {
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.loadViewIfNeeded()

        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: FeedCardCellController.identifier, for: IndexPath())
        XCTAssertNotNil(cell)
    }

    func test_displayReload_replacesDatasourceItems() {
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.loadViewIfNeeded()

        sut.displayReload(FeedViewModel(makeLoaderSuccessItems()))

        XCTAssertEqual(sut.dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 0), 5)
    }


    func test_displayAppend_increasesDatasourceItems() {
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.loadViewIfNeeded()

        sut.displayReload(FeedViewModel(makeLoaderSuccessItems(with: 1...5)))
        XCTAssertEqual(sut.dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 0), 5)

        sut.displayAppend(FeedViewModel(makeLoaderSuccessItems(with: 6...10)))

        XCTAssertEqual(sut.dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 0), 10)
    }

    func test_view_onCellSelect_callsHandler() {
        var handlerReceivedValue = -1
        
        let sut = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sut.onSelectFeedCard = { num in
            handlerReceivedValue = num
        }
        sut.loadViewIfNeeded()
        sut.displayReload(FeedViewModel([JSONImage(id: "100", author: "", width: 0, height: 0, url: "", download_url: "")]))

        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertEqual(handlerReceivedValue, 100)
    }


    private func makeLoaderSuccessItems(with range: ClosedRange<Int> = 1...5) -> [JSONImage] {
        return range.map {
            JSONImage(id: "\($0)", author: "Author \($0)", width: 400, height: 400, url: "http://url", download_url: "http://url")
        }
    }
}

extension FeedViewController {

    var loadingIndicatorIsVisible: Bool {
      return collectionView.refreshControl?.isRefreshing == true
    }

    public override func loadViewIfNeeded() {
      super.loadViewIfNeeded()
      // make view small to prevent rendering cells
      collectionView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }

    func simulatePagingRequest() {
        let scrollView = DraggingScrollView()
        scrollView.contentOffset.y = 1000
        self.scrollViewDidScroll(scrollView)
    }


    func simulateUserRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        scrollViewDidEndDragging(collectionView, willDecelerate: true)
    }
}

private class DraggingScrollView: UIScrollView {
  override var isDragging: Bool {
    true
  }
}
