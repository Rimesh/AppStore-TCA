//
//  DownloadFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct DownloadFeature {
    @ObservableState
    struct State: Equatable {
        var status: DownloadStaus = .downloadable
        var purchaseLabelPosition: IAPLabelPosition

        enum DownloadStaus: Equatable {
            case downloadable
            case downloading(progress: CGFloat)
            case downloaded
        }

        enum IAPLabelPosition: Equatable {
            case vertial
            case horizontal
        }
    }

    enum Action: Equatable {
        case downloadButtonTapped
        case downloadProgressed
        case downloadCancelled
        case downloadCompleted
    }

    enum CancelId {
        case timer
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .downloadButtonTapped:
                state.status = .downloading(progress: 0.0)
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.downloadProgressed)
                    }
                }.cancellable(id: CancelId.timer)
            case .downloadProgressed:
                if case let .downloading(progress) = state.status {
                    if progress < 1.0 {
                        state.status = .downloading(progress: progress + 0.2)
                        return .none
                    } else {
                        return .send(.downloadCompleted)
                    }
                }
                return .none
            case .downloadCancelled:
                state.status = .downloadable
                return .cancel(id: CancelId.timer)
            case .downloadCompleted:
                state.status = .downloaded
                return .cancel(id: CancelId.timer)
            }
        }
    }
}

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
