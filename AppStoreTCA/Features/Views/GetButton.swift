//
//  GetButton.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import SwiftUI

struct GetButton: View {
    @Binding private var isDownloading: Bool
    @State private var progress: CGFloat = 0.0

    @ScaledMetric(relativeTo: .title3)
    private var horizontalPadding: CGFloat = 24

    init(isDownloading: Binding<Bool>) {
        _isDownloading = isDownloading
    }

    var body: some View {
        Button(action: {
            toggleDownloading()
        }) {
            if isDownloading {
                CircularProgressView(progress: progress)
                    .frame(width: 32, height: 32)
            } else {
                Text("Get")
                    .lineLimit(1)
                    .font(.headline)
                    .minimumScaleFactor(0.75)
                    .padding(.vertical, 4)
                    .padding(.horizontal, horizontalPadding)
                    .fixedSize()
                    .foregroundColor(.blue)
                    .background {
                        Capsule()
                            .foregroundStyle(Color.gray.opacity(0.25))
                    }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(minWidth: 80)
    }

    private func toggleDownloading() {
        if isDownloading {
            isDownloading = false
        } else {
            isDownloading = true
            progress = 0.0

            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if progress < 1.0 {
                    withAnimation(.linear(duration: 0.1)) {
                        progress += 0.02
                    }
                } else {
                    timer.invalidate()
                    isDownloading = false
                    progress = 0.0
                }
            }
        }
    }
}

#Preview() {
    GetButton(isDownloading: .constant(false))
}
