//
//  HomeView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct HomeView: View {
    @State private var page = 0
    @State private var searchText = ""
    @State private var tasks: [TaskItem] = []
    var body: some View {

        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {

                    let reversedIndices = tasks.indices.reversed()
                    ForEach(Array(reversedIndices), id: \.self) { i in
                        
                        VStack(spacing: 0) {
                            Component(task: tasks[i]
                            , onDelete: {
                                let db = Firestore.firestore()
                                let taskID = tasks[i].id.uuidString
                                db.collection("tasks").whereField("id", isEqualTo: taskID).getDocuments { snapshot, error in
                                    if let error = error {
                                        print("❌ 刪除失敗：\(error.localizedDescription)")
                                        return
                                    }
                                    guard let document = snapshot?.documents.first else {
                                        print("❌ 找不到對應的文件")
                                        return
                                    }
                                    document.reference.delete { error in
                                        if let error = error {
                                            print("❌ 刪除失敗：\(error.localizedDescription)")
                                        } else {
                                            print("✅ 已刪除資料")
                                            tasks.remove(at: i)
                                        }
                                    }
                                }
                            }
                            )
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color.white)
                            if i != 0 {
                                Divider()
                            }
                        }
//                        NavigationLink(destination: TodoView()) {
//
//                        }
                    }
                }
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .navigationTitle("課程追蹤")
            .background(Color.gray.opacity(0.1))
        }
        .onAppear {
            fetchTasks()
        }
    }
    func fetchTasks() {
        // 檢查用戶是否已登入
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("❌ 用戶未登入")
            return
        }
        
        let db = Firestore.firestore()
        // 只查詢屬於當前用戶的任務
        db.collection("tasks").whereField("userId", isEqualTo: currentUserId).getDocuments { snapshot, error in
            if let error = error {
                print("❌ 錯誤：\(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                do {
                    self.tasks = try snapshot.documents.compactMap {
                        try $0.data(as: TaskItem.self)
                    }
                } catch {
                    print("❌ 解碼失敗：\(error.localizedDescription)")
                }
            }
        }
    }
}




struct Component: View {
    var task: TaskItem
    var onDelete: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("作業名稱：\(task.title)")
                    .font(.title2)
                Spacer()
                Text(task.stateCategory)
                    .font(.caption)
                    .padding(6)
                    .background(backgroundColor(for: task.stateCategory))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Text("類別：\(task.category)")
            Text("預計完成時長：\(task.hour) 小時")
            Text("截止時間：\(task.deadline.formatted(date: .abbreviated, time:.omitted))")
            Text("備註：\(task.note)")
            
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 4)
        }
        .cornerRadius(12)
    }
    
    func backgroundColor(for state: String) -> Color {
        switch state {
        case StateCategory.urgentImportant.rawValue:
            return .red
        case StateCategory.notUrgentButImportant.rawValue:
            return .orange
        case StateCategory.notImportantAndNotUrgent.rawValue:
            return .gray
        default:
            return .blue
        }
    }
}

#Preview {
    HomeView()
}
