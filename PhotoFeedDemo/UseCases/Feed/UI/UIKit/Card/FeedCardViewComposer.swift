//
//  FeedCardViewComposer.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 21.12.2020.
//

import Foundation

enum FeedCardViewComposer {
    static func compose(card: FeedCardModel, imageLoader: HTTPClient?, onSelect: ((Int) -> Void)?) -> FeedCardCellController {
        let interactor = FeedCardInteractor(card: card, loader: imageLoader)
        let controller = FeedCardCellController(id: card.id, interactor: interactor, onSelect: onSelect)
        let presenter = FeedCardPresenter(view: WeakRef(controller))

        controller.interactor = interactor
        interactor.presenter = presenter

        return controller
    }
}

// MARK: - WeakRef Proxies
extension WeakRef: FeedCardViewable where T == FeedCardCellController {
    func display(_ viewModel: FeedCardViewModel) {
        object?.display(viewModel)
    }
}
