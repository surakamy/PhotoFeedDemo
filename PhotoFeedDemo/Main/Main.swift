//
//  Main.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 28.12.2020.
//

import SwiftUI
import UIKit

// Entry point for SwiftUI version of the app
//@main
struct FeedApp: App {
    @StateObject var store = SUIRouter()

    var body: some Scene {
        WindowGroup {
            RouterContainer(store: self.store)
                .onAppear {
                    store.show(makeRootView())
                }
        }
    }

    func makeRootView() -> AnyView {
        SUIFactory.makeRootView(store)
    }
}

// Entry point for UIKit version of the app
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var router = Router(navController: NavigationController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let currentWindow = UIWindow()
        defer { window = currentWindow }
        currentWindow.rootViewController = makeRootController(with: router)
        currentWindow.makeKeyAndVisible()

        return true
    }

    private func makeRootController(with rooter: Router) -> UIViewController {
        let feed = UIKitFactory.makeFeed(router)
        router.show(feed)
        return router.navController
    }
}
