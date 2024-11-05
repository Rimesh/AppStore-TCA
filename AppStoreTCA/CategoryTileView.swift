//
//  CategoryTileView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import SwiftUI

enum Category: String, CaseIterable {
    case games, finance, music, social, shopping, photo, productivity, puzzle, utilities, travel

    var gradientColor: Color {
        switch self {
        case .games, .photo: Color("categoryBlue")
        case .finance, .productivity: Color("categoryGreen")
        case .music, .puzzle: Color("categoryPink")
        case .social, .utilities: Color("categoryPurple")
        case .shopping, .travel: Color("categoryYellow")
        }
    }
}

struct CategoryTileView: View {
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
    VStack {
        ForEach(Category.allCases, id: \.self) { category in
            CategoryTileView(category)
        }
    }
}
