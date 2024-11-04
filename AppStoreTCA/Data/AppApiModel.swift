//
//  AppApiModel.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import Foundation

struct AppApiModel: Decodable, Identifiable, Equatable {
    var id: Int { trackId }

    let trackId: Int
    let trackName: String
    let artistId: Int
    let artistName: String
    let bundleId: String
    let releaseDate: String
    let sellerName: String
    let version: String
    let releaseNotes: String
    let currentVersionReleaseDate: String
    let description: String
    let fileSizeBytes: String
    let formattedPrice: String
    let contentAdvisoryRating: String
    let trackContentRating: String
    let averageUserRating: Double
    let userRatingCount: Int
}
