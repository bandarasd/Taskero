//
//  CreateAccountView.swift
//  Taskero
//

import SwiftUI

struct CreateAccountView: View {

    @EnvironmentObject var authService: AuthenticationService

    // Written back to AppStorage from here so TaskeroApp re-evaluates routing
    @AppStorage("isDBUserCreated") private var isDBUserCreated: Bool = false
    @AppStorage("userRole") private var userRole: String = "customer"

    @State private var selectedRole: String = "customer"
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    private let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255)

    private var phoneNumber: String {
        authService.user?.phoneNumber ?? ""
    }

    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") && email.contains(".") &&
        password.count >= 6
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // Header
                VStack(spacing: 10) {
                    Image("AppLogoColored")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)

                    Text("Create your account")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Tell us a bit about yourself")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 48)

                // Role selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        RoleCard(
                            title: "Hire Help",
                            subtitle: "Client",
                            icon: "person.fill",
                            isSelected: selectedRole == "customer"
                        ) { selectedRole = "customer" }

                        RoleCard(
                            title: "Find Work",
                            subtitle: "Worker",
                            icon: "wrench.and.screwdriver.fill",
                            isSelected: selectedRole == "worker"
                        ) { selectedRole = "worker" }
                    }
                    .padding(.horizontal)
                }

                // Form fields
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        AccountInputField(label: "First name", text: $firstName)
                        AccountInputField(label: "Last name", text: $lastName)
                    }
                    AccountInputField(
                        label: "Email address",
                        text: $email,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Create Password")
                            .font(.caption)
                            .foregroundColor(.gray)
                        SecureField("Create Password", text: $password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)

                // Error
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Submit
                Button(action: submit) {
                    Group {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Create Account")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? mainColor : Color.gray.opacity(0.4))
                    .cornerRadius(30)
                }
                .disabled(!isFormValid || isLoading)
                .padding(.horizontal)

                // Sign out option
                Button("Use a different account") {
                    authService.signOut()
                }
                .foregroundColor(.gray)
                .font(.subheadline)

                Spacer(minLength: 40)
            }
        }
        .interactiveDismissDisabled(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }

    // MARK: - Submit

    private func submit() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let phone = phoneNumber
                let fn = firstName.trimmingCharacters(in: .whitespaces)
                let ln = lastName.trimmingCharacters(in: .whitespaces)
                let em = email.trimmingCharacters(in: .whitespaces).lowercased()
                let pw = password

                // Check first to avoid duplicate creation on retry
                let exists = (try? await UserService.shared.checkUserByPhone(phone)) ?? false
                if !exists {
                    try await UserService.shared.createUser(
                        firstName: fn,
                        lastName: ln,
                        email: em,
                        phone: phone,
                        password: pw,
                        role: selectedRole
                    )
                }

                await MainActor.run {
                    userRole = selectedRole
                    UserDefaults.standard.set(fn, forKey: "userFirstName")
                    UserDefaults.standard.set(ln, forKey: "userLastName")
                    UserDefaults.standard.set(em, forKey: "userEmail")
                    isDBUserCreated = true   // triggers TaskeroApp to show ContentView
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Role Card

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void

    private let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255)

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? mainColor : .gray)
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .black : .gray)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(isSelected ? mainColor : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? mainColor.opacity(0.06) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? mainColor : Color.gray.opacity(0.3),
                                    lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
    }
}

// MARK: - Input Field

private struct AccountInputField: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(label, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AuthenticationService())
}
