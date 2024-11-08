//
//  LeadingGradientLabel.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 08/11/24.
//

import SwiftUI

struct LeadingGradientLabel: View {
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .headline)
    private var leadingPadding: CGFloat = 30

    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .padding(.leading, leadingPadding)
            .foregroundStyle(Color.blue)
            .background {
                primaryInvertedGradient
            }
    }

    private var primaryInvertedGradient: LinearGradient {
        LinearGradient(
            colors: [primaryInvertedColor.opacity(0.1), primaryInvertedColor],
            startPoint: .leading,
            endPoint: .init(x: 0.25, y: 1)
        )
    }

    private var primaryInvertedColor: Color {
        colorScheme == .light ? .white : .black
    }
}
