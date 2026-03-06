//
//  MainTabView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct MainTabView: View {
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    @State private var selectedTab = 0
    @State private var scrollToTop = false
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Ensure it has a background color
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newValue in
                if newValue == selectedTab && newValue == 0 {
                    // Tapped home tab while already on home - trigger scroll
                    scrollToTop.toggle()
                }
                selectedTab = newValue
            }
        )) {
            HomeView(scrollToTop: $scrollToTop)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CategoryView()
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
                .tag(1)
            
            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "doc.text.fill")
                }
                .tag(2)
            
            MessagesView()
                .tabItem {
                    Label("Message", systemImage: "message")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .accentColor(mainColor)
    }
}

#Preview {
    MainTabView()
}
