//
//  AppResultFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppResultFeature {
    @ObservableState struct State: Equatable, Identifiable {
        var id: Int { app.id }
        var app: AppModel
        var downloadApp: DownloadFeature.State
    }

    enum Action: Equatable {
        case downloadApp(DownloadFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.downloadApp, action: \.downloadApp) { DownloadFeature() }
        Reduce { _, _ in
            .none
        }
    }
}
