//
//  EmailAuthView.swift
//  Taskero
//

import SwiftUI

struct EmailAuthView: View {

    @EnvironmentObject var authService: AuthenticationService
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignUp: Bool = false

    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255)

    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && password.count >= 6 && password == confirmPassword
        }
        return !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    Image("AppLogoColored")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)

                    Text(isSignUp ? "Create your account" : "Welcome back")
                        .font(.title2)
                        .fontWeight(.bold)

                    // Fields
                    VStack(spacing: 16) {
                        LabeledField(label: "Email") {
                            TextField("you@example.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }

                        LabeledField(label: "Password") {
                            SecureField("Min. 6 characters", text: $password)
                                .textContentType(isSignUp ? .newPassword : .password)
                        }

                        if isSignUp {
                            LabeledField(label: "Confirm Password") {
                                SecureField("Repeat your password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Error
                    if let error = authService.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Primary Action
                    Button {
                        Task {
                            if isSignUp {
                                await authService.signUp(email: email, password: password)
                            } else {
                                await authService.signIn(email: email, password: password)
                            }
                        }
                    } label: {
                        Group {
                            if authService.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(isSignUp ? "Create Account" : "Sign In")
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
                    .disabled(!isFormValid || authService.isLoading)
                    .padding(.horizontal)

                    // Toggle Sign-Up / Sign-In
                    Button {
                        withAnimation {
                            isSignUp.toggle()
                            authService.errorMessage = nil
                        }
                    } label: {
                        Text(isSignUp
                             ? "Already have an account? **Sign In**"
                             : "Don't have an account? **Sign Up**")
                            .font(.subheadline)
                            .foregroundColor(mainColor)
                    }

                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        authService.errorMessage = nil
                        dismiss()
                    }
                }
            }
            .onTapGesture { hideKeyboard() }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// MARK: - Reusable labelled text-field wrapper

private struct LabeledField<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            content()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    EmailAuthView()
        .environmentObject(AuthenticationService())
}
