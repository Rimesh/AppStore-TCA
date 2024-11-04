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
    }

    enum Action {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[AppApiModel], any Error>)
    }

    @Dependency(\.appStoreClient) var appStoreClient
    private enum CancelID { case appSearch }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .searchQueryChanged(query):
                state.searchQuery = query

                // When the query is cleared we can clear the search results, but we have to make sure to
                // cancel any in-flight search requests too, otherwise we may get data coming in later.
                guard !state.searchQuery.isEmpty else {
                    state.results = []
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
                state.results = []
                return .none

            case let .searchResponse(.success(response)):
                state.results = response
                return .none
            }
        }
    }
}

struct SearchView: View {
    @Bindable var store: StoreOf<Search>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.results) { app in
                    appView(app)
                }
            }
            .navigationTitle("Search")
        }
        .searchable(
            text: $store.searchQuery.sending(\.searchQueryChanged),
            prompt: "Apps, Games and more"
        )
        .task(id: store.searchQuery) {
            do {
                try await Task.sleep(for: .milliseconds(300))
                await store.send(.searchQueryChangeDebounced).finish()
            } catch {}
        }
    }

    @ViewBuilder
    func appView(_ model: AppApiModel) -> some View {
        Text(model.trackName)
            .font(.headline)
    }
}
