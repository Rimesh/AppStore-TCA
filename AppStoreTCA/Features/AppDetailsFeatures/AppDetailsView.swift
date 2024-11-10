//
//  AppDetailsView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//

import ComposableArchitecture
import SwiftUI

struct AppDetailsView: View {
    let store: StoreOf<AppDetailsFeature>

    @Environment(\.sizeCategory) var sizeCategory
    @ScaledMetric(relativeTo: .headline)
    private var titleSpacing: CGFloat = 28

    @ScaledMetric(relativeTo: .caption)
    private var appMetricsStackSpacing: CGFloat = 10

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                AHStack(hStackAlignment: .top,
                        vStackAlignment: .leading)
                {
                    appIcon
                    VStack(alignment: .leading) {
                        appTitleView
                        Spacer()
                            .frame(height: sizeCategory.isAccessibilityCategory ? 8 : titleSpacing)
                        downloadInfoView
                    }
                }
                .padding()
                appMetricsView
                ScreenshotsView(
                    screenshotUrls: store.app.screenshotUrls,
                    renderSize: .large
                )
                .padding()
                Divider()
                    .padding(.horizontal)
                appDescriptionView
                    .padding(.horizontal)
                Spacer()
            }
        }
    }

    private var appIcon: some View {
        AsyncImage(url: store.app.artworkUrl512) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            default:
                EmptyView()
            }
        }
        .frame(width: 120, height: 120)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
    }

    private var appTitleView: some View {
        VStack(alignment: .leading) {
            Text(store.app.trackName)
                .font(.title2)
                .fontWeight(.medium)
            Text(store.app.sellerName)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }

    private var downloadInfoView: some View {
        HStack(alignment: .center) {
            DownloadAppView(
                store: store.scope(
                    state: \.downloadApp,
                    action: \.downloadApp
                )
            )
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .font(.title3)
                .foregroundStyle(Color.blue)
        }
    }

    private var appMetricsView: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack(spacing: .zero) {
                    ratingStack
                    ageRestrictionStack
                    supportedLanguagesStack
                    appSizeStack
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var ratingStack: some View {
        AppMetricVStack(
            topView: { Text("RATINGS") },
            middleView: { Text("3.8") },
            bottomView: {
                HStack(spacing: 0) {
                    Image(systemName: "star")
                    Image(systemName: "star")
                }
            }
        )
    }

    private var ageRestrictionStack: some View {
        AppMetricVStack(
            topView: { Text("AGE") },
            middleView: { Text(store.app.contentAdvisoryRating) },
            bottomView: { Text("Years Old") }
        )
    }

    private var supportedLanguagesStack: some View {
        AppMetricVStack(
            topView: { Text("LANGUAGE") },
            middleView: { Text("EN") },
            bottomView: { Text("+9 More") }
        )
    }

    private var appSizeStack: some View {
        AppMetricVStack(
            topView: { Text("SIZE") },
            middleView: { Text("3,21") },
            bottomView: { Text("MB") },
            trailingSeparatorHidden: true
        )
    }

    private var appDescriptionView: some View {
        ZStack {
            Text(store.app.description)
                .lineLimit(store.showAppDescription ? nil : 3)
            if store.showAppDescription == false {
                Button {
                    store.send(.descriptionButtonTapped)
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            LeadingGradientLabel("more")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AppDetailsView(
        store:
        Store(
            initialState: AppDetailsFeature.State(
                app: .mock,
                downloadApp: DownloadFeature.State(purchaseLabelPosition: .vertical)
            )
        ) {
            AppDetailsFeature()
        }
    )
}
