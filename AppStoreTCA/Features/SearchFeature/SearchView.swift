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
