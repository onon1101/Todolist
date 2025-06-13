//
//  LoginView.swift
//  FinalProject
//
//  Created by 張睿恩 on 2025/6/14.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @Binding var showingLogin: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo or App Title
            VStack {
                Image(systemName: "checklist")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("TodoList")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 40)
            
            // Login Form
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
            }
            .padding(.horizontal)
            
            // Error Message
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            // Login Button
            Button(action: {
                authViewModel.signIn(email: email, password: password)
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("登入")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
            
            // Forgot Password
            Button(action: {
                if !email.isEmpty {
                    authViewModel.resetPassword(email: email)
                } else {
                    authViewModel.errorMessage = "請先輸入您的電子郵件地址"
                }
            }) {
                Text("忘記密碼？")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
            
            // Switch to Register
            Button(action: {
                showingLogin = false
            }) {
                Text("還沒有帳號？立即註冊")
                    .font(.caption)
                    .foregroundColor(.blue)
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
                // Handle successful login - this will be handled by the parent view
            }
        }
    }
}

#Preview {
    LoginView(showingLogin: .constant(true))
        .environmentObject(AuthViewModel())
}
