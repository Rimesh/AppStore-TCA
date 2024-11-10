//
//  ScreenshotsView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 08/11/24.
//

import SwiftUI

struct ScreenshotsView: View {
    private enum Constants {
        static let landscapeHeight: CGFloat = 175
        static let portraitRenderHeightSmall: CGFloat = 210
        static let portraitRenderHeightLarge: CGFloat = 460
        static let cornerRadiusSmall: CGFloat = 12
        static let cornerRadiusLarge: CGFloat = 24
    }

    @State private var imageSize: CGSize = .zero

    private let screenshotUrls: [URL]
    private let renderSize: RenderSize

    init(screenshotUrls: [URL], renderSize: RenderSize) {
        self.screenshotUrls = screenshotUrls
        self.renderSize = renderSize
    }

    private var cornerRadius: CGFloat {
        switch renderSize {
        case .small: Constants.cornerRadiusSmall
        case .large: Constants.cornerRadiusLarge
        }
    }

    enum RenderSize {
        case small
        case large
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(screenshotUrls, id: \.self) { url in
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case let .success(image):
                            image.resizable()
                                .background(GeometryReader { geometry in
                                    Color.clear.preference(key: ImageSizeKey.self, value: geometry.size)
                                })
                                .onPreferenceChange(ImageSizeKey.self) { newValue in
                                    imageSize = newValue
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(height: getFrameHeight())
                                .cornerRadius(cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                                )
                        case .empty:
                            ProgressView()
                                .frame(
                                    width: UIScreen.main.bounds.width / 3,
                                    height: Constants.portraitRenderHeightSmall
                                )
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func getFrameHeight() -> CGFloat {
        guard imageSize.width < imageSize.height else {
            return Constants.landscapeHeight
        }

        return renderSize == .large ? Constants.portraitRenderHeightLarge : Constants.portraitRenderHeightSmall
    }
}

#Preview {
    ScreenshotsView(
        screenshotUrls: AppModel.mock.screenshotUrls, renderSize: .large
    )
}

// Preference key to pass height from GeometryReader
private struct ImageSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
