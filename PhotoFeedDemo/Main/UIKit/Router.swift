//
//  AppDelegate.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 15.12.2020.
//

import UIKit

struct Router {
    let navController: UINavigationController
    func show(_ vc: UIViewController) {
        navController.pushViewController(vc, animated: false)
    }

    func showDetails(_ vc: UIViewController) {
        navController.pushViewController(vc, animated: true)
    }

    func dismissDetails() {
        navController.popViewController(animated: true)
    }
}
