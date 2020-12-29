//
//  SwiftUIFactory.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 25.12.2020.
//

import SwiftUI

enum SUIFactory {

    static func makeRootView(_ router: SUIRouter) -> AnyView {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = MainQueueDispatchDecorator(decoratee: PicsumFeedLoader(client: client))
        let imageLoader = MainQueueDispatchDecorator(decoratee: client)

        let handler = { (id: Int) in
            router.showDetails(SUIFactory.makeDetails(id, router))
        }

        let store = SUIFeedViewComposer.compose(feedLoader: loader, imageLoader: imageLoader, onSelect: handler)
        return AnyView(SUIFeedView(store: store))
    }

    static func makeDetails(_ id: Int, _ router: SUIRouter) -> AnyView {
        let client = URLSessionClient(session: URLSession(configuration: .ephemeral))
        let loader = MainQueueDispatchDecorator(decoratee: client)
        let store = SUIFeedItemComposer.compose(id: id, loader: loader) {
            router.dismissDetails()
        }

        return AnyView(FeedItemView(store: store))
    }
}
