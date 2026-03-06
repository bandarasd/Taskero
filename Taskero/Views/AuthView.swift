//
//  AuthView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-11.
//

import SwiftUI

struct AuthView: View {

    @EnvironmentObject var authService: AuthenticationService

    // Country / Phone picker state
    @State private var mobileNumber: String = ""
    @State private var selectedCountry: Country?
    @State private var countries: [Country] = []
    @State private var showCountryPicker = false

    // OTP flow
    @State private var showOTPView = false
    @State private var verificationID: String = ""
    @State private var otpError: String?

    // Email flow
    @State private var showEmailAuth = false

    // State for password entry
    @State private var showPasswordField = false
    @State private var password: String = ""
    @State private var isLoggingIn = false

    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63

    private var fullPhoneNumber: String {
        "\(selectedCountry?.dial_code ?? "")\(mobileNumber)"
    }

    private func sendContinueAction() {
        isLoadingAuthState = true
        otpError = nil
        
        Task {
            do {
                // 1. Check if user exists by phone
                let exists = try await UserService.shared.checkUserByPhone(fullPhoneNumber)
                
                if exists {
                    // 2. If exists, show password field
                    await MainActor.run {
                        showPasswordField = true
                        isLoadingAuthState = false
                    }
                } else {
                    // 3. If not exists, send OTP
                    let vid = try await authService.sendOTP(phoneNumber: fullPhoneNumber)
                    await MainActor.run {
                        verificationID = vid
                        showOTPView = true
                        isLoadingAuthState = false
                    }
                }
            } catch {
                await MainActor.run {
                    otpError = error.localizedDescription
                    isLoadingAuthState = false
                }
            }
        }
    }

    private func login() {
        isLoggingIn = true
        otpError = nil
        Task {
            do {
                let response = try await UserService.shared.login(phone: fullPhoneNumber, password: password)
                
                // Extract user data including role
                let userData = response["user"] as? [String: Any]
                let role = userData?["role"] as? String ?? "customer"
                let firstName = userData?["first_name"] as? String ?? ""
                let lastName = userData?["last_name"] as? String ?? ""
                let email = userData?["email"] as? String ?? ""

                await MainActor.run {
                    // Update AppStorage
                    UserDefaults.standard.set(role, forKey: "userRole")
                    UserDefaults.standard.set(firstName, forKey: "userFirstName")
                    UserDefaults.standard.set(lastName, forKey: "userLastName")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    UserDefaults.standard.set(true, forKey: "isDBUserCreated")
                    isLoggingIn = false
                }
            } catch {
                await MainActor.run {
                    otpError = error.localizedDescription
                    isLoggingIn = false
                }
            }
        }
    }

    @State private var isLoadingAuthState = false

    var body: some View {
        VStack(spacing: 24) {

            // Header
            VStack(spacing: 20) {
                Image("AppLogoColored")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text("Get started with Taskero")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)

            Spacer().frame(height: 20)

            // Mobile Number Input
            VStack(alignment: .leading, spacing: 10) {
                Text("Mobile number")
                    .foregroundColor(.gray)
                    .font(.subheadline)

                HStack(spacing: 12) {
                    // Country Code Picker Button
                    Button(action: { showCountryPicker = true }) {
                        HStack {
                            if let country = selectedCountry {
                                Text(country.flag).font(.title2)
                            } else {
                                Text("🏳️")
                            }
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(showPasswordField)

                    // Phone Number Field
                    HStack(spacing: 8) {
                        Text(selectedCountry?.dial_code ?? "")
                            .foregroundColor(.black)
                            .font(.body)

                        TextField("76 857 4082", text: $mobileNumber)
                            .keyboardType(.phonePad)
                            .disabled(showPasswordField)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)

            // Password Field (Conditional)
            if showPasswordField {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .foregroundColor(.gray)
                        .font(.subheadline)

                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .transition(.opacity)
            }

            // OTP send or Login error
            if let otpError {
                Text(otpError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Action Button
            Button(action: {
                if showPasswordField {
                    login()
                } else {
                    sendContinueAction()
                }
            }) {
                Group {
                    if isLoadingAuthState || isLoggingIn {
                        ProgressView().tint(.white)
                    } else {
                        Text(showPasswordField ? "Login" : "Continue")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(mobileNumber.isEmpty ? Color.gray.opacity(0.4) : mainColor)
                .cornerRadius(30)
            }
            .disabled(mobileNumber.isEmpty || isLoadingAuthState || isLoggingIn || (showPasswordField && password.isEmpty))
            .padding(.horizontal)

            // Back button if password field shown
            if showPasswordField {
                Button("Change number") {
                    withAnimation {
                        showPasswordField = false
                        password = ""
                    }
                }
                .foregroundColor(.gray)
                .font(.subheadline)
            }

            // Divider
            if !showPasswordField {
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("or").foregroundColor(.gray)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)

                // Social Login Buttons
                VStack(spacing: 16) {
                    SocialLoginButton(icon: "applelogo", text: "Continue with Apple") {
                        authService.signInWithApple()
                    }

                    SocialLoginButton(icon: "google_logo", text: "Continue with Google") {
                        authService.signInWithGoogle()
                    }

                    SocialLoginButton(icon: "envelope.fill", text: "Continue with Email") {
                        showEmailAuth = true
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .onTapGesture { hideKeyboard() }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(countries: countries, selectedCountry: $selectedCountry)
        }
        .sheet(isPresented: $showEmailAuth) {
            EmailAuthView()
                .environmentObject(authService)
        }
        .fullScreenCover(isPresented: $showOTPView) {
            OTPVerificationView(
                phoneNumber: fullPhoneNumber,
                verificationID: verificationID
            )
            .environmentObject(authService)
        }
        .onAppear { loadCountries() }
    }

    // MARK: - Helpers

    private func sendPhoneOTP() {
        // Obsolete, logic moved to sendContinueAction
    }

    func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countryCode", withExtension: "json") else {
            print("Configuration file 'countryCode.json' not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            countries = try JSONDecoder().decode([Country].self, from: data)
            if let lk = countries.first(where: { $0.code == "LK" }) {
                selectedCountry = lk
            } else {
                selectedCountry = countries.first
            }
        } catch {
            print("Error parsing country codes: \(error)")
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// Helper View for Social Buttons
struct SocialLoginButton: View {
    let icon: String
    let text: String
    var iconColor: Color = .black
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Determine if icon is SF Symbol or Asset based on common usage or checks.
                // For simplicity using SF Symbols where possible or assuming assets.
                // Apple and Envelope are SF Symbols. Google usually needs Asset.
                // Assuming SF Symbols for now as placeholders or system icons.
                if icon == "google_logo" {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else if icon == "g.circle.fill" {
                     // Legacy/Fallback check
                     Text("G")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(iconColor)
                }
                
                Text(text)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// Simple Country Picker Sheet
struct CountryPickerView: View {
    let countries: [Country]
    @Binding var selectedCountry: Country?
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredCountries) { country in
                Button(action: {
                    selectedCountry = country
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(country.flag)
                            .font(.largeTitle)
                        Text(country.name)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.gray)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Country")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthenticationService())
}
