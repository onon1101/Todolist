//
//  LoadingView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/6/8.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "arrow.2.circlepath.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 0 : 360))
                    .foregroundColor(Color.gray.opacity(0.9))
                    .animation(
                        .linear(duration: 1).repeatForever(autoreverses: false),
                        value: isAnimating)
                Text("Loading...")
                    .foregroundColor(.black.opacity(0.8))
                    .font(.headline)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
}
