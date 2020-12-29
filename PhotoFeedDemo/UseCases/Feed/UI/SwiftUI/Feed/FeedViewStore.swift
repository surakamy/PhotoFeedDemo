//
//  FeedViewStore.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 26.12.2020.
//

import SwiftUI

final class FeedViewStore: ObservableObject {

    @Published var cards: [FeedCardStore] = []
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                self.interactor.reload()
            }
        }
    }
    var interactor: FeedInteractable
    var imageLoader: HTTPClient? = nil
    var onSelectFeedCard: ((Int) -> Void)? = nil

    init(interactor: FeedInteractable) {
        self.interactor = interactor
    }

    func scrolled(to card: FeedCardStore) {
        if let last = cards.last, last.id == card.id {
            load()
        }
    }

    private func compose(_ viewModel: FeedViewModel) -> [FeedCardStore] {
        viewModel.images.map {
            FeedCardStoreComposer.compose(card: $0, imageLoader: self.imageLoader, onSelect: self.onSelectFeedCard)
        }
    }
}

extension FeedViewStore: FeedInteractable {
    func reload() {
        interactor.reload()
    }

    func load() {
        interactor.load()
    }
}

extension FeedViewStore: FeedRefreshView {
    func displayLoading(_ active: Bool) {
        loading = active
    }
}

extension FeedViewStore: FeedView {
    func displayReload(_ viewModel: FeedViewModel) {
        cards = compose(viewModel)
    }

    func displayAppend(_ viewModel: FeedViewModel) {
        cards += compose(viewModel)
    }

    func displayError() {}
}
