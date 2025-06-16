//
//  AboutView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AboutView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .padding()
                            .background(Circle().fill(Color.black))
                            .foregroundStyle(.white)
                        
                        Text(authViewModel.currentUser?.email ?? "使用者")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("已登入")
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 16)
                    .padding(.horizontal)
                    
                    VStack(spacing: 24) {
                        RowItem(icon: "gear", title: "帳號設定")
                        RowItem(icon: "questionmark.circle", title: "尋求協助")
                        RowItem(icon: "info.circle", title: "關於我們")
                        RowItem(icon: "lock.shield", title: "隱私")
                        Divider()
                        RowItem(icon: "rectangle.portrait.and.arrow.right", title: "登出")
                            .onTapGesture {
                                authViewModel.signOut()
                            }
                            .foregroundColor(.orange)
                        RowItem(icon: "trash", title: "清除所有資料")
                            .onTapGesture {
                                deleteAllTasks()
                            }
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("個人簡介")
        }
    }
     func deleteAllTasks() {
        // 檢查用戶是否已登入
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("❌ 用戶未登入")
            return
        }
        
        let db = Firestore.firestore()
        // 只刪除屬於當前用戶的任務
        db.collection("tasks").whereField("userId", isEqualTo: currentUserId).getDocuments { snapshot, error in
            if let error = error {
                print("❌ 無法取得資料：\(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                db.collection("tasks").document(document.documentID).delete { error in
                    if let error = error {
                        print("❌ 刪除失敗：\(error.localizedDescription)")
                    } else {
                        print("✅ 刪除文件：\(document.documentID)")
                    }
                }
            }
        }
    }
}

struct RowItem: View {
    let icon: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
            Text(title)
                .font(.title3)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}




struct DetatilView: View {
    var body: some View {
        Text("test")
    }
}



#Preview {
    AboutView()
}
