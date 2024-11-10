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
