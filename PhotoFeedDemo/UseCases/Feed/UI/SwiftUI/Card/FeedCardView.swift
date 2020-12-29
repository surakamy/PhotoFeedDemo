//
//  FeedCardView.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 26.12.2020.
//

import SwiftUI

struct FeedCardView: View {
    @StateObject var store: FeedCardStore

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Color("BackColor")
                if let image = store.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.height)
                        .clipped()
                }
            }
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            store.onSelectCard()
        })

        .aspectRatio(1, contentMode: .fit)

        .onAppear {
            store.requestLoading()
        }
        .onDisappear {
            store.cancelLoading()
        }
    }
}

extension FeedCardView: Identifiable {
    var id: Int { self.store.id }
}

//struct FeedCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedCardView()
//    }
//}
