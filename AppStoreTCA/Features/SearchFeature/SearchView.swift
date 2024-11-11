//
//  SearchView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 06/11/24.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    @Bindable var store: StoreOf<SearchFeature>

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Search")
        }
        .searchable(
            text: $store.searchQuery.sending(\.searchQueryChanged),
            isPresented: $store.isSearchbarActive.sending(\.searchbarFocusChanged),
            prompt: "Apps, Games and more"
        )
        .onSubmit(of: .search) {
            Task {
                await store.send(.keyboardSearchButtonTapped).finish()
            }
        }
        .alert(
            $store.scope(
                state: \.destination?.searchFailedAlert,
                action: \.destination.searchFailedAlert
            )
        )
    }

    @ViewBuilder
    private var contentView: some View {
        switch store.contentState {
        case .noResults:
            ContentUnavailableView.search(text: store.searchQuery)
        case .categories:
            CategoryGridView(store: store.scope(state: \.categories, action: \.categories))
                .padding()
        case .appResults:
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ScrollView(.vertical) {
                    ForEach(store.scope(state: \.appResults, action: \.appResults)) { store in
                        NavigationLink(
                            state: AppDetailsFeature.State(
                                app: store.app,
                                downloadApp: store.downloadApp
                            )
                        ) {
                            AppResultView(store: store)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
            } destination: { store in
                AppDetailsView(store: store)
            }
        case .loading:
            ProgressView()
        }
    }
}
