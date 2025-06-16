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
    
    // 驗證狀態
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var hasAttemptedSubmit = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "登入失敗"
    @State private var showForgotPassword = false
    
    // 驗證方法
    private func validateEmail() {
        if email.isEmpty {
            emailError = hasAttemptedSubmit ? "請輸入電子郵件" : nil
        } else if !authViewModel.isValidEmail(email) {
            emailError = "電子郵件格式不正確"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = hasAttemptedSubmit ? "請輸入密碼" : nil
        } else if !authViewModel.isValidPassword(password) {
            passwordError = "密碼至少需要6個字符"
        } else {
            passwordError = nil
        }
    }
    
    // 即時驗證（不顯示空欄位錯誤）
    private func validateEmailRealTime() {
        if !email.isEmpty && !authViewModel.isValidEmail(email) {
            emailError = "電子郵件格式不正確"
        } else if email.isEmpty || authViewModel.isValidEmail(email) {
            emailError = nil
        }
    }
    
    private func validatePasswordRealTime() {
        if !password.isEmpty && !authViewModel.isValidPassword(password) {
            passwordError = "密碼至少需要6個字符"
        } else if password.isEmpty || authViewModel.isValidPassword(password) {
            passwordError = nil
        }
    }
    
    private func validateAll() {
        validateEmail()
        validatePassword()
    }
    
    private func clearValidationErrors() {
        emailError = nil
        passwordError = nil
        hasAttemptedSubmit = false
    }
    
    private func showErrorAlert(_ message: String) {
        alertTitle = "錯誤"
        alertMessage = message
        showAlert = true
    }
    
    // 計算按鈕是否應該被禁用
    private var isButtonDisabled: Bool {
        return email.isEmpty || 
               password.isEmpty || 
               emailError != nil || 
               passwordError != nil || 
               authViewModel.isLoading
    }
    
    var body: some View {
        ZStack {
            // 背景漸變
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color.pink.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 60)
                    
                    // Logo 和標題區域
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "checklist")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("歡迎回來")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("登入您的 TodoList 帳號")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 登入表單卡片
                    VStack(spacing: 24) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("電子郵件")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            TextField("請輸入您的電子郵件", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            emailError != nil ? Color.red : 
                                            (email.isEmpty ? Color.gray.opacity(0.3) : Color.blue.opacity(0.5)), 
                                            lineWidth: emailError != nil ? 2 : 1
                                        )
                                )
                                .onChange(of: email) { _ in
                                    validateEmailRealTime()
                                }
                            
                            if let emailError = emailError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(emailError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 4)
                            }
                        }
                
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("密碼")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            SecureField("請輸入您的密碼", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            passwordError != nil ? Color.red : 
                                            (password.isEmpty ? Color.gray.opacity(0.3) : Color.blue.opacity(0.5)), 
                                            lineWidth: passwordError != nil ? 2 : 1
                                        )
                                )
                                .onChange(of: password) { _ in
                                    validatePasswordRealTime()
                                }
                            
                            if let passwordError = passwordError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(passwordError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 20)
                    
                    // 登入按鈕
                    Button(action: {
                        hasAttemptedSubmit = true
                        validateAll()
                        
                        if emailError == nil && passwordError == nil {
                            authViewModel.clearError()
                            authViewModel.signIn(email: email, password: password)
                        } else {
                            showErrorAlert("請修正上述錯誤後再試")
                        }
                    }) {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title3)
                                Text("登入")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            // 根據按鈕狀態改變背景
                            isButtonDisabled ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: isButtonDisabled ? Color.clear : Color.blue.opacity(0.3), 
                            radius: 8, x: 0, y: 4
                        )
                        .opacity(isButtonDisabled ? 0.6 : 1.0)
                    }
                    .disabled(isButtonDisabled)
                    .padding(.horizontal, 20)
                    .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
                    
                    // 忘記密碼和註冊連結
                    VStack(spacing: 16) {
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("忘記密碼？")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("還沒有帳號？")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                clearValidationErrors()
                                showingLogin = false
                            }) {
                                Text("立即註冊")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            // 隱藏鍵盤
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                // Clear form when login is successful
                email = ""
                password = ""
                clearValidationErrors()
            }
        }
        .onChange(of: authViewModel.errorMessage) { errorMessage in
            // 當 Firebase 返回錯誤時顯示彈出訊息
            if !errorMessage.isEmpty && !authViewModel.isLoading {
                showErrorAlert(errorMessage)
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("確定", role: .cancel) {
                // 清除 Firebase 錯誤和成功訊息
                authViewModel.clearError()
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView(isPresented: $showForgotPassword)
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    LoginView(showingLogin: .constant(true))
        .environmentObject(AuthViewModel())
}
