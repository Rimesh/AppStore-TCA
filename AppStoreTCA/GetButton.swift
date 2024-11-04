//
//  GetButton.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import SwiftUI

struct GetButton: View {
    @State private var isDownloading = false
    @State private var progress: CGFloat = 0.0

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                toggleDownloading()
            }) {
                if isDownloading {
                    CircularProgressView(progress: progress)
                        .frame(width: 32, height: 32)
                } else {
                    VStack {
                        Text("Get")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 25)
                            .background {
                                Capsule()
                                    .foregroundStyle(Color.black.opacity(0.1))
                            }
                        Text("In-App Purchases")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
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

struct CircularProgressView: View {
    var progress: CGFloat

    var body: some View {
        ZStack {
            Color.blue
                .frame(width: 8, height: 8)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.blue, lineWidth: 3)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut, value: progress)
        }
    }
}

#Preview() {
    GetButton()
}
