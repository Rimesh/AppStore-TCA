//
//  AppStoreClient.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import ComposableArchitecture
import Foundation

// MARK: - API client interface

@DependencyClient
struct AppStoreClient {
    var search: @Sendable (_ query: String) async throws -> [AppApiModel]
}

extension AppStoreClient: TestDependencyKey {
    static let previewValue = Self(
        search: { _ in .mock }
    )

    static let testValue = Self()
}

extension DependencyValues {
    var appStoreClient: AppStoreClient {
        get { self[AppStoreClient.self] }
        set { self[AppStoreClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension AppStoreClient: DependencyKey {
    static let liveValue = AppStoreClient(
        search: { query in
            var components = URLComponents(string: "https://itunes.apple.com/search")!
            components.queryItems = [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "media", value: "software"),
            ]
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            let searchResults = try JSONDecoder().decode(SearchApiModel.self, from: data)
            return searchResults.results
        }
    )
}

// MARK: - Mock data

extension Array where Element == AppApiModel {
    static let mock = [
        AppApiModel(
            trackId: 1,
            trackName: "Test App",
            artistId: 123,
            artistName: "App Artist",
            bundleId: "com.test.app",
            releaseDate: "release date",
            sellerName: "Test Seller",
            version: "version test",
            releaseNotes: "release notes",
            currentVersionReleaseDate: "version release date",
            description: "description",
            fileSizeBytes: "123",
            formattedPrice: "free",
            contentAdvisoryRating: "4+",
            trackContentRating: "4+",
            averageUserRating: 4.9,
            userRatingCount: 123
        ),
    ]
}
