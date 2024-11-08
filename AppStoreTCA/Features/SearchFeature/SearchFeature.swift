//
//  SearchFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var results: [AppApiModel] = []
        var searchQuery = ""
        var categories = CategoryFeature.State()
        var isSearchbarActive = false
        var isLoading = false
        var path = StackState<AppDetailsFeature.State>()
    }

    enum Action {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[AppApiModel], any Error>)
        case categories(CategoryFeature.Action)
        case searchbarFocusChanged(Bool)
        case path(StackAction<AppDetailsFeature.State, AppDetailsFeature.Action>)
    }

    @Dependency(\.appStoreClient) var appStoreClient
    private enum CancelID { case appSearch }

    var body: some Reducer<State, Action> {
        Scope(state: \.categories, action: \.categories) { CategoryFeature() }
        Reduce { state, action in
            switch action {
            case let .searchQueryChanged(query):
                state.isLoading = true
                state.searchQuery = query
                // Cancel in-flight requests
                guard !state.searchQuery.isEmpty else {
                    state.results = []
                    state.isLoading = false
                    return .cancel(id: CancelID.appSearch)
                }
                return .none

            case .searchQueryChangeDebounced:
                guard !state.searchQuery.isEmpty else {
                    return .none
                }
                return .run { [query = state.searchQuery] send in
                    await send(.searchResponse(Result { try await self.appStoreClient.search(query: query) }))
                }
                .cancellable(id: CancelID.appSearch)

            case .searchResponse(.failure):
                state.isLoading = false
                state.results = []
                return .none

            case let .searchResponse(.success(response)):
                state.isLoading = false
                state.results = response
                return .none

            case let .categories(.delegate(.selectCategory(category))):
                state.isLoading = true
                state.isSearchbarActive = true
                return .run { send in
                    await send(.searchQueryChanged(category.rawValue))
                }

            case .categories:
                return .none

            case let .searchbarFocusChanged(isActive):
                state.isSearchbarActive = isActive
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            AppDetailsFeature()
        }
    }
}
