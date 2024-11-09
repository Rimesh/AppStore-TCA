//
//  AppResultView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//

import SwiftUI

struct AppResultView: View {
    private let app: AppApiModel
    @State private var isDownloading = false

    @ScaledMetric(relativeTo: .caption2)
    private var ratingSize: CGFloat = 4

    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    public init(_ app: AppApiModel) {
        self.app = app
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AHStack(
                hStackAlignment: .center,
                hStackSpacing: 8,
                vStackAlignment: .leading,
                vStackSpacing: 10
            ) {
                appIconView
                    .frame(width: 64, height: 64)
                    .cornerRadius(12)
                appTitleView
                Spacer()
                AVStack(hStackSpacing: 8) {
                    GetButton(isDownloading: $isDownloading)
                    if isDownloading == false {
                        InAppPurchaseLabel(placement: .naturalHorizontal)
                    }
                }
            }
            appInsightsView
                .foregroundStyle(Color.secondary)
            screenshotsView
        }
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
                    .font(.system(size: 10))
            }
            Text("1.3M")
                .font(.system(.footnote, design: .rounded, weight: .semibold))
        }
    }

    var developerView: some View {
        HStack {
            Image(systemName: "person.crop.square")
            Text(app.sellerName)
                .lineLimit(1)
                .font(.system(.footnote, design: .rounded, weight: .semibold))
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
                .font(.system(.footnote, design: .rounded, weight: .semibold))
        }
        .fontDesign(.rounded)
    }

    @ViewBuilder
    var appInsightsView: some View {
        if dynamicTypeSize <= .xLarge {
            HStack {
                ratingView
                Spacer()
                developerView
                Spacer()
                genreView
            }
        } else if dynamicTypeSize >= .accessibility3 {
            VStack(alignment: .leading) {
                ratingView
                Spacer()
                developerView
                Spacer()
                genreView
            }
        } else {
            VStack(alignment: .leading) {
                HStack {
                    ratingView
                    Spacer()
                    developerView
                    Spacer()
                }
                genreView
            }
        }
    }

    var randomNumber: Int {
        (1 ... 15).randomElement() ?? 9
    }

    var screenshotsView: some View {
        ScreenshotsView(
            screenshotUrls: Array(app.screenshotUrls.prefix(3)),
            renderSize: .small
        )
    }
}

#Preview {
    ScrollView {
        VStack {
            AppResultView(.mock)
            AppResultView(.mock)
            AppResultView(.mock)
            AppResultView(.mock)
            AppResultView(.mock)
        }
        .padding()
    }
}
