//
//  FeedCardPresentable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 19.12.2020.
//

import Foundation

protocol FeedCardPresentable {
    func renderLoading(_ active: Bool)
    func renderImage(_ data: Data)
}


struct FeedCardPresenter: FeedCardPresentable {
    let view: FeedCardViewable?

    func renderLoading(_ active: Bool) {
        view?.display(.init(image: nil, isShimmering: true))
    }

    func renderImage(_ data: Data) {
        view?.display(.init(image: data, isShimmering: false))
    }

}
