//
//  FeedItemPresentable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 23.12.2020.
//

import Foundation

protocol FeedItemPresentable {
    func render(image: Data)
}

struct FeedItemPresenter: FeedItemPresentable {
    let view: FeedItemViewable

    func render(image: Data) {
        view.display(image: image)
    }
}
