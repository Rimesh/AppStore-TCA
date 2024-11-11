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
        @Presents var destination: Destination.State?
    }

    enum Action {
        case searchQueryChanged(String)
        case keyboardSearchButtonTapped
        case categorySearchInitiated
        case searchResponse(Result<[AppModel], any Error>)
        case categories(CategoryFeature.Action)
        case searchbarFocusChanged(Bool)
        case path(StackAction<AppDetailsFeature.State, AppDetailsFeature.Action>)
        case appResults(IdentifiedActionOf<AppResultFeature>)
        case destination(PresentationAction<Destination.Action>)

        enum Alert: Equatable {
            case searchFailedAlertOkayButtonAction
        }
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
        Reduce { state, action in
            switch action {
            case let .searchQueryChanged(query):
                state.searchQuery = query
                if query.isEmpty {
                    state.contentState = .categories
                }
                return .none
            case .keyboardSearchButtonTapped, .categorySearchInitiated:
                guard !state.searchQuery.isEmpty else {
                    state.contentState = .noResults
                    return .cancel(id: CancelID.appSearch)
                }
                state.contentState = .loading
                return .run { [query = state.searchQuery] send in
                    await send(.searchResponse(Result { try await self.appStoreClient.search(query: query) }))
                }
                .cancellable(id: CancelID.appSearch)
            case .searchResponse(.failure):
                state.destination = .searchFailedAlert(.searchFailedAlertState(query: state.searchQuery))
                return .none
            case let .searchResponse(.success(response)):
                state.appResults = IdentifiedArrayOf(uniqueElements: response.map {
                    AppResultFeature.State(
                        app: $0,
                        downloadApp: .init(purchaseLabelPosition: .horizontal)
                    )
                })
                state.contentState = response.isEmpty ? .noResults : .appResults
                return .none
            case let .categories(.delegate(.selectCategory(category))):
                state.isSearchbarActive = false
                return .run { send in
                    await send(.searchQueryChanged(category.rawValue))
                    await send(.categorySearchInitiated)
                }
            case .categories:
                return .none
            case let .searchbarFocusChanged(isActive):
                state.isSearchbarActive = isActive
                if isActive == false {
                    state.contentState = .categories
                    state.searchQuery = ""
                }
                return .none
            case .destination(.presented(.searchFailedAlert(.searchFailedAlertOkayButtonAction))):
                state.searchQuery = ""
                state.contentState = .noResults
                return .none
            case .destination:
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
        .ifLet(\.$destination, action: \.destination)
    }
}

extension SearchFeature {
    @Reducer
    enum Destination {
        case searchFailedAlert(AlertState<SearchFeature.Action.Alert>)
    }
}

extension SearchFeature.Destination.State: Equatable {}

extension AlertState where Action == SearchFeature.Action.Alert {
    static func searchFailedAlertState(query: String) -> Self {
        Self(
            title: { TextState("Something went wrong") },
            actions: {
                ButtonState(
                    role: .none,
                    action: .searchFailedAlertOkayButtonAction
                ) {
                    TextState("Ok")
                }
            },
            message: {
                TextState("Search failed for \(query)\n Please try again later.")
            }
        )
    }
}
