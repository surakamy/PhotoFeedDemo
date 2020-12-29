//
//  FeedPresenter.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import Foundation

protocol FeedPresentable {
    func renderLoading(_ active: Bool)
    func renderReload(_ images: [JSONImage])
    func renderAppend(_ images: [JSONImage])
    func renderError(_ error: RemoteFeedError)
}

class FeedPresenter: FeedPresentable {

    var viewFeed: FeedView? = nil
    var viewRefresh: FeedRefreshView? = nil

    func renderLoading(_ active: Bool) {
        viewRefresh?.displayLoading(active)
    }

    func renderReload(_ images: [JSONImage]) {
        viewFeed?.displayReload(FeedViewModel(images))
    }

    func renderAppend(_ images: [JSONImage]) {
        viewFeed?.displayAppend(FeedViewModel(images))
    }

    func renderError(_ error: RemoteFeedError) {
        viewFeed?.displayError()
    }
}
