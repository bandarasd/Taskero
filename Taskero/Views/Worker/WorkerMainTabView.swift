//
//  WorkerMainTabView.swift
//  Taskero
//

import SwiftUI

struct WorkerMainTabView: View {
    let mainColor = Color.brandGreen
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkerDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            WorkerJobsView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }
                .tag(1)
            
            WorkerScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(2)
            
            WorkerMessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
                .tag(3)
            
            WorkerProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
        .accentColor(mainColor)
    }
}

#Preview {
    WorkerMainTabView()
}
