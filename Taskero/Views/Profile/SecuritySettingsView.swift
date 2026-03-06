//
//  SecuritySettingsView.swift
//  Taskero
//

import SwiftUI

struct SecuritySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    let mainColor = Color.brandGreen

    @AppStorage("biometricsEnabled") private var biometricsEnabled = false
    @AppStorage("loginNotifications") private var loginNotifications = true
    @AppStorage("twoFactorEnabled") private var twoFactorEnabled = false

    @State private var showChangePassword = false
    @State private var showDevices = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text("Security").font(.headline).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            ScrollView {
                VStack(spacing: 22) {

                    // Security status
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(mainColor.opacity(0.12)).frame(width: 52, height: 52)
                            Image(systemName: "shield.fill")
                                .font(.system(size: 22)).foregroundColor(mainColor)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Account Protected").font(.subheadline).fontWeight(.bold)
                            Text("Your account security looks good.")
                                .font(.caption).foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(mainColor.opacity(0.06))
                    .cornerRadius(14)

                    // Authentication
                    secSection(title: "Authentication") {
                        secToggle(icon: "faceid", iconColor: .indigo, title: "Face ID / Touch ID",
                                  subtitle: "Use biometrics to log in quickly and securely",
                                  isOn: $biometricsEnabled)
                        Divider().padding(.leading, 52)
                        secToggle(icon: "key.fill", iconColor: .orange, title: "Two-Factor Authentication",
                                  subtitle: "Send a code to your phone when signing in",
                                  isOn: $twoFactorEnabled)
                    }

                    // Password
                    secSection(title: "Password") {
                        Button(action: { showChangePassword = true }) {
                            secNavRow(icon: "lock.fill", iconColor: mainColor, title: "Change Password",
                                      subtitle: "Last changed 3 months ago")
                        }
                    }

                    // Activity
                    secSection(title: "Account Activity") {
                        secToggle(icon: "bell.badge.fill", iconColor: .red, title: "Login Alerts",
                                  subtitle: "Get notified of new logins to your account",
                                  isOn: $loginNotifications)
                        Divider().padding(.leading, 52)
                        Button(action: { showDevices = true }) {
                            secNavRow(icon: "iphone", iconColor: .blue, title: "Active Devices",
                                      subtitle: "Manage devices signed in to your account")
                        }
                    }

                    // Danger zone
                    secSection(title: "Account Actions") {
                        Button(action: {}) {
                            secNavRow(icon: "arrow.right.square.fill", iconColor: .red, title: "Sign Out All Devices",
                                      subtitle: "Log out from all active sessions", titleColor: .red)
                        }
                    }

                    Spacer().frame(height: 80)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showChangePassword) { ChangePasswordView() }
        .sheet(isPresented: $showDevices) { ActiveDevicesView() }
    }

    // MARK: - Reusable builders
    @ViewBuilder
    private func secSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.caption).fontWeight(.bold).foregroundColor(.gray).padding(.leading, 4)
            VStack(spacing: 0) { content() }
                .background(Color.white).cornerRadius(14)
                .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
        }
    }

    @ViewBuilder
    private func secToggle(icon: String, iconColor: Color, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9).fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon).foregroundColor(iconColor).font(.system(size: 15))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold)
                Text(subtitle).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Toggle("", isOn: isOn).toggleStyle(SwitchToggleStyle(tint: mainColor)).labelsHidden()
        }
        .padding(14)
    }

    @ViewBuilder
    private func secNavRow(icon: String, iconColor: Color, title: String, subtitle: String, titleColor: Color = .primary) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9).fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon).foregroundColor(iconColor).font(.system(size: 15))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold).foregroundColor(titleColor)
                Text(subtitle).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
        }
        .padding(14)
    }
}

// MARK: - Change Password Sheet

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var current = ""
    @State private var newPass = ""
    @State private var confirm = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 14) {
                    pwField("Current Password", text: $current)
                    pwField("New Password", text: $newPass)
                    pwField("Confirm New Password", text: $confirm)
                }
                .padding()

                Button(action: {
                    guard !current.isEmpty, newPass == confirm, newPass.count >= 8 else {
                        showAlert = true; return
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Update Password")
                        .font(.headline).fontWeight(.bold).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.brandGreen).cornerRadius(14)
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }.foregroundColor(.gray)
                }
            }
            .alert("Invalid", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Make sure passwords match and are at least 8 characters.")
            }
        }
    }

    @ViewBuilder
    private func pwField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).fontWeight(.semibold).foregroundColor(.gray)
            SecureField(label, text: text)
                .padding(12).background(Color.gray.opacity(0.06)).cornerRadius(10)
        }
    }
}

// MARK: - Active Devices Sheet

struct ActiveDevicesView: View {
    @Environment(\.presentationMode) var presentationMode

    let devices: [(name: String, type: String, location: String, lastActive: String)] = [
        ("iPhone 15 Pro", "Current Device", "Manchester, UK", "Active now"),
        ("iPad Air", "Tablet", "Manchester, UK", "2 days ago"),
        ("MacBook Pro", "Desktop", "New York, US", "5 days ago")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(devices, id: \.name) { device in
                    HStack(spacing: 14) {
                        Image(systemName: device.type == "Tablet" ? "ipad" : device.type == "Desktop" ? "display" : "iphone")
                            .font(.title2).foregroundColor(.brandGreen)
                            .frame(width: 36)
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(device.name).font(.subheadline).fontWeight(.semibold)
                                if device.type == "Current Device" {
                                    Text("Current").font(.caption2).fontWeight(.bold)
                                        .foregroundColor(.brandGreen)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(Color.brandGreen.opacity(0.1)).clipShape(Capsule())
                                }
                            }
                            Text("\(device.location) · \(device.lastActive)")
                                .font(.caption).foregroundColor(.gray)
                        }
                        Spacer()
                        if device.type != "Current Device" {
                            Button("Remove") {}
                                .font(.caption).fontWeight(.bold).foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Active Devices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }.foregroundColor(.brandGreen)
                }
            }
        }
    }
}

#Preview { SecuritySettingsView() }
