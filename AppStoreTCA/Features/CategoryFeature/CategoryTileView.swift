//
//  CategoryTileView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

struct CategoryTileView: View {
    @Environment(\.sizeCategory) var sizeCategory

    var scaleFactor: Double {
        switch sizeCategory {
        case .small: 0.8
        case .medium: 0.9
        case .large: 1
        case .extraLarge: 1.1
        case .extraExtraLarge: 1.2
        case .extraExtraExtraLarge: 1.3
        case .accessibilityMedium,
             .accessibilityLarge, .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge: 1.5
        default: 1
        }
    }

    let category: Category

    public init(_ category: Category) {
        self.category = category
    }

    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Spacer()
                    Image(category.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 80 * scaleFactor,
                            height: 80 * scaleFactor
                        )
                }
                .padding()
                HStack(alignment: .bottom) {
                    VStack {
                        Spacer()
                        Text(category.rawValue.capitalized)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .fixedSize()
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .background {
            LinearGradient(
                gradient: Gradient(colors: [
                    category.gradientColor.opacity(0.7),
                    category.gradientColor.opacity(1),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview() {
    ScrollView {
        ForEach(Category.allCases, id: \.self) { category in
            CategoryTileView(category)
        }
    }
}
