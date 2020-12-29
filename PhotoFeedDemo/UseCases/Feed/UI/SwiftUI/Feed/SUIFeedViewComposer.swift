//
//  FeedViewComposer.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 26.12.2020.
//

import Foundation

enum SUIFeedViewComposer {
    static func compose(feedLoader: RemoteFeedLoader, imageLoader: HTTPClient, onSelect: @escaping (Int) -> Void) -> FeedViewStore {
        let interactor = FeedInteractor(source: feedLoader)
        let presenter = FeedPresenter()

        let store = FeedViewStore(interactor: interactor)
        store.imageLoader = imageLoader
        store.onSelectFeedCard = onSelect

        presenter.viewFeed = Weak2Ref(store)
        presenter.viewRefresh = Weak2Ref(store)
        interactor.presenter = presenter

        return store
    }
}

// MARK: - WeakRef Proxies
extension Weak2Ref: FeedView where T == FeedViewStore {
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

extension Weak2Ref: FeedRefreshView where T == FeedViewStore {
    func displayLoading(_ active: Bool) {
        object?.displayLoading(active)
    }
}
