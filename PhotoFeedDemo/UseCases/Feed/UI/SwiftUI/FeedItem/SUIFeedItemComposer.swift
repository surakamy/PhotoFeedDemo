//
//  FeedItemComposer.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 28.12.2020.
//

import SwiftUI

enum SUIFeedItemComposer {
    static func compose(id: Int, loader: HTTPClient, onDismiss: (() -> Void)?) -> FeedItemStore {
        let store = FeedItemStore()
        let presenter = FeedItemPresenter(view: Weak2Ref(store))
        let interactor = FeedItemInteractor(id: id, downloader: loader, presentor: presenter)

        store.interactor = interactor
        store.onDismiss = onDismiss

        return store
    }
}

// MARK: - WeakRef Proxies
extension Weak2Ref: FeedItemViewable where T == FeedItemStore {
    func display(image: Data) {
        object?.display(image: image)
    }
}
