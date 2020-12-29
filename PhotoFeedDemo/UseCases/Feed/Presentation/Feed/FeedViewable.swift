//
//  FeedViewable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 19.12.2020.
//

import Foundation

protocol FeedRefreshView {
    func displayLoading(_ active: Bool)
}

protocol FeedView {
    func displayReload(_ viewModel: FeedViewModel)
    func displayAppend(_ viewModel: FeedViewModel)
    func displayError()
}

struct FeedViewModel: Equatable {
    var images: [FeedCardModel]
    init(_ images: [JSONImage]) {
        self.images = images.compactMap { (json) -> FeedCardModel? in
            guard
                let id = Int(json.id)
            else { return nil }

            let url = URL(string: "https://picsum.photos/id/\(id)/200/300")!

            return FeedCardModel(id: id, author: json.author, source: url)
        }
    }

    init() {
        let dummies = (1...20).map { _ in
            FeedCardModel(id: -1, author: "", source: nil)
        }
        self.images = dummies
    }
}
