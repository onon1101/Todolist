//
//  HomeView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import SwiftUI

struct HomeView: View {
    private var page = 10
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<page) { i in
                        NavigationLink(destination: TodoView()) {
                            VStack(spacing: 0) {
                                Component()
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(Color.white)
                                if i != page - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .navigationTitle("課程追蹤")
            .background(Color.gray.opacity(0.2))
        }
    }
}

struct Component: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("作業名稱：")
                Spacer()
                Text("state")
            }
            Text("類別：")
            Text("預計完成時長：")
            Text("截止時間：。剩餘")
            Text("備註")
        }
        .cornerRadius(12)
    }
}
