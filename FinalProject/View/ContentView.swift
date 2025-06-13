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
    @State private var isLoading = false
    var body: some View {
        Group {
            if !isLoading {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(Tab.HOME)
//                    CanlendarView()
//                        .tabItem {
//                            Image(systemName: "calendar")
//                            Text("calendar")
//                        }
//                        .tag(Tab.CALENDAR)
                    AddView()
                        .tabItem {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 30))

                            Text("Add")
                        }
                        .tag(Tab.ADD)
                    AIView()
                        .tabItem {
                            Image(systemName: "brain.head.profile")
                            Text("AI")
                        }
                        .tag(Tab.REPORT)
                    AboutView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("About")
                        }
                        .tag(Tab.ABOUT)
                }
            } else {
                LoadingView()
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
