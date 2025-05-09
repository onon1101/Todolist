//
//  AddView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case all = "全部"
    case work = "工作"
    case home = "家庭"
    case study = "學習"

    var id: String { self.rawValue }
}

struct AddView: View {
    @State private var userInput: String = ""
    @State private var selectionCategory: Category = .all
    @State private var selectionHour: Int = Int.max
    @State private var selectDate: Date = Date()
    @State private var note: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("項目名稱：")
                TextField("請輸入作業名稱", text: $userInput)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Text("選擇工作類別：")
                Picker("選擇分類：", selection: $selectionCategory) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }

            Picker("選擇小時數", selection: $selectionHour) {
                Text("未知")
                ForEach(1...24, id: \.self) {
                    hour in
                    Text("\(hour) 小時").tag(hour)
                }
                .pickerStyle(DefaultPickerStyle()).frame(height: 150)
            }

            DatePicker(
                "截止日期", selection: $selectDate, displayedComponents: .date)
            
            

            VStack(alignment: .leading) {
                Text("備註")
                    .font(.headline)

                TextEditor(text: $note)
                    .frame(height: 100)
                    .padding(8)
//                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding()
        }

        .padding()
    }
}

#Preview {
    AddView()
}
