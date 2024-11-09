//
//  SearchAppsTests.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 05/11/24.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import AppStoreTCA

@MainActor
struct SearchFeatureTests {
    @Test
    func searchAnyApp() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: { dependencies in
            dependencies.appStoreClient.search = { @Sendable _ in .mock }
        }

        await store.send(.searchbarFocusChanged(true)) {
            $0.isSearchbarActive = true
        }

        await store.send(.searchQueryChanged("R")) {
            $0.searchQuery = "R"
        }
        await store.send(.searchQueryChangeDebounced) {
            $0.contentState = .loading
        }
        await store.receive(\.searchResponse) {
            $0.results = .mock
            $0.contentState = .results(.mock)
        }
    }

    @Test func clearSearchBar() async throws {
        let store = TestStore(
            initialState: SearchFeature.State(
                searchQuery: "music",
                isSearchbarActive: true
            )
        ) {
            SearchFeature()
        }

        await store.send(.searchQueryChanged("")) {
            $0.searchQuery = ""
            $0.contentState = .noResults
        }
        await store.send(.searchbarFocusChanged(false)) {
            $0.isSearchbarActive = false
            $0.contentState = .categories
        }
    }

    @Test func selectCategory() async throws {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: { dependencies in
            dependencies.appStoreClient.search = { @Sendable _ in .mock }
        }
        await store.send(.categories(.categoryButtonTapped(.music)))
        await store.receive(\.categories.delegate.selectCategory, .music) {
            $0.isSearchbarActive = true
        }
        await store.receive(\.searchQueryChanged, "music") {
            $0.searchQuery = "music"
        }
    }
}
