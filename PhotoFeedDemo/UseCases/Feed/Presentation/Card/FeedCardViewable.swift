//
//  FeedCardViewable.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 19.12.2020.
//

import Foundation

struct FeedCardViewModel: Equatable {
    let image: Data?
    let isShimmering: Bool
}

protocol FeedCardViewable {
    func display(_ viewModel: FeedCardViewModel)
}

struct FeedCardModel: Equatable, Identifiable {
    let id: Int
    let author: String
    let source: URL?
}


