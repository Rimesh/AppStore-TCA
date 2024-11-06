//
//  SearchView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Search {
    @ObservableState
    struct State: Equatable {
        var results: [AppApiModel] = []
        var searchQuery = ""
        var categories = CategoryFeature.State()
        var isSearchbarActive = false
        var isLoading = false
    }

    enum Action {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[AppApiModel], any Error>)
        case categories(CategoryFeature.Action)
        case searchbarFocusChanged(Bool)
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
            }
        }
    }
}

struct SearchView: View {
    @Bindable var store: StoreOf<Search>

    var body: some View {
        NavigationStack {
            contentView
                .padding()
                .navigationTitle("Search")
        }
        .searchable(
            text: $store.searchQuery.sending(\.searchQueryChanged),
            isPresented: $store.isSearchbarActive.sending(\.searchbarFocusChanged),
            prompt: "Apps, Games and more"
        )
        .overlay { overlayView }
        .task(id: store.searchQuery) {
            do {
                try await Task.sleep(for: .milliseconds(500))
                await store.send(.searchQueryChangeDebounced).finish()
            } catch {}
        }
    }

    @ViewBuilder
    var contentView: some View {
        List {
            ForEach(store.results) { app in
                AppResultView(app)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            if store.results.isEmpty && store.isSearchbarActive == false {
                CategoryGridView(store: store.scope(state: \.categories, action: \.categories))
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
    }

    @ViewBuilder
    var overlayView: some View {
        if store.isLoading {
            ProgressView()
        } else if store.isSearchbarActive && store.results.isEmpty {
            ContentUnavailableView.search(text: store.searchQuery)
        }
    }
}
