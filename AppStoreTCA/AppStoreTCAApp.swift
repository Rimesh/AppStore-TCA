//
//  AppStoreTCAApp.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import ComposableArchitecture
import SwiftUI

@main
struct AppStoreTCAApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(
                    initialState: SearchFeature.State()
                ) {
                    SearchFeature()
                        ._printChanges()
                }
            )
        }
    }
}
