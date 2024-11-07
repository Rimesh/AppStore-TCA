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
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 25)
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

private struct CircularProgressView: View {
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
    GetButton(isDownloading: .constant(false))
}
