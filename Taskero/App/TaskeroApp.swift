//
//  TaskeroApp.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        completionHandler(.noData)
    }
}

@main
struct TaskeroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authService = AuthenticationService()

    @State private var isLoading = true
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @AppStorage("userRole") var userRole: String = "customer"
    @AppStorage("isDBUserCreated") var isDBUserCreated: Bool = false

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
                if authService.isAuthenticated || isDBUserCreated {
                    if isDBUserCreated {
                        ContentView()
                            .environmentObject(authService)
                    } else {
                        // Firebase auth succeeded but no DB record yet → collect profile
                        CreateAccountView()
                            .environmentObject(authService)
                    }
                } else if isOnboardingCompleted {
                    // User has already seen onboarding — go straight to auth
                    AuthView()
                        .environmentObject(authService)
                } else {
                    OnboardingView()
                        .environmentObject(authService)
                }
            }
        }
    }
}
