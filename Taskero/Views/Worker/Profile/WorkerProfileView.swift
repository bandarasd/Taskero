//
//  WorkerProfileView.swift
//  Taskero
//

import SwiftUI

struct WorkerProfileView: View {
    @AppStorage("userRole") var userRole: String = "worker"
    let worker = MockData.currentWorker
    let mainColor = Color.brandGreen
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header Block
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let imageName = worker.profileImage, UIImage(named: imageName) != nil {
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
                            // Verified badge
                            ZStack {
                                Circle().fill(Color.brandGreen).frame(width: 26, height: 26)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        }
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Text(worker.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(String(format: "%.1f", worker.rating))
                                    .fontWeight(.bold)
                                Text("(\(worker.reviewCount) reviews)")
                                    .foregroundColor(.gray)
                            }
                            .font(.subheadline)

                            // Edit Profile link
                            NavigationLink(destination: WorkerEditProfileView()) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(mainColor)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(mainColor, lineWidth: 1.5)
                                    )
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Menu Groups
                    VStack(spacing: 24) {

                        // Quick Links Row
                        HStack(spacing: 16) {
                            QuickLinkCard(icon: "creditcard.fill", label: "Earnings", color: mainColor, destination: AnyView(WorkerEarningsView()))
                            QuickLinkCard(icon: "star.fill", label: "Reviews", color: .yellow, destination: AnyView(WorkerReviewsView()))
                            QuickLinkCard(icon: "bell.fill", label: "Notifications", color: .orange, destination: AnyView(WorkerNotificationsView()))
                            QuickLinkCard(icon: "gearshape.fill", label: "Settings", color: .gray, destination: AnyView(WorkerSettingsView()))
                        }
                        .padding(.horizontal)
                        
                        // Services Provided
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Services I Provide")
                                .font(.headline)
                                .padding(.leading, 4)

                            NavigationLink(destination: WorkerServicesView()) {
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(mainColor.opacity(0.12))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "list.bullet.clipboard.fill")
                                            .foregroundColor(mainColor)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Manage My Services")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("Add, edit or remove services you offer")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(14)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 3)
                            }
                        }

                        // Profile Links
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Profile")
                                .font(.headline)
                                .padding(.leading, 4)

                            VStack(spacing: 0) {
                                NavigationLink(destination: WorkerEditProfileView()) {
                                    ProfileOptionRow(icon: "person.fill", title: "Edit Profile", showChevron: true)
                                }
                                Divider()
                                NavigationLink(destination: WorkerReviewsView()) {
                                    ProfileOptionRow(icon: "star.fill", title: "My Reviews", value: "\(MockData.currentWorker.rating)★", showChevron: true)
                                }
                                Divider()
                                NavigationLink(destination: WorkerEarningsView()) {
                                    ProfileOptionRow(icon: "creditcard.fill", title: "Earnings & Wallet", showChevron: true)
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 3)
                        }
                        
                        // Account Settings
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Account")
                                .font(.headline)
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                NavigationLink(destination: WorkerNotificationsView()) {
                                    ProfileOptionRow(icon: "bell.fill", title: "Notifications", showChevron: true)
                                }
                                Divider()
                                NavigationLink(destination: WorkerSettingsView()) {
                                    ProfileOptionRow(icon: "gearshape.fill", title: "Settings", showChevron: true)
                                }
                                Divider()
                                Button(action: {
                                    withAnimation { userRole = "customer" }
                                }) {
                                    ProfileOptionRow(icon: "person.crop.circle", title: "Switch to Customer Account", showChevron: true, titleColor: mainColor)
                                }
                                Divider()
                                Button(action: { showingLogoutAlert = true }) {
                                    ProfileOptionRow(icon: "arrow.right.square", title: "Logout", showChevron: false, titleColor: .red)
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Taskero Pro v1.0.0")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.vertical, 30)
                }
            }
            .background(Color.gray.opacity(0.03).ignoresSafeArea())
            .navigationBarHidden(true)
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        // Handle logout
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

// MARK: - Components

struct ServiceToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
        }
        .tint(Color.brandGreen)
        .padding(.vertical, 12)
    }
}

struct QuickLinkCard: View {
    let icon: String
    let label: String
    let color: Color
    let destination: AnyView

    init(icon: String, label: String, color: Color, destination: AnyView) {
        self.icon = icon
        self.label = label
        self.color = color
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WorkerProfileView()
}
