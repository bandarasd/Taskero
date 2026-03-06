//
//  ProfileView.swift
//  Taskero
//
//  Created by Antigravity on 2026-01-25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthenticationService
    @AppStorage("userFirstName") var firstName: String = ""
    @AppStorage("userLastName") var lastName: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userRole") var userRole: String = "customer"
    @AppStorage("isWorkerOnboardingCompleted") var isWorkerOnboardingCompleted: Bool = false
    
    @State private var profile = UserProfile.mock
    @State private var showingEditProfile = false
    @State private var showingLogoutAlert = false
    
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Header
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let imageName = profile.profileImage {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 5)
                            } else {
                                Circle()
                                    .fill(mainColor.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(mainColor)
                                    )
                                    .shadow(radius: 5)
                            }
                            
                            Button(action: { showingEditProfile = true }) {
                                Circle()
                                    .fill(mainColor)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(radius: 2)
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(firstName) \(lastName)")
                                .font(.system(size: 24, weight: .bold))
                            
                            Text(userEmail)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Menu Groups
                    VStack(spacing: 32) {
                        // Account Group
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                NavigationLink(destination: EditProfileView(profile: $profile)) {
                                    ProfileOptionRow(icon: "person", title: "Edit Profile")
                                }
                                Divider()
                                NavigationLink(destination: AddressSelectionView(onSelect: { _ in })) {
                                    ProfileOptionRow(icon: "mappin.and.ellipse", title: "Address")
                                }
                                Divider()
                                NavigationLink(destination: ClientPaymentMethodsView()) {
                                    ProfileOptionRow(icon: "creditcard", title: "Payment Methods")
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                        
                        // App Settings Group
                        VStack(alignment: .leading, spacing: 12) {
                            Text("App Settings")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                NavigationLink(destination: ClientNotificationsView()) {
                                    ProfileOptionRow(icon: "bell", title: "Notifications", value: "On")
                                }
                                Divider()
                                NavigationLink(destination: PrivacyPolicyView()) {
                                    ProfileOptionRow(icon: "lock", title: "Privacy Policy")
                                }
                                Divider()
                                NavigationLink(destination: SecuritySettingsView()) {
                                    ProfileOptionRow(icon: "shield", title: "Security")
                                }
                                Divider()
                                Button(action: {
                                    withAnimation {
                                        isWorkerOnboardingCompleted = false
                                        userRole = "worker"
                                    }
                                }) {
                                    ProfileOptionRow(icon: "briefcase.fill", title: "Switch to Worker Account", showChevron: true, titleColor: mainColor)
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                        
                        // Support Group
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Support")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                NavigationLink(destination: HelpCenterView()) {
                                    ProfileOptionRow(icon: "questionmark.circle", title: "Help Center")
                                }
                                Divider()
                                ProfileOptionRow(icon: "star", title: "Rate Our App")
                                Divider()
                                Button(action: { showingLogoutAlert = true }) {
                                    ProfileOptionRow(icon: "arrow.right.square", title: "Logout", showChevron: false, titleColor: .red)
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Version 1.0.0")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.vertical, 20)
                }
            }
            .background(Color(red: 248/255, green: 249/255, blue: 251/255))
            .navigationBarHidden(true)
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        authService.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(profile: $profile)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationService())
}
