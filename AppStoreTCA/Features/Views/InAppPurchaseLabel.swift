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

    enum Placement {
        case appResults
        case appDetails
    }

    var body: some View {
        contentView
    }

    @ViewBuilder
    var contentView: some View {
        switch placement {
        case .appResults: accessibleHStack
        case .appDetails: accessibleVStack
        }
    }

    var accessibleHStack: some View {
        AHStack(
            hStackAlignment: .center,
            hStackSpacing: nil,
            vStackAlignment: .leading,
            vStackSpacing: nil
        ) {
            Text("In-App")
            Text("Purchases")
        }
        .font(.system(size: textSize, weight: .medium))
        .foregroundStyle(.secondary)
        .fixedSize()
    }

    var accessibleVStack: some View {
        AVStack(
            hStackAlignment: .center,
            hStackSpacing: nil,
            vStackAlignment: .leading,
            vStackSpacing: nil
        ) {
            Text("In-App")
            Text("Purchases")
        }
        .font(.system(size: textSize, weight: .medium))
        .foregroundStyle(.secondary)
    }
}
