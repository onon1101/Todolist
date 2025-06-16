//
//  ForgotPasswordView.swift
//  FinalProject
//
//  Created by 張睿恩 on 2025/6/14.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @Binding var isPresented: Bool
    
    // 驗證狀態
    @State private var emailError: String? = nil
    @State private var hasAttemptedSubmit = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "錯誤"
    
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
    
    // 即時驗證（不顯示空欄位錯誤）
    private func validateEmailRealTime() {
        if !email.isEmpty && !authViewModel.isValidEmail(email) {
            emailError = "電子郵件格式不正確"
        } else if email.isEmpty || authViewModel.isValidEmail(email) {
            emailError = nil
        }
    }
    
    private func clearValidationErrors() {
        emailError = nil
        hasAttemptedSubmit = false
    }
    
    private func showErrorAlert(_ message: String) {
        alertTitle = "錯誤"
        alertMessage = message
        showAlert = true
    }
    
    private func showSuccessAlert(_ message: String) {
        alertTitle = "成功"
        alertMessage = message
        showAlert = true
    }
    
    // 計算按鈕是否應該被禁用
    private var isButtonDisabled: Bool {
        return email.isEmpty || 
               emailError != nil || 
               authViewModel.isLoading
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景漸變
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.1),
                        Color.yellow.opacity(0.1),
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
                                            gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "key.fill")
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text("重設密碼")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("輸入您的電子郵件地址\n我們將發送重設密碼的連結給您")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // 忘記密碼表單卡片
                        VStack(spacing: 24) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.orange)
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
                                                (email.isEmpty ? Color.gray.opacity(0.3) : Color.orange.opacity(0.5)), 
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
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal, 20)
                        
                        // 發送重設密碼按鈕
                        Button(action: {
                            hasAttemptedSubmit = true
                            validateEmail()
                            
                            if emailError == nil {
                                authViewModel.clearError()
                                authViewModel.resetPassword(email: email)
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
                                    Image(systemName: "paperplane.fill")
                                        .font(.title3)
                                    Text("發送重設連結")
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
                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: isButtonDisabled ? Color.clear : Color.orange.opacity(0.3), 
                                radius: 8, x: 0, y: 4
                            )
                            .opacity(isButtonDisabled ? 0.6 : 1.0)
                        }
                        .disabled(isButtonDisabled)
                        .padding(.horizontal, 20)
                        .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
                        
                        // 返回登入連結
                        Button(action: {
                            clearValidationErrors()
                            isPresented = false
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .font(.caption)
                                Text("返回登入")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.orange)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        clearValidationErrors()
                        isPresented = false
                    }
                    .foregroundColor(.orange)
                }
            }
        }
        .onTapGesture {
            // 隱藏鍵盤
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: authViewModel.errorMessage) { errorMessage in
            // 當 Firebase 返回錯誤時顯示彈出訊息
            if !errorMessage.isEmpty && !authViewModel.isLoading {
                showErrorAlert(errorMessage)
            }
        }
        .onChange(of: authViewModel.successMessage) { successMessage in
            // 當有成功訊息時顯示彈出訊息
            if !successMessage.isEmpty && !authViewModel.isLoading {
                showSuccessAlert(successMessage)
                // 成功發送後可以選擇自動關閉頁面
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isPresented = false
                }
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
    }
}

#Preview {
    ForgotPasswordView(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
