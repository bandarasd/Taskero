//
//  OTPVerificationView.swift
//  Taskero
//

import SwiftUI

struct OTPVerificationView: View {

    @EnvironmentObject var authService: AuthenticationService
    @Environment(\.dismiss) private var dismiss

    let phoneNumber: String
    let verificationID: String

    @State private var otpCode: String = ""
    @FocusState private var isFieldFocused: Bool

    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255)

    var body: some View {
        VStack(spacing: 28) {

            // Logo
            Image("AppLogoColored")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(.top, 48)

            // Title
            VStack(spacing: 8) {
                Text("Verify your number")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter the 6-digit code sent to\n\(phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            // OTP Input
            TextField("", text: $otpCode)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .semibold, design: .monospaced))
                .tracking(12)
                .frame(maxWidth: 240)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($isFieldFocused)
                .onChange(of: otpCode) { _, newValue in
                    // Strip non-digits and cap at 6
                    let digits = newValue.filter(\.isNumber)
                    otpCode = String(digits.prefix(6))
                }

            // Error
            if let error = authService.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Verify Button
            Button {
                Task {
                    await authService.verifyOTP(verificationID: verificationID, code: otpCode)
                }
            } label: {
                Group {
                    if authService.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Verify")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(otpCode.count == 6 ? mainColor : Color.gray.opacity(0.4))
                .cornerRadius(30)
            }
            .disabled(otpCode.count < 6 || authService.isLoading)
            .padding(.horizontal)

            // Change number
            Button("Change number") {
                authService.errorMessage = nil
                dismiss()
            }
            .foregroundColor(.gray)
            .font(.subheadline)

            Spacer()
        }
        .padding()
        .onAppear { isFieldFocused = true }
        .onTapGesture { isFieldFocused = false }
    }
}

#Preview {
    OTPVerificationView(phoneNumber: "+94 76 857 4082", verificationID: "preview")
        .environmentObject(AuthenticationService())
}
