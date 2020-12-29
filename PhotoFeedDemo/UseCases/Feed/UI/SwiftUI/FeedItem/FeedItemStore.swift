//
//  FeedItemStore.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 28.12.2020.
//

import SwiftUI

final class FeedItemStore: ObservableObject {
    var interactor: FeedItemInteractable? = nil

    var onDismiss: (() -> Void)?

    @Published var image: UIImage? = nil

}

extension FeedItemStore {
    func onTapGesture() {
        onDismiss?()
    }

    func onAppear() {
        interactor?.load()
    }
}

extension FeedItemStore: FeedItemViewable {
    func display(image: Data) {
        self.image = UIImage(data: image)
    }
}
