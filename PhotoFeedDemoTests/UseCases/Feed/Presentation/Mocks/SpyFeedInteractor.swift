//
//  SpyFeedInteractor.swift
//  PhotoFeedDemoTests
//
//  Created by Dmytro Kholodov on 27.12.2020.
//

import Foundation
@testable import PhotoFeedDemo

final class SpyFeedInteractor: FeedInteractable {
    enum Messages: CustomStringConvertible {
        case load
        case reload

        var description: String {
            switch self {
            case .reload:
                return "reload"
            case .load:
                return "load"
            }
        }
    }

    var messages: [Messages] = []

    func load() {
        messages.append(.load)
    }

    func reload() {
        messages.append(.reload)
    }
}
