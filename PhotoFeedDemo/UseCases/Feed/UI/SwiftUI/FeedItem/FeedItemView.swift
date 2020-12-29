//
//  FeedItemView.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 28.12.2020.
//

import SwiftUI

struct FeedItemView: View {
    @StateObject var store: FeedItemStore

    var body: some View {
        ZStack {
            if let image = store.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            }
        }

        .onTapGesture {
            store.onTapGesture()
        }

        .onAppear {
            store.onAppear()
        }
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(store: FeedItemStore())
    }
}
