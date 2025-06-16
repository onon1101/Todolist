//
//  AuthViewModel.swift
//  FinalProject
//
//  Created by 張睿恩 on 2025/6/14.
//

import SwiftUI
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var isLoading = false
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func signIn(email: String, password: String) {
        guard isValidEmail(email) else {
            errorMessage = "請輸入有效的電子郵件地址"
            return
        }
        
        guard isValidPassword(password) else {
            errorMessage = "密碼至少需要6個字符"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = self?.translateFirebaseError(error) ?? error.localizedDescription
                } else {
                    self?.currentUser = result?.user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signUp(email: String, password: String, confirmPassword: String) {
        guard isValidEmail(email) else {
            errorMessage = "請輸入有效的電子郵件地址"
            return
        }
        
        guard isValidPassword(password) else {
            errorMessage = "密碼至少需要6個字符"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "密碼不匹配"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = self?.translateFirebaseError(error) ?? error.localizedDescription
                } else {
                    self?.currentUser = result?.user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isAuthenticated = false
                self.errorMessage = ""
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func resetPassword(email: String) {
        isLoading = true
        errorMessage = ""
        successMessage = ""
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = self?.translateFirebaseError(error) ?? error.localizedDescription
                } else {
                    self?.successMessage = "密碼重設郵件已發送到您的信箱"
                }
            }
        }
    }
    
    func clearError() {
        errorMessage = ""
        successMessage = ""
    }
    
    // MARK: - Validation Functions
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    // MARK: - Helper Functions
    private func translateFirebaseError(_ error: Error) -> String {
        guard let errorCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }
        
        switch errorCode {
        case .invalidEmail:
            return "電子郵件格式不正確"
        case .userNotFound:
            return "找不到此用戶"
        case .wrongPassword:
            return "密碼錯誤"
        case .emailAlreadyInUse:
            return "此電子郵件已被使用"
        case .weakPassword:
            return "密碼強度不足"
        case .networkError:
            return "網路連接錯誤"
        case .userDisabled:
            return "此帳戶已被停用"
        case .tooManyRequests:
            return "請求次數過多，請稍後再試"
        default:
            return error.localizedDescription
        }
    }
}
