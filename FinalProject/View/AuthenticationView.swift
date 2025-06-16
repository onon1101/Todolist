//
//  AuthenticationView.swift
//  FinalProject
//
//  Created by 張睿恩 on 2025/6/14.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogin = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if showingLogin {
                    LoginView(showingLogin: $showingLogin)
                        .transition(.slide)
                } else {
                    RegisterView(showingLogin: $showingLogin)
                        .transition(.slide)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showingLogin)
            .onChange(of: showingLogin) { _ in
                // Clear any existing error messages when switching between login and register
                authViewModel.clearError()
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
}
