//
//  CollectionViewLayouts.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 19.12.2020.
//
import UIKit

func makeGalleryCollectionLayout() -> UICollectionViewLayout {
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let group50HeightSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
    let group50WidthSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
    let edgeInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

    func makeTopOfBox() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(layoutSize: groupSize)
        item.contentInsets = edgeInsets
        return NSCollectionLayoutGroup.horizontal(layoutSize: group50HeightSize, subitem: item, count: 2)
    }

    func makeBottomOfBox() -> NSCollectionLayoutGroup {
        func makeInnerBox() -> NSCollectionLayoutGroup {
            let item = NSCollectionLayoutItem(layoutSize: groupSize)
            item.contentInsets = edgeInsets

            let subgroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

            return NSCollectionLayoutGroup.vertical(layoutSize: group50WidthSize, subitem: subgroup, count: 2)
        }

        let item = NSCollectionLayoutItem(layoutSize: group50WidthSize)
        item.contentInsets = edgeInsets

        return NSCollectionLayoutGroup.horizontal(layoutSize: group50HeightSize, subitems: [item, makeInnerBox()])
    }

    func makeBoxGroup() -> NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        return NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [makeTopOfBox(), makeBottomOfBox()])
    }

    let sectionWithBox = NSCollectionLayoutSection(group: makeBoxGroup())

    return UICollectionViewCompositionalLayout(section: sectionWithBox)
}
