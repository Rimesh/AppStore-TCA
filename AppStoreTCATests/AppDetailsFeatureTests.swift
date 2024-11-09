//
//  AppDetailsFeatureTests.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 09/11/24.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import AppStoreTCA

@MainActor
struct AppDetailsFeatureTests {
    @Test
    func showAppDescription() async {
        let store = TestStore(initialState: AppDetailsFeature.State(app: .mock)) {
            AppDetailsFeature()
        }

        await store.send(.descriptionButtonTapped) {
            $0.showAppDescription = true
        }
    }
}
