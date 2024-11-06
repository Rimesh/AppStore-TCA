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
struct SearchAppTests {
    @Test
    func searchAndClearQuesry() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            Search()
        } withDependencies: { dependencies in
            dependencies.appStoreClient.search = { @Sendable _ in .mock }
        }

        await store.send(.searchQueryChanged("R")) {
            $0.searchQuery = "R"
        }
        await store.send(.searchQueryChangeDebounced)
        await store.receive(\.searchResponse) {
            $0.results = .mock
        }
        await store.send(.searchQueryChanged("")) {
            $0.searchQuery = ""
            $0.results = []
        }
    }
}
