//
//  InAppPurchaseLabel.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 07/11/24.
//

import SwiftUI

struct InAppPurchaseLabel: View {
    @Environment(\.sizeCategory) var sizeCategory
    @ScaledMetric(relativeTo: .headline)
    private var textSize: CGFloat = 10
    private var placement: Placement

    init(placement: Placement) {
        self.placement = placement
    }

    /// naturalHorizontal: HStack natural alignment, when using accessibility switches to VStack
    /// naturalVertical: VStack natural alignment, when using accessibility switches to HStack
    enum Placement {
        case naturalHorizontal
        case naturalVertical
    }

    var body: some View {
        contentView
    }

    @ViewBuilder
    var contentView: some View {
        switch placement {
        case .naturalHorizontal: horizontallyPlacedViews
        case .naturalVertical: verticallyPlacedViews
        }
    }

    private var horizontallyPlacedViews: some View {
        AHStack(
            hStackAlignment: .center,
            hStackSpacing: nil,
            vStackAlignment: .leading,
            vStackSpacing: nil
        ) {
            Text("In-App")
            Text("Purchases")
        }
        .lineLimit(1)
        .font(.system(size: textSize, weight: .medium))
        .minimumScaleFactor(0.75)
        .foregroundStyle(.secondary)
        .fixedSize()
    }

    var verticallyPlacedViews: some View {
        AVStack(
            hStackAlignment: .center,
            hStackSpacing: nil,
            vStackAlignment: .leading,
            vStackSpacing: nil
        ) {
            Text("In-App")
            Text("Purchases")
        }
        .lineLimit(1)
        .font(.system(size: textSize, weight: .medium))
        .minimumScaleFactor(0.75)
        .foregroundStyle(.secondary)
        .fixedSize()
    }
}
