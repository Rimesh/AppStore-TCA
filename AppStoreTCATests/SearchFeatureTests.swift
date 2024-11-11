//
//  SearchFeatureTests.swift
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
        await store.send(.keyboardSearchButtonTapped) {
            $0.contentState = .loading
        }
        await store.receive(\.searchResponse) {
            $0.appResults = IdentifiedArrayOf(
                uniqueElements: [AppModel].mock.map {
                    AppResultFeature.State(
                        app: $0,
                        downloadApp: .init(purchaseLabelPosition: .horizontal)
                    )
                }
            )
            $0.contentState = .appResults
        }
    }

    @Test func clearSearchBar() async {
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
            $0.contentState = .categories
        }
    }

    @Test func dismissSearchbar() async {
        let store = TestStore(
            initialState: SearchFeature.State(
                searchQuery: "music",
                isSearchbarActive: true
            )
        ) {
            SearchFeature()
        }
        await store.send(.searchbarFocusChanged(false)) {
            $0.isSearchbarActive = false
            $0.searchQuery = ""
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
        await store.receive(\.categorySearchInitiated) {
            $0.contentState = .loading
        }
        await store.receive(\.searchResponse) {
            $0.appResults = IdentifiedArrayOf(
                uniqueElements: [AppModel].mock.map {
                    AppResultFeature.State(
                        app: $0,
                        downloadApp: .init(purchaseLabelPosition: .horizontal)
                    )
                }
            )
            $0.contentState = .appResults
        }
    }

    @Test func navigateToAppDetailsAndDismiss() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        }
        let appDetailState = AppDetailsFeature.State(
            app: .mock,
            downloadApp: .init(purchaseLabelPosition: .vertical)
        )

        // Test Push Navigation
        await store.send(.path(.push(id: 0, state: appDetailState))) {
            $0.path.append(appDetailState)
        }

        // test Pop Navigation
        await store.send(.path(.popFrom(id: 0))) {
            _ = $0.path.popLast()
        }
    }

    @Test
    func showAlertWhenSearchFails() async throws {
        enum SearchError: Error {
            case searchFailed
        }
        let store = TestStore(
            initialState: SearchFeature.State()
        ) {
            SearchFeature()
        } withDependencies: { dependencies in
            dependencies.appStoreClient.search = { @Sendable _ in throw SearchError.searchFailed }
        }

        await store.send(.searchQueryChanged("unknownApps")) {
            $0.searchQuery = "unknownApps"
        }
        await store.send(.keyboardSearchButtonTapped) {
            $0.contentState = .loading
        }
        // Show alert
        await store.receive(\.searchResponse) {
            $0.destination = .searchFailedAlert(.searchFailedAlertState(query: $0.searchQuery))
        }
        // Dismiss alert when user taps ok
        await store.send(.destination(.presented(.searchFailedAlert(.searchFailedAlertOkayButtonAction)))) {
            $0.searchQuery = ""
            $0.contentState = .noResults
            $0.destination = nil
        }
    }
}
