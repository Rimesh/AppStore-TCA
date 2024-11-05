//
//  CategoryGridView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

struct CategoryGridView: View {
    @Environment(\.sizeCategory) var sizeCategory

    private var columns: [GridItem] {
        var columnCount: Int {
            switch sizeCategory {
            case .extraExtraExtraLarge, .accessibilityMedium,
                 .accessibilityLarge, .accessibilityExtraLarge,
                 .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge: 1
            default: 2
            }
        }

        return Array(repeating: .init(.flexible()), count: columnCount)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryTileView(category)
                }
            }
        }
    }
}

#Preview {
    CategoryGridView()
}
