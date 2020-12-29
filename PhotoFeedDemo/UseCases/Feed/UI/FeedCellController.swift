//
//  FeedModels.swift
//  RandomGalleryDemo
//
//  Created by Dmytro Kholodov on 18.12.2020.
//

import UIKit

final class ImageViewCell: UICollectionViewCell {
    override func layoutSubviews() {
        superview?.layoutSubviews()
        backgroundColor = .systemBackground
    }
}

struct FeedCardViewModel {
}

protocol FeedCellView {
    func display(_ viewModel: FeedCardViewModel)
}

protocol FeedCardInteractor {
    var model: PicsumImage { get }
    func requestLoading()
}
protocol FeedCardPresenter {
    func renderLoading(_ active: Bool)
    func renderImage()
}

final class FeedCardController {
    let image: PicsumImage

    init(image: PicsumImage) {
        self.image = image
    }

    static let identifier = "ImageViewCell"

    var contentCell: ImageViewCell?

    func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCardController.identifier, for: indexPath)
        contentCell = cell as? ImageViewCell
        print("View cell at \(indexPath)")
        return cell
    }

    func show(cell: UICollectionViewCell) {
         contentCell = cell as? ImageViewCell
        // start Loading
     }

     func cancel() {
         releaseContentCellForReuse()
        // stop loading
     }

     func select() {

     }

     private func releaseContentCellForReuse() {
         contentCell = nil
     }

     static func register(in collectionView: UICollectionView) {
         collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: FeedCardController.identifier)
     }

}

extension FeedCardController: Hashable {
    static func == (lhs: FeedCardController, rhs: FeedCardController) -> Bool {
        lhs.image.id == rhs.image.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(image.id)
    }
}


extension FeedCardController: FeedCellView {
    func display(_ viewModel: FeedCardViewModel) {

    }
}
