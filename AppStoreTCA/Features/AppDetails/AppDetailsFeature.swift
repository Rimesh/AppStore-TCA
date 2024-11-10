//
//  AppDetailsFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 06/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let app: AppApiModel
        var showAppDescription: Bool = false
        var downloadApp: DownloadFeature.State
    }

    enum Action {
        case descriptionButtonTapped
        case downloadApp(DownloadFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.downloadApp, action: \.downloadApp) { DownloadFeature() }
        Reduce { state, action in
            switch action {
            case .descriptionButtonTapped:
                state.showAppDescription = true
                return .none
            case .downloadApp:
                return .none
            }
        }
    }
}
