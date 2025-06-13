//
//  RegisterView.swift
//  FinalProject
//
//  Created by 張睿恩 on 2025/6/14.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Binding var showingLogin: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo or App Title
            VStack {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("創建新帳號")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 40)
            
            // Register Form
            VStack(spacing: 16) {
                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("電子郵件")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("請輸入電子郵件", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("密碼")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SecureField("請輸入密碼", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Confirm Password Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("確認密碼")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SecureField("請再次輸入密碼", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal)
            
            // Error Message
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            // Register Button
            Button(action: {
                authViewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("註冊")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || authViewModel.isLoading)
            
            // Switch to Login
            Button(action: {
                showingLogin = true
            }) {
                Text("已有帳號？立即登入")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .onTapGesture {
            // 隱藏鍵盤
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                // Handle successful registration - this will be handled by the parent view
            }
        }
    }
}

#Preview {
    RegisterView(showingLogin: .constant(false))
        .environmentObject(AuthViewModel())
}
