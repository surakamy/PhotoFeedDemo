//
//  FeedUseCaseFactory.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 22.12.2020.
//

import UIKit

enum UIKitFactory {

    static func makeFeed(_ router: Router) -> UIViewController {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = MainQueueDispatchDecorator(decoratee: PicsumFeedLoader(client: client))
        let imageLoader = MainQueueDispatchDecorator(decoratee: client)

        let handler = { (id: Int) in
            router.showDetails(UIKitFactory.makeDetails(id, router))
        }

        let controller = FeedViewComposer.compose(feedLoader: loader, imageLoader: imageLoader, onSelect: handler)

        return controller
    }

    static func makeDetails(_ id: Int, _ router: Router) -> UIViewController {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = MainQueueDispatchDecorator(decoratee: client)
        let controller = FeedItemViewComposer.compose(id: id, loader: loader) {
            router.dismissDetails()
        }
        return controller
    }
}
