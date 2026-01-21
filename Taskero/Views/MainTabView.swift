//
//  MainTabView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct MainTabView: View {
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Text("Categories")
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
            
            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "doc.text.fill")
                }
            
            Text("Message")
                .tabItem {
                    Label("Message", systemImage: "message") // SF Symbol varies
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(mainColor)
    }
}

#Preview {
    MainTabView()
}
