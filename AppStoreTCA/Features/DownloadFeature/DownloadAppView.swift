//
//  DownloadAppView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//
import ComposableArchitecture
import SwiftUI

struct DownloadAppView: View {
    let store: StoreOf<DownloadFeature>

    @ScaledMetric(relativeTo: .largeTitle)
    private var horizontalPadding: CGFloat = 24

    var body: some View {
        switch store.status {
        case .downloadable:
            Button {
                store.send(.downloadButtonTapped)
            } label: {
                AVStack(hStackSpacing: 8) {
                    downloadButton(title: "GET")
                    inAppPurchaseLabel
                }
            }
            .buttonStyle(PlainButtonStyle())
        case let .downloading(progress):
            CircularProgressView(progress: progress)
                .frame(width: 32, height: 32)
        case .downloaded:
            AVStack(hStackSpacing: 8) {
                downloadButton(title: "OPEN")
                inAppPurchaseLabel
            }
        }
    }

    @ViewBuilder
    private func downloadButton(title: String) -> some View {
        Text(title)
            .lineLimit(1)
            .font(.headline)
            .minimumScaleFactor(0.75)
            .padding(.vertical, 4)
            .padding(.horizontal, horizontalPadding)
            .fixedSize()
            .foregroundColor(.blue)
            .background {
                Capsule()
                    .foregroundStyle(Color.gray.opacity(0.25))
            }
    }

    private var inAppPurchaseLabel: some View {
        switch store.purchaseLabelPosition {
        case .horizontal: InAppPurchaseLabel(placement: .naturalHorizontal)
        case .vertial: InAppPurchaseLabel(placement: .naturalVertical)
        }
    }
}

#Preview {
    DownloadAppView(
        store: .init(
            initialState: DownloadFeature.State(
                status: .downloadable,
                purchaseLabelPosition: .horizontal
            ),
            reducer: { DownloadFeature() },
            withDependencies: { dependencies in
                dependencies.continuousClock = TestClock()
            }
        )
    )
}
