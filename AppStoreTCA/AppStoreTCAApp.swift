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
//            DownloadAppView(
//                store: Store(
//                    initialState: DownloadFeature.State(
//                        status: .downloadable,
//                        purchaseLabelPosition: .horizontal),
//                    reducer: { DownloadFeature()._printChanges() }
//                )
//            )
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
