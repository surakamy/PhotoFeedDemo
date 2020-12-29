//
//  FeedItemViewComposer.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 23.12.2020.
//

import UIKit

enum FeedItemViewComposer {
    static func compose(id: Int, loader: HTTPClient, onDismiss: (() -> Void)?) -> UIViewController {
        let controller = FeedItemViewController()
        let presenter = FeedItemPresenter(view: WeakRef(controller))
        let interactor = FeedItemInteractor(id: id, downloader: loader, presentor: presenter)

        controller.interactor = interactor
        controller.onDismiss = onDismiss

        return controller
    }
}

// MARK: - WeakRef Proxies
extension WeakRef: FeedItemViewable where T == FeedItemViewController {
    func display(image: Data) {
        object?.display(image: image)
    }
}

extension WeakRef: FeedItemInteractable where T == FeedItemInteractor {
    func load() {
        object?.load()
    }
}
