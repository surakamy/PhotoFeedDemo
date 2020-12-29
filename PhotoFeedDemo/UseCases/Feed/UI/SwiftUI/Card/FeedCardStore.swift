//
//  FeedCardStore.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 26.12.2020.
//

import SwiftUI

enum FeedCardStoreComposer {
    static func compose(card: FeedCardModel, imageLoader: HTTPClient?, onSelect: ((Int) -> Void)?) -> FeedCardStore {
        let interactor = FeedCardInteractor(card: card, loader: imageLoader)
        let store = FeedCardStore(id: card.id, interactor: interactor, onSelect: onSelect)
        let presenter = FeedCardPresenter(view: Weak2Ref(store))

        store.interactor = interactor
        interactor.presenter = presenter

        return store
    }
}

final class FeedCardStore: ObservableObject {
    let id: Int
    var interactor: FeedCardInteractable?
    let onSelect: ((Int) -> Void)?

    @Published var image: UIImage? = nil

    init(id: Int, interactor: FeedCardInteractable? = nil, onSelect: ((Int) -> Void)?) {
        self.id = id
        self.interactor = interactor
        self.onSelect = onSelect
    }
}

extension FeedCardStore {
    func onSelectCard() {
        onSelect?(id)
    }
}

extension FeedCardStore: FeedCardViewable {
    func display(_ viewModel: FeedCardViewModel) {
        if let data = viewModel.image {
            image = UIImage(data: data)
        } else {
            image = nil
        }
    }
}

extension FeedCardStore: FeedCardInteractable {
    func requestLoading() {
        interactor?.requestLoading()
    }

    func cancelLoading() {
        interactor?.cancelLoading()
    }
}

extension FeedCardStore: Identifiable, Equatable, Hashable {
    static func == (lhs: FeedCardStore, rhs: FeedCardStore) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FeedCardStore: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(id)"
    }
}

// MARK: - WeakRef Proxies
extension Weak2Ref: FeedCardViewable where T == FeedCardStore {
    func display(_ viewModel: FeedCardViewModel) {
        object?.display(viewModel)
    }
}
