//
//  FeedCardInteractable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 19.12.2020.
//

import Foundation

protocol FeedCardInteractable: AnyObject {
    func requestLoading()
    func cancelLoading()
}


class FeedCardInteractor: FeedCardInteractable {
    var presenter: FeedCardPresentable? = nil
    let loader: HTTPClient?
    let card: FeedCardModel

    var request: HTTPClientTask? = nil
    var image: Data? = nil

    init(card: FeedCardModel, loader: HTTPClient?) {
        self.card = card
        self.loader = loader
    }

    deinit {
        self.request?.cancel()
    }
    
    func requestLoading() {
        if let image = image {
            presenter?.renderLoading(false)
            presenter?.renderImage(image)
        } else {
            presenter?.renderLoading(true)
            if let url = card.source {
                requestDownload(url)
            }
        }
    }

    func cancelLoading() {
        if let task = self.request {
            task.cancel()
        }
        self.request = nil
    }

    private func requestDownload(_ url: URL) {
        guard self.request == nil else {
            return
        }

        let task = loader?.dispatch(URLRequest(url: url)) {
            [weak self] result in
            
            switch result {
            case let .success((data, _)):
                self?.image = data
                self?.presenter?.renderImage(data)
            case .failure:
                self?.image = nil
                break
            }
        }
        self.request = task
    }
}
