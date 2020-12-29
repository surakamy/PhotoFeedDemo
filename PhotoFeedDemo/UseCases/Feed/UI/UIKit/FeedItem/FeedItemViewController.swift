//
//  FeedItemViewController.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 23.12.2020.
//

import UIKit

protocol FeedItemToFeedTransitioning {
    func display(_ image: UIImage)
}

final class FeedItemViewController: UIViewController {
    var interactor: FeedItemInteractable? = nil

    var onDismiss: (() -> Void)?

    var imageView: UIImageView { view as! UIImageView }

    override func loadView() {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        view = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.load()

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        swipe.direction = [.left, .up, .down, .right]
        imageView.addGestureRecognizer(swipe)
    }

    @objc func handle(recognizer: UITapGestureRecognizer) {
        onDismiss?()
    }
}

extension FeedItemViewController: FeedItemViewable {
    func display(image: Data) {
        imageView.image = UIImage(data: image)
    }
}

extension FeedItemViewController: FeedItemToFeedTransitioning {
    func display(_ image: UIImage) {
        imageView.image = image
    }
}
