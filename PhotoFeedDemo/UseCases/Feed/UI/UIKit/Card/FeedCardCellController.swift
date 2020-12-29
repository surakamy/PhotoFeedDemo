//
//  FeedModels.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 18.12.2020.
//

import UIKit

final class FeedCardCellController {
    let id: Int
    var interactor: FeedCardInteractable?
    let onSelect: ((Int) -> Void)?

    init(id: Int, interactor: FeedCardInteractable?, onSelect: ((Int) -> Void)?) {
        self.id = id
        self.interactor = interactor
        self.onSelect = onSelect
    }

    static let identifier = "ImageViewCell"

    var contentCell: ImageViewCell?

    func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCardCellController.identifier, for: indexPath)
        contentCell = cell as? ImageViewCell
        return cell
    }

    func show(cell: UICollectionViewCell) {
        contentCell = cell as? ImageViewCell
        interactor?.requestLoading()
     }

     func cancel() {
        contentCell?.imageView.image = nil
        releaseContentCellForReuse()
        interactor?.cancelLoading()
     }

     func select() {
        onSelect?(id)
     }

     private func releaseContentCellForReuse() {
         contentCell = nil
     }

     static func register(in collectionView: UICollectionView) {
         collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: FeedCardCellController.identifier)
     }

}

extension FeedCardCellController: Hashable {
    static func == (lhs: FeedCardCellController, rhs: FeedCardCellController) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension FeedCardCellController: FeedCardViewable {
    func display(_ viewModel: FeedCardViewModel) {
        guard let cell = contentCell else {
            return
        }
        cell.isShimmering = viewModel.isShimmering
        if viewModel.isShimmering {
            cell.imageView.image = nil
        }
        else if let imageData = viewModel.image {
            cell.imageView.image = UIImage(data: imageData)
        }
    }

}
