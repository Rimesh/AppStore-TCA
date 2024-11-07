//
//  AppDetailsFeature.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 06/11/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let app: AppApiModel
    }

    enum Action {}
}

struct AppDetailsView: View {
    let store: StoreOf<AppDetailsFeature>

    @Environment(\.sizeCategory) var sizeCategory
    @ScaledMetric(relativeTo: .headline)
    private var titleSpacing: CGFloat = 28

    var body: some View {
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
            AHStack(vStackAlignment: .leading) {
                GetButton(isDownloading: .constant(false))
                InAppPurchaseLabel(placement: .appDetails)
            }
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .font(.title3)
                .foregroundStyle(Color.blue)
        }
    }
}

#Preview {
    AppDetailsView(
        store:
        Store(
            initialState: AppDetailsFeature.State(app: .mock))
        {
            AppDetailsFeature()
        }
    )
}
