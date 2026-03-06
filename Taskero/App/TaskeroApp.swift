//
//  TaskeroApp.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-09.
//

import SwiftUI

@main
struct TaskeroApp: App {
    @State private var isLoading = true
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @AppStorage("userRole") var userRole: String = "customer"
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                if isOnboardingCompleted {
                    ContentView()
                } else {
                    OnboardingView()
                }
            }
        }
    }
}
