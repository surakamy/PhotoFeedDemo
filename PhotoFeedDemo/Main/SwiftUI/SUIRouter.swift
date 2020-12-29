//
//  SUIRouter.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 28.12.2020.
//

import SwiftUI

final class SUIRouter: ObservableObject {
    @Published var backView: AnyView? = nil
    @Published var frontView: AnyView? = nil

    func show(_ vc: AnyView) {
        backView = vc
    }

    func showDetails(_ vc: AnyView) {
        frontView = vc
    }

    func dismissDetails() {
        frontView = nil
    }
}

struct RouterContainer: View {
    @ObservedObject var store: SUIRouter

    var isModal: Bool { self.store.frontView != nil }

    var body: some View {
        ZStack {
            Color
                .black
                .edgesIgnoringSafeArea(.all)

            if let back = self.store.backView {
                back
                    .disabled(isModal)
                    .blur(radius: isModal ? 3.0 : 0.0)

                if isModal {
                    Color("BackColor")
                        .edgesIgnoringSafeArea(.all)
                        .blendMode(.darken)
                        .opacity(0.7)
                }
            }

            if let front = self.store.frontView {
                front
            }
        }
    }

}

struct SUIRouter_Previews: PreviewProvider {
    static var previews: some View {
        DemoNav()
    }

    struct DemoNav: View {
        @StateObject var router = SUIRouter()
        var body: some View {
            VStack {
                RouterContainer(store: router)

                Button("Show modal") {
                    router.show(AnyView(
                        Color.yellow.frame(width: 200, height: 200)
                    ))
                }
                Button("Dismiss modal") {
                    router.dismissDetails()
                }
            }

            .onAppear {
                router.show(AnyView(Color.blue))
            }
        }
    }
}
