//
//  SearchFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var appResults: IdentifiedArrayOf<AppResultFeature.State> = []
        var searchQuery = ""
        var categories = CategoryFeature.State()
        var isSearchbarActive = false
        var path = StackState<AppDetailsFeature.State>()
        var contentState: ContentState = .categories
    }

    enum Action {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[AppApiModel], any Error>)
        case categories(CategoryFeature.Action)
        case searchbarFocusChanged(Bool)
        case path(StackAction<AppDetailsFeature.State, AppDetailsFeature.Action>)
        case appResults(IdentifiedActionOf<AppResultFeature>)
    }

    enum ContentState: Equatable {
        case categories
        case appResults
        case loading
        case noResults
    }

    @Dependency(\.appStoreClient) var appStoreClient
    private enum CancelID { case appSearch }

    var body: some Reducer<State, Action> {
        Scope(state: \.categories, action: \.categories) { CategoryFeature() }
        Reduce {
            state,
                action in
            switch action {
            case let .searchQueryChanged(query):
                state.searchQuery = query
                // Cancel in-flight requests
                guard !state.searchQuery.isEmpty else {
                    state.contentState = .noResults
                    return .cancel(id: CancelID.appSearch)
                }
                return .none

            case .searchQueryChangeDebounced:
                guard !state.searchQuery.isEmpty else {
                    return .none
                }
                state.contentState = .loading
                return .run { [query = state.searchQuery] send in
                    await send(.searchResponse(Result { try await self.appStoreClient.search(query: query) }))
                }
                .cancellable(id: CancelID.appSearch)

            case .searchResponse(.failure):
                state.contentState = .noResults
                return .none

            case let .searchResponse(.success(response)):
                state.appResults = IdentifiedArrayOf(uniqueElements: response.map {
                    AppResultFeature.State(
                        app: $0,
                        downloadApp: .init(purchaseLabelPosition: .vertial)
                    )
                })
                state.contentState = response.isEmpty ? .noResults : .appResults
                return .none

            case let .categories(.delegate(.selectCategory(category))):
                state.isSearchbarActive = true
                return .run { send in
                    await send(.searchQueryChanged(category.rawValue))
                }

            case .categories:
                return .none

            case let .searchbarFocusChanged(isActive):
                state.isSearchbarActive = isActive
                if isActive == false {
                    state.contentState = .categories
                }
                return .none

            case .path:
                return .none

            case .appResults:
                return .none
            }
        }
        .forEach(\.appResults, action: \.appResults) {
            AppResultFeature()
        }
        .forEach(\.path, action: \.path) {
            AppDetailsFeature()
        }
    }
}
