//
//  CanlendarView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/6/8.
//

import SwiftUI

struct CanlendarView: View {
    @State private var selectedDate = Date()
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "選擇日期",
                    selection: $selectedDate,
                    displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
            }
            .navigationTitle("Calender")
        }
    }
}

#Preview {
    CanlendarView()
}
