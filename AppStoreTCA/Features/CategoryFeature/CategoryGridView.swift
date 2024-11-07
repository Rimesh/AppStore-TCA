//
//  CategoryGridView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//
import ComposableArchitecture
import SwiftUI

struct CategoryGridView: View {
    @Bindable var store: StoreOf<CategoryFeature>

    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(store.categories) { category in
                    CategoryTileView(category)
                        .onTapGesture {
                            store.send(.categoryButtonTapped(category))
                        }
                }
            }
        }
    }
}

extension CategoryGridView {
    private var columns: [GridItem] {
        var columnCount: Int {
            sizeCategory > .large ? 1 : 2
        }

        return Array(repeating: .init(.flexible()), count: columnCount)
    }
}

#Preview() {
    CategoryGridView(
        store: Store(
            initialState: CategoryFeature.State(),
            reducer: {
                CategoryFeature()
            }
        )
    )
}
