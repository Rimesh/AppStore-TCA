//
//  CircularProgressView.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 10/11/24.
//

import SwiftUI

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
