//
//  FeedViewController.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 17.12.2020.
//

import UIKit

protocol FeedToFeedItemTransitioning {
    var fromView: UIView? { get }
    var fromWindowFrame: CGRect? { get }
}

final class FeedViewController: UICollectionViewController {
    var interactor: FeedInteractable?
    var imageLoader: HTTPClient? = nil
    var refreshController = FeedRefreshController()
    var onSelectFeedCard: ((Int) -> Void)?

    lazy var dataSource: UICollectionViewDiffableDataSource<Int, FeedCardCellController> = {
        UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, controller in

            return controller.view(in: collectionView, forItemAt: indexPath)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadScaffoldData()
        interactor?.reload()
    }

    private func configureView() {
        FeedCardCellController.register(in: collectionView)
        collectionView.dataSource = dataSource
        collectionView.refreshControl = refreshController.view
    }
}

extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.show(cell: cell)
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.cancel()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.select()
    }
}

extension FeedViewController {
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            interactor?.load()
        }
    }

    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if collectionView.refreshControl?.isRefreshing == true {
            interactor?.reload()
        }
    }

}

extension FeedViewController: FeedView {
    func displayReload(_ viewModel: FeedViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedCardCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(compose(viewModel), toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func displayAppend(_ viewModel: FeedViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(compose(viewModel), toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func displayError() {}
}

extension FeedViewController {
    func compose(_ viewModel: FeedViewModel) -> [FeedCardCellController] {
        viewModel.images.map {
            FeedCardViewComposer.compose(card: $0, imageLoader: self.imageLoader, onSelect: self.onSelectFeedCard)
        }
    }
}

extension FeedViewController {
    private func loadScaffoldData() {
        let empty = FeedViewModel()
        displayReload(empty)
    }
}


extension FeedViewController: FeedToFeedItemTransitioning {

    var fromView: UIView? {
        guard let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first
        else { return nil}

        guard let cell = collectionView.cellForItem(at: selectedIndex)
        else { return nil}

        return cell
    }

    var fromWindowFrame: CGRect? {
        if let window = self.view.window, let from = fromView, let supperView = from.superview {
            return supperView.convert(from.frame, to: window)
        }
        return nil
    }

}
