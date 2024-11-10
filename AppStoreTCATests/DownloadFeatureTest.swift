//
//  DownloadFeatureTest.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import AppStoreTCA

@MainActor
struct DownloadFeatureTests {
    @Test
    func startDownloadCompleteAfterFiveSeconds() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: DownloadFeature.State(
                status: .downloadable,
                purchaseLabelPosition: .horizontal
            ), reducer: { DownloadFeature() },
            withDependencies: {
                $0.continuousClock = clock
            }
        )

        await store.send(.downloadButtonTapped) {
            $0.status = .downloading(progress: 0.0)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed) {
            $0.status = .downloading(progress: 0.2)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed) {
            $0.status = .downloading(progress: 0.4)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed) {
            $0.status = .downloading(progress: 0.6)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed) {
            $0.status = .downloading(progress: 0.8)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed) {
            $0.status = .downloading(progress: 1.0)
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.downloadProgressed)
        await store.receive(.downloadCompleted) {
            $0.status = .downloaded
        }
    }
}
