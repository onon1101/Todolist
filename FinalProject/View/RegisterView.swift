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
    
    // 驗證狀態
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var hasAttemptedSubmit = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "註冊失敗"
    
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
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = hasAttemptedSubmit ? "請確認密碼" : nil
        } else if password != confirmPassword {
            confirmPasswordError = "密碼不匹配"
        } else {
            confirmPasswordError = nil
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
    
    private func validateConfirmPasswordRealTime() {
        if !confirmPassword.isEmpty && password != confirmPassword {
            confirmPasswordError = "密碼不匹配"
        } else if confirmPassword.isEmpty || password == confirmPassword {
            confirmPasswordError = nil
        }
    }
    
    private func validateAll() {
        validateEmail()
        validatePassword()
        validateConfirmPassword()
    }
    
    private func clearValidationErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        hasAttemptedSubmit = false
    }
    
    private func showErrorAlert(_ message: String) {
        alertTitle = "註冊失敗"
        alertMessage = message
        showAlert = true
    }
    
    // 計算按鈕是否應該被禁用
    private var isButtonDisabled: Bool {
        return email.isEmpty || 
               password.isEmpty || 
               confirmPassword.isEmpty ||
               emailError != nil || 
               passwordError != nil || 
               confirmPasswordError != nil ||
               authViewModel.isLoading
    }
    
    var body: some View {
        ZStack {
            // 背景漸變
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.1),
                    Color.blue.opacity(0.1),
                    Color.teal.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 40)
                    
                    // Logo 和標題區域
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.teal]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("加入我們")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("創建您的 TodoList 帳號")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 註冊表單卡片
                    VStack(spacing: 24) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.green)
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
                                            (email.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.5)), 
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
                                    .foregroundColor(.green)
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
                                            (password.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.5)), 
                                            lineWidth: passwordError != nil ? 2 : 1
                                        )
                                )
                                .onChange(of: password) { _ in
                                    validatePasswordRealTime()
                                    if !confirmPassword.isEmpty {
                                        validateConfirmPasswordRealTime()
                                    }
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
                
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lock.shield")
                                    .foregroundColor(.green)
                                    .frame(width: 20)
                                Text("確認密碼")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            SecureField("請再次輸入您的密碼", text: $confirmPassword)
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
                                            confirmPasswordError != nil ? Color.red : 
                                            (confirmPassword.isEmpty ? Color.gray.opacity(0.3) : 
                                             (password == confirmPassword && !confirmPassword.isEmpty ? Color.green : Color.green.opacity(0.5))), 
                                            lineWidth: confirmPasswordError != nil ? 2 : 1
                                        )
                                )
                                .onChange(of: confirmPassword) { _ in
                                    validateConfirmPasswordRealTime()
                                }
                            
                            if let confirmPasswordError = confirmPasswordError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(confirmPasswordError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.leading, 4)
                            } else if !confirmPassword.isEmpty && password == confirmPassword {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("密碼匹配")
                                        .font(.caption)
                                        .foregroundColor(.green)
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
                    
                    // 註冊按鈕
                    Button(action: {
                        hasAttemptedSubmit = true
                        validateAll()
                        
                        if emailError == nil && passwordError == nil && confirmPasswordError == nil {
                            authViewModel.clearError()
                            authViewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
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
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.title3)
                                Text("創建帳號")
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
                                gradient: Gradient(colors: [Color.green, Color.teal]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: isButtonDisabled ? Color.clear : Color.green.opacity(0.3), 
                            radius: 8, x: 0, y: 4
                        )
                        .opacity(isButtonDisabled ? 0.6 : 1.0)
                    }
                    .disabled(isButtonDisabled)
                    .padding(.horizontal, 20)
                    .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
                    
                    // 登入連結
                    HStack {
                        Text("已有帳號？")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            clearValidationErrors()
                            showingLogin = true
                        }) {
                            Text("立即登入")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
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
                // Clear form when registration is successful
                email = ""
                password = ""
                confirmPassword = ""
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
                // 清除 Firebase 錯誤訊息
                authViewModel.clearError()
            }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    RegisterView(showingLogin: .constant(false))
        .environmentObject(AuthViewModel())
}
