//
//  FeedProgressViewController.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 18.12.2020.
//

import UIKit

class FeedRefreshController: FeedRefreshView {

    private(set) lazy var view = makeView()

    private func makeView() -> UIRefreshControl {
        let refreshView = UIRefreshControl(frame: .zero)
        refreshView.tintColor = .yellow
        return refreshView
    }

    func displayLoading(_ active: Bool) {
        if active {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

}
