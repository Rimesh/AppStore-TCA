//
//  AppModel.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import Foundation

struct AppModel: Decodable, Identifiable, Equatable {
    var id: Int { trackId }

    let trackId: Int
    let trackName: String
    let artistId: Int
    let artistName: String
    let bundleId: String
    let releaseDate: String
    var releaseNotes: String?
    let sellerName: String
    let version: String
    let currentVersionReleaseDate: String
    let description: String
    let fileSizeBytes: String
    var formattedPrice: String? = "Free"
    let contentAdvisoryRating: String
    let trackContentRating: String
    let averageUserRating: Double
    let userRatingCount: Int
    let artworkUrl512: URL
    let artworkUrl100: URL
    let artworkUrl60: URL
    let primaryGenreName: String
    let screenshotUrls: [URL]
}
