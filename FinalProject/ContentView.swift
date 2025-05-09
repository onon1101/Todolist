//
//  ContentView.swift
//  FinalProject
//
//  Created by 陳世昂 on 2025/5/9.
//

import SwiftUI

enum Tab {
    case HOME, ABOUT, CALENDAR, REPORT, ADD
}

struct ContentView: View {
    @State private var selectedTab: Tab = .HOME
    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(Tab.HOME)
            CanlendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("calendar")
                }
                .tag(Tab.CALENDAR)
            AddView()
                .tabItem {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 30))

                    Text("Add")
                }
                .tag(Tab.ADD)
            ReportView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Report")
                }
                .tag(Tab.REPORT)
            AboutView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("About")
                }
                .tag(Tab.ABOUT)
        }
    }
}

#Preview {
    ContentView()
}
