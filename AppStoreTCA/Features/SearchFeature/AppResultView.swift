//
//  AppResultView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import SwiftUI

struct AppResultView: View {
    private let app: AppApiModel

    public init(_ app: AppApiModel) {
        self.app = app
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                appIconView
                    .frame(width: 64, height: 64)
                    .cornerRadius(12)
                appTitleView
                Spacer()
                GetButton()
            }
            HStack {
                ratingView
                Spacer()
                developerView
                Spacer()
                genreView
            }
            .foregroundStyle(Color.secondary)
            screenshotsView
        }
        .padding(.vertical)
    }
}

extension AppResultView {
    var appIconView: some View {
        AsyncImage(url: app.artworkUrl100) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
            default:
                EmptyView()
            }
        }
    }

    var appTitleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(app.trackName)
                .lineLimit(1)
                .font(.headline)
            Text(app.artistName)
                .lineLimit(1)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }

    var ratingView: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< 5) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
            }
            Text("1.3M")
                .font(.footnote)
        }
    }

    var developerView: some View {
        HStack {
            Image(systemName: "person.crop.square")
            Text(app.sellerName)
                .lineLimit(1)
        }
        .font(.caption)
        .fontDesign(.rounded)
    }

    var genreView: some View {
        HStack {
            Text("No. \(randomNumber)")
                .font(.system(size: 8, weight: .medium, design: .rounded))
                .padding(.all, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.secondary, lineWidth: 1)
                )
            Text(app.primaryGenreName)
                .lineLimit(1)
                .font(.system(.caption, design: .rounded, weight: .medium))
        }
        .fontDesign(.rounded)
    }

    var randomNumber: Int {
        (1 ... 15).randomElement() ?? 9
    }

    var screenshotsView: some View {
        HStack {
            ForEach(app.screenshotUrls.prefix(3), id: \.self) { url in
                screenshotView(url: url)
            }
        }
    }

    @ViewBuilder
    func screenshotView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            default:
                EmptyView()
            }
        }
        .frame(height: 210)
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}
