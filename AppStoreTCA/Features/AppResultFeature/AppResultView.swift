//
//  AppResultView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import ComposableArchitecture
import SwiftUI

struct AppResultView: View {
    let store: StoreOf<AppResultFeature>

    @ScaledMetric(relativeTo: .caption2)
    private var ratingSize: CGFloat = 4
    @ScaledMetric(relativeTo: .footnote)
    private var genreSize: CGFloat = 8
    @ScaledMetric(relativeTo: .footnote)
    private var genrePadding: CGFloat = 2

    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AHStack(
                hStackAlignment: .center,
                hStackSpacing: 8,
                vStackAlignment: .leading,
                vStackSpacing: 10
            ) {
                appIconView
                appTitleView
                Spacer()
                DownloadAppView(
                    store: store.scope(state: \.downloadApp, action: \.downloadApp)
                )
            }
            appInsightsView
                .foregroundStyle(Color.secondary)
            screenshotsView
        }
    }
}

private extension AppResultView {
    var appIconView: some View {
        AsyncImage(url: store.app.artworkUrl100) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case let .success(image):
                image.resizable()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                    )
            default:
                EmptyView()
            }
        }
        .frame(width: 64, height: 64)
    }

    var appTitleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.app.trackName)
                .lineLimit(1)
                .font(.headline)
            Text(store.app.artistName)
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
            Text(store.app.sellerName)
                .lineLimit(1)
                .font(.system(.footnote, design: .rounded, weight: .semibold))
        }
        .font(.caption)
        .fontDesign(.rounded)
    }

    var genreView: some View {
        HStack {
            Text("No. \(randomNumber)")
                .font(.system(size: genreSize, weight: .medium, design: .rounded))
                .padding(.all, genrePadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.secondary, lineWidth: 1)
                )
            Text(store.app.primaryGenreName)
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
            screenshotUrls: Array(store.app.screenshotUrls.prefix(3)),
            renderSize: .small
        )
    }
}

#Preview {
    ScrollView {
        VStack {
            AppResultView(
                store: .init(
                    initialState: AppResultFeature.State(
                        app: .mock,
                        downloadApp: DownloadFeature.State(
                            purchaseLabelPosition: .vertical
                        )
                    ),
                    reducer: {
                        AppResultFeature()
                    }
                )
            )
            AppResultView(
                store: .init(
                    initialState: AppResultFeature.State(
                        app: .mock,
                        downloadApp: DownloadFeature.State(
                            purchaseLabelPosition: .vertical
                        )
                    ),
                    reducer: {
                        AppResultFeature()
                    }
                )
            )
            AppResultView(
                store: .init(
                    initialState: AppResultFeature.State(
                        app: .mock,
                        downloadApp: DownloadFeature.State(
                            purchaseLabelPosition: .vertical
                        )
                    ),
                    reducer: {
                        AppResultFeature()
                    }
                )
            )
        }
        .padding()
    }
}
