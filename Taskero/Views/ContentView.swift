//
//  ContentView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-09.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userRole") var userRole: String = "customer"
    @AppStorage("isWorkerOnboardingCompleted") var isWorkerOnboardingCompleted: Bool = false
    
    var body: some View {
        if userRole == "worker" {
            if isWorkerOnboardingCompleted {
                WorkerMainTabView()
            } else {
                WorkerOnboardingView()
            }
        } else {
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}
