//
//  FeedItemInteractable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 23.12.2020.
//

import Foundation

protocol FeedItemInteractable {
    func load()
}

final class FeedItemInteractor: FeedItemInteractable {
    init(id: Int, downloader: HTTPClient, presentor: FeedItemPresentable?) {
        self.id = id
        self.downloader = downloader
        self.presentor = presentor
    }

    let image: Data? = nil
    let id: Int
    let downloader: HTTPClient
    let presentor: FeedItemPresentable?

    func load() {
        downloader.dispatch(URLRequest(url: makeEndPoint())) { (result) in
            if case let .success((data, _)) = result {
                self.presentor?.render(image: data)
            }
        }
    }

    func makeEndPoint() -> URL {
        URL(string: "https://picsum.photos/id/\(id)/400/400")!
    }

}
