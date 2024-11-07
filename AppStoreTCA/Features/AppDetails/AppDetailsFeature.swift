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

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                appIcon
                VStack(alignment: .leading) {
                    appTitleView
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
        .cornerRadius(26)
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
        .background {
            Color.yellow
        }
    }

    private var downloadInfoView: some View {
        HStack(alignment: .bottom) {
            GetButton(isDownloading: .constant(false))
            InAppPurchaseLabel(placement: .appDetails)
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
