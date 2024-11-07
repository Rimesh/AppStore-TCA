//
//  CategoryTileView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

struct CategoryTileView: View {
    @ScaledMetric(relativeTo: .headline)
    private var imageSize = 60

    let category: Category

    public init(_ category: Category) {
        self.category = category
    }

    var body: some View {
        HStack {
            ZStack {
                categoryTextView
                categoryIconView
            }
        }
        .background {
            backgroundGradient
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var categoryTextView: some View {
        HStack {
            Spacer()
            Image(category.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: imageSize,
                    height: imageSize
                )
        }
        .padding()
    }

    private var categoryIconView: some View {
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

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                category.gradientColor.opacity(0.7),
                category.gradientColor.opacity(1),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
