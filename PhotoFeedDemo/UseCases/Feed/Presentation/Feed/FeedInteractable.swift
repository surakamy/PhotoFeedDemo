//
//  FeedInteractor.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import Foundation

protocol FeedInteractable {
    func load()
    func reload()
}

public class FeedInteractor: FeedInteractable {
    let source: RemoteFeedLoader

    public init(source: RemoteFeedLoader) {
        self.source = source
    }

    var nextPage: Int = 1
    var presenter: FeedPresentable? = nil
    var runningTask: HTTPClientTask? = nil

    public func load() {
        load(page: nextPage)
    }

    public func reload() {
        load(page: 1)
    }

    func load(page: Int) {
        if runningTask != nil {
            return
        }

        if page == 1 {
            self.presenter?.renderLoading(true)
        }

        runningTask = source.load(page: page) {
            [weak self] (result) in
            guard let self = self else { return }
            defer { self.runningTask = nil }
            guard let presenter = self.presenter else { return }

            switch result {
            case let .success(images):
                if page == 1 {
                    presenter.renderLoading(false)
                    presenter.renderReload(images)
                } else {
                    presenter.renderAppend(images)
                }
                self.nextPage = page + 1

            case let .failure(error):
                if page == 1 {
                    presenter.renderLoading(false)
                }
                presenter.renderError(error)
            }
        }
    }
}
