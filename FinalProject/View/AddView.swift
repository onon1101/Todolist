//
//  AddView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TaskItem: Codable {
    var id = UUID()
    var title: String
    var category: String
    var stateCategory: String
    var hour: Int
    var deadline: Date
    var note: String
    var userId: String // 新增用戶 ID 欄位
}

enum Category: String, CaseIterable, Identifiable {
    case work = "工作"
    case home = "家庭"
    case study = "學習"

    var id: String { self.rawValue }
}

enum StateCategory: String, CaseIterable, Identifiable {
    case urgentImportant = "緊急且重要"
    case notUrgentButImportant = "不緊急但重要"
    case notImportantAndNotUrgent = "不重要也不緊急"
    
    var id: String { self.rawValue }
}

struct AddView: View {
    @State private var userInput: String = ""
    @State private var selectionCategory: Category = .work
    @State private var selectionStateCategory: StateCategory = .urgentImportant
    @State private var selectionHour: Int = Int.max
    @State private var selectDate: Date = Date()
    @State private var note: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("項目名稱：")
                            .font(.headline)
                        TextField("請輸入作業名稱", text: $userInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("選擇工作類別：")
                            .font(.headline)
                        Picker("選擇分類：", selection: $selectionCategory) {
                            ForEach(Category.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("選擇狀態：")
                            .font(.headline)
                        Picker("選擇分類：", selection: $selectionStateCategory) {
                            ForEach(StateCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("選擇小時數：")
                            .font(.headline)
                        Picker("選擇小時數", selection: $selectionHour) {
                            Text("未知")
                                .tag(Int.max)
                            ForEach(1...24, id: \.self) { hour in
                                Text("\(hour) 小時").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .frame(height: 150)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    DatePicker("截止日期：", selection: $selectDate, displayedComponents: .date)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("備註")
                            .font(.headline)
                        
                        TextEditor(text: $note)
                            .frame(height: 300)
                            .padding(8)
                            .cornerRadius(16)
                            .shadow(radius: 16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .navigationTitle("增加事項")
                
                Button("儲存") {
                    // 檢查用戶是否已登入
                    guard let currentUserId = Auth.auth().currentUser?.uid else {
                        alertMessage = "❌ 請先登入"
                        showAlert = true
                        return
                    }
                    
                    let db = Firestore.firestore()
                    let task = TaskItem(
                        title: userInput,
                        category: selectionCategory.rawValue,
                        stateCategory: selectionStateCategory.rawValue,
                        hour: selectionHour,
                        deadline: selectDate,
                        note: note,
                        userId: currentUserId // 加入當前用戶 ID
                    )
                    
                    do {
                        let ref = try db.collection("tasks").addDocument(from: task)
                        print("儲存成功，文件 ID：\(ref.documentID)")
                        alertMessage = "儲存成功！"
                        showAlert = true
                        userInput = ""
                        note = ""
                    } catch {
                        print("❌ 儲存失敗：\(error.localizedDescription)")
                        alertMessage = "❌ 儲存失敗：\(error.localizedDescription)"
                        showAlert = true
                    }
                }
                .padding()
                .frame(height: 32)
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
                .alert("提示", isPresented: $showAlert) {
                    Button("確定", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                
            }
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    AddView()
}
