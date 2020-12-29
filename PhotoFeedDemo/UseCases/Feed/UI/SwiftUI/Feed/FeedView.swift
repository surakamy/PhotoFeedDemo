//
//  FeedView.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 25.12.2020.
//

import SwiftUI

struct SUIFeedView: View {

    @StateObject var store: FeedViewStore

    static let spacing: CGFloat = 4

    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: spacing),
        GridItem(.adaptive(minimum: 150), spacing: spacing),
    ]

    var body: some View {
        RefreshableScrollView(refreshing: $store.loading) {
            LazyVGrid(columns: columns, spacing: Self.spacing) {
                FeedCustomLayout(items: $store.cards, spacing: Self.spacing) { card in
                    FeedCardView(store: card)
                        .onAppear { store.scrolled(to: card) }
                }
            }.padding(Self.spacing)
        }
        .foregroundColor(Color.white)
        .onAppear() {
            store.reload()
        }
    }
}

//struct SUIFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SUIFeedView(interactor: <#FeedInteractor#>)
//    }
//}
