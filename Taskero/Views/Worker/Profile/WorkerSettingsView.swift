//
//  WorkerSettingsView.swift
//  Taskero
//

import SwiftUI

struct WorkerSettingsView: View {

    let mainColor = Color.brandGreen
    @Environment(\.presentationMode) var presentationMode

    // Notification Preferences
    @State private var jobRequestNotifs       = true
    @State private var paymentNotifs          = true
    @State private var reminderNotifs         = true
    @State private var reviewNotifs           = false
    @State private var promotionalNotifs      = false

    // Availability
    @AppStorage("workerAvailableWeekends") var availableWeekends = true
    @AppStorage("workerAvailableEvenings") var availableEvenings = false

    // Payout preferences
    @State private var selectedPayoutCycle    = 0
    let payoutCycles = ["Daily", "Weekly", "Bi-weekly"]

    // Bank Account (mock display)
    @State private var showBankSheet = false

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)

            ScrollView {
                VStack(spacing: 24) {

                    // --- Payout Settings ---
                    SettingsSection(title: "Payout & Bank") {
                        SettingsNavigationRow(icon: "building.columns.fill", iconColor: .brandGreen, title: "Bank Account") {
                            showBankSheet = true
                        }
                        Divider().padding(.leading, 52)
                        SettingsPickerRow(icon: "calendar.badge.clock", iconColor: .blue, title: "Payout Cycle", selection: $selectedPayoutCycle, options: payoutCycles)
                    }

                    // --- Availability ---
                    SettingsSection(title: "Availability") {
                        SettingsToggleRow(icon: "sun.max.fill",   iconColor: .orange,     title: "Available on Weekends",  isOn: $availableWeekends)
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(icon: "moon.fill",      iconColor: .indigo,     title: "Available in Evenings",  isOn: $availableEvenings)
                    }

                    // --- Notifications ---
                    SettingsSection(title: "Notifications") {
                        SettingsToggleRow(icon: "briefcase.fill",          iconColor: .blue,        title: "New Job Requests",   isOn: $jobRequestNotifs)
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(icon: "dollarsign.circle.fill",  iconColor: .brandGreen,  title: "Payment Received",   isOn: $paymentNotifs)
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(icon: "clock.fill",              iconColor: .orange,      title: "Job Reminders",      isOn: $reminderNotifs)
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(icon: "star.fill",               iconColor: .yellow,      title: "New Reviews",        isOn: $reviewNotifs)
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(icon: "megaphone.fill",          iconColor: .pink,        title: "Promotions",         isOn: $promotionalNotifs)
                    }

                    // --- About ---
                    SettingsSection(title: "About") {
                        SettingsNavigationRow(icon: "questionmark.circle.fill", iconColor: .gray,  title: "Help & Support")  {}
                        Divider().padding(.leading, 52)
                        SettingsNavigationRow(icon: "doc.text.fill",            iconColor: .gray,  title: "Terms of Service") {}
                        Divider().padding(.leading, 52)
                        SettingsNavigationRow(icon: "lock.shield.fill",         iconColor: .gray,  title: "Privacy Policy")   {}
                    }

                    // Version
                    Text("Taskero Pro v1.0.0 (Worker)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 40)
                }
                .padding(.top, 16)
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showBankSheet) {
            BankAccountSheet(mainColor: mainColor)
        }
    }
}

// MARK: - Subviews

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
            .padding(.horizontal)
        }
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.brandGreen)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct SettingsNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(iconColor)
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

private struct SettingsPickerRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var selection: Int
    let options: [String]

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options.indices, id: \.self) { i in
                    Text(options[i]).tag(i)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .tint(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

// MARK: - Bank Account Sheet

struct BankAccountSheet: View {
    let mainColor: Color
    @Environment(\.dismiss) var dismiss

    @State private var bankName      = "Chase Bank"
    @State private var accountHolder = MockData.currentWorker.name
    @State private var routingNumber = "021000021"
    @State private var accountNumber = "••••••8823"
    @State private var showSaved = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Current Bank Card
                    VStack(spacing: 4) {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            Text("Linked")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(6)
                        }
                        Spacer().frame(height: 16)
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bankName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(accountNumber)
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [mainColor, mainColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(20)
                    .shadow(color: mainColor.opacity(0.3), radius: 8, y: 4)
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Form Fields
                    VStack(spacing: 0) {
                        BankField(label: "Bank Name",       value: $bankName)
                        Divider().padding(.leading, 16)
                        BankField(label: "Account Holder",  value: $accountHolder)
                        Divider().padding(.leading, 16)
                        BankField(label: "Routing Number",  value: $routingNumber, keyboardType: .numberPad)
                        Divider().padding(.leading, 16)
                        BankField(label: "Account Number",  value: $accountNumber, keyboardType: .numberPad)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
                    .padding(.horizontal)

                    Button(action: { showSaved = true }) {
                        Text("Update Bank Account")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(mainColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
            .navigationTitle("Bank Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(mainColor)
                }
            }
            .alert("Saved!", isPresented: $showSaved) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your bank account has been updated.")
            }
        }
    }
}

private struct BankField: View {
    let label: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField(label, text: $value)
                    .font(.subheadline)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    WorkerSettingsView()
}
