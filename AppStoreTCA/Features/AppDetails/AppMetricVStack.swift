//
//  AppMetricVStack.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 07/11/24.
//

import SwiftUI

struct AppMetricVStack<Top, Middle, Bottom>: View where Top: View, Middle: View, Bottom: View {
    let topView: Top
    let middleView: Middle
    let bottomView: Bottom
    let trailingSeparatorHidden: Bool
    @Environment(\.sizeCategory) var sizeCategory
    @ScaledMetric(relativeTo: .caption)
    private var appMetricsStackSpacing: CGFloat = 10

    @State private var stackHeight: CGFloat = .zero

    init(
        @ViewBuilder topView: () -> Top,
        @ViewBuilder middleView: () -> Middle,
        @ViewBuilder bottomView: () -> Bottom,
        trailingSeparatorHidden: Bool = false
    ) {
        self.topView = topView()
        self.middleView = middleView()
        self.bottomView = bottomView()
        self.trailingSeparatorHidden = trailingSeparatorHidden
    }

    var body: some View {
        HStack(spacing: .zero) {
            VStack(
                alignment: sizeCategory.isAccessibilityCategory ? .leading : .center,
                spacing: appMetricsStackSpacing
            ) {
                topView
                    .font(.system(.footnote, design: .default, weight: .medium))
                    .foregroundStyle(Color.secondary)
                middleView
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color.gray)
                bottomView
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color.secondary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(GeometryReader { geometry in
                Color.clear.preference(key: VStackHeightKey.self, value: geometry.size.height)
            })
            .onPreferenceChange(VStackHeightKey.self) { newValue in
                stackHeight = newValue
            }

            if trailingSeparatorHidden == false {
                Divider()
                    .frame(width: 1, height: max(0, stackHeight - 10))
            }
        }
    }
}

// Preference key to pass height from GeometryReader
private struct VStackHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
