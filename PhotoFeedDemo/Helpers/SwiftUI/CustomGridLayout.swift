//
//  CustomGridLayout.swift
//  PhotoFeedDemo
//
//  Created by Dmytro Kholodov on 27.12.2020.
//

import SwiftUI

/// Maps elements of an array into array of arrays. Each element is folded into an array which contains that element, apart from elements which positions are multiples of `at`. For such positions it accumulates elements until reaches `max` limit.
/// - Parameters:
///   - input: Oridinal elements
///   - at: Multiple of this value is folded
///   - max: Home much folded element can contain
/// - Returns: Folded elements
public func fold<T, Elements: Sequence>(_ input: Elements, at: Int, max: Int) -> [[T]] where Elements.Element == T {
    typealias FoldedElements = Array<Array<T>>
    return input.reduce(FoldedElements()) {
        prev, current in

        var result = prev
        let count = prev.count
        if count > 0 && count.isMultiple(of: at) {
            if var folding = result.popLast() {
                if folding.count < max {
                    folding.append(current)
                    result.append(folding)
                } else {
                    result.append(folding)
                    result.append([current])
                }
            }
        } else {
            result.append([current])
        }
        return result
    }
}

struct FeedCustomLayout<Item: Hashable, Content: View>: View {

    @Binding var items: [Item]

    let content: (Item) -> Content

    let spacing: CGFloat

    let columns: [GridItem]

    init(items: Binding<[Item]>, spacing: CGFloat, @ViewBuilder content: @escaping (Item) -> Content) {
        self._items = items
        self.spacing = spacing
        self.content = content
        self.columns = [
            GridItem(.adaptive(minimum: 100), spacing: spacing),
            GridItem(.adaptive(minimum: 100), spacing: spacing),
        ]
    }

    var body: some View {
        ForEach(groupped(), id: \.self) { current in
            switch current.count {
            case 0:
                EmptyView()
            case 1:
                content(current[0])
            default:
                GridStack(rows: 2, columns: 2, spacing: spacing) { row, col in
                    content(current[row * 2 + col])
                }
            }
        }
    }

    private func groupped() -> [[Item]] {
        fold(items, at: 4, max: 4)
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let spacing: CGFloat
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}
