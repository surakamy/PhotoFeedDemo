//
//  FeedViewComposer.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 18.12.2020.
//

import UIKit

enum FeedViewComposer {
    static func compose(feedLoader: RemoteFeedLoader, imageLoader: HTTPClient, onSelect: @escaping (Int) -> Void) -> FeedViewController {
        let interactor = FeedInteractor(source: feedLoader)
        let presenter = FeedPresenter()

        let controller = FeedViewController(collectionViewLayout: makeGalleryCollectionLayout())

        controller.onSelectFeedCard = onSelect
        controller.interactor = interactor
        controller.imageLoader = imageLoader
        
        presenter.viewFeed = WeakRef(controller)
        presenter.viewRefresh = WeakRef(controller.refreshController)
        interactor.presenter = presenter

        return controller
    }
}

// MARK: - WeakRef Proxies
extension WeakRef: FeedView where T == FeedViewController {
    func displayReload(_ viewModel: FeedViewModel) {
        object?.displayReload(viewModel)
    }

    func displayAppend(_ viewModel: FeedViewModel) {
        object?.displayAppend(viewModel)
    }

    func displayError() {
        object?.displayError()
    }
}

extension WeakRef: FeedRefreshView where T == FeedRefreshController {
    func displayLoading(_ active: Bool) {
        object?.displayLoading(active)
    }
}


// MARK: - MainQueueDispatchDecorator

extension MainQueueDispatchDecorator: RemoteFeedLoader where T == PicsumFeedLoader {
    public typealias Result = RemoteFeedLoader.Result

    public func load(page: Int, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        decoratee.load(page: page) {
            [weak self] (result) in

            self?.dispatchOnMain { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: HTTPClient where T == URLSessionClient {
    public func dispatch(_ request: URLRequest, then handler: @escaping (Response) -> Void) -> HTTPClientTask {
        decoratee.dispatch(request) {
            [weak self] (response) in

            self?.dispatchOnMain { handler(response) }
        }
    }

}
