//
//  AIView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/6/8.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct AIView: View {
    @State private var summaryText = ""

    var body: some View {
        VStack {
            Button("生成今日計畫總結") {
                generateSummary()
            }
            .padding(.bottom, 10)

            ScrollView {
                if let attributed = try? AttributedString(markdown: summaryText) {
                    Text(attributed)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                } else {
                    Text(summaryText)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .frame(height: 500)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            
        }
        .padding()
    }

    func generateSummary() {
        // 檢查用戶是否已登入
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            summaryText = "❌ 請先登入"
            return
        }
        
        let db = Firestore.firestore()
        // 只查詢屬於當前用戶的任務
        db.collection("tasks").whereField("userId", isEqualTo: currentUserId).getDocuments { snapshot, error in
            if let error = error {
                summaryText = "❌ 錯誤：\(error.localizedDescription)"
                return
            }

            guard let documents = snapshot?.documents else {
                summaryText = "❌ 無法取得任務資料"
                return
            }

            let tasks: [TaskItem] = documents.compactMap { doc in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let category = data["category"] as? String,
                      let stateCategory = data["stateCategory"] as? String,
                      let hour = data["hour"] as? Int,
                      let timestamp = data["deadline"] as? Timestamp,
                      let note = data["note"] as? String,
                      let userId = data["userId"] as? String else {
                    return nil
                }
                return TaskItem(title: title, category: category, stateCategory: stateCategory, hour: hour, deadline: timestamp.dateValue(), note: note, userId: userId)
            }

            let taskDescriptions = tasks.map {
                "工作名稱：\($0.title)，分類：\($0.category)，狀態分類：\($0.stateCategory)，預估時數：\($0.hour)，截止：\($0.deadline)，備註：\($0.note)"
            }.joined(separator: "\n")

            sendToGemini(with: taskDescriptions)
        }
    }

    func sendToGemini(with description: String) {
        let url = URL(string: "<api key>")!
        let prompt = "以下是今天的任務清單，請幫我總結今天的工作計畫與建議：\n\(description)"

        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let content = candidates.first?["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let text = parts.first?["text"] as? String else {
                DispatchQueue.main.async {
                    summaryText = "❌ 無法取得 AI 回應"
                }
                return
            }
            DispatchQueue.main.async {
                summaryText = text
            }
        }.resume()
    }
}

#Preview {
    AIView()
}
