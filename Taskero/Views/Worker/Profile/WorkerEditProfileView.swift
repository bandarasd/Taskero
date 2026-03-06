//
//  WorkerEditProfileView.swift
//  Taskero
//

import SwiftUI

struct WorkerEditProfileView: View {

    let mainColor = Color.brandGreen
    @Environment(\.presentationMode) var presentationMode

    // Editable state
    @State private var name: String = MockData.currentWorker.name
    @State private var phone: String = "(555) 890-1234"
    @State private var bio: String = "Professional cleaning specialist with 5+ years of experience. I provide reliable, thorough service and take great care of your home."
    @State private var hourlyRate: String = "45"
    @State private var yearsOfExperience: String = "5"

    // Services offered
    @State private var offersCleaning     = true
    @State private var offersPlumbing     = true
    @State private var offersPainting     = false
    @State private var offersElectrical   = false
    @State private var offersAssembly     = true
    @State private var offersGardening    = false

    @State private var showSavedAlert = false

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
                Text("Edit Profile")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button(action: saveProfile) {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(mainColor)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)

            ScrollView {
                VStack(spacing: 24) {

                    // Profile Photo
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(mainColor.opacity(0.15))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(mainColor)
                                )
                                .shadow(radius: 4)

                            Button(action: {}) {
                                ZStack {
                                    Circle()
                                        .fill(mainColor)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        Text("Tap to change photo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // Personal Info
                    FormSection(title: "Personal Information") {
                        LabeledTextField(label: "Full Name", placeholder: "Your name", text: $name, icon: "person.fill")
                        Divider().padding(.leading, 44)
                        LabeledTextField(label: "Phone Number", placeholder: "Your phone", text: $phone, icon: "phone.fill", keyboardType: .phonePad)
                        Divider().padding(.leading, 44)
                        LabeledTextEditor(label: "About / Bio", placeholder: "Tell customers about yourself...", text: $bio, icon: "text.alignleft")
                    }

                    // Professional Info
                    FormSection(title: "Professional Information") {
                        LabeledTextField(label: "Hourly Rate ($)", placeholder: "e.g. 45", text: $hourlyRate, icon: "dollarsign.circle.fill", keyboardType: .numberPad)
                        Divider().padding(.leading, 44)
                        LabeledTextField(label: "Years of Experience", placeholder: "e.g. 5", text: $yearsOfExperience, icon: "clock.fill", keyboardType: .numberPad)
                    }

                    // Services
                    FormSection(title: "Services I Offer") {
                        ServiceOfferToggle(title: "House Cleaning",     icon: "house.fill",       color: .brandGreen, isOn: $offersCleaning)
                        Divider().padding(.leading, 44)
                        ServiceOfferToggle(title: "Plumbing",           icon: "wrench.fill",       color: .blue,       isOn: $offersPlumbing)
                        Divider().padding(.leading, 44)
                        ServiceOfferToggle(title: "Painting",           icon: "paintbrush.fill",   color: .orange,     isOn: $offersPainting)
                        Divider().padding(.leading, 44)
                        ServiceOfferToggle(title: "Electrical",         icon: "bolt.fill",         color: .yellow,     isOn: $offersElectrical)
                        Divider().padding(.leading, 44)
                        ServiceOfferToggle(title: "Furniture Assembly", icon: "hammer.fill",       color: .brown,      isOn: $offersAssembly)
                        Divider().padding(.leading, 44)
                        ServiceOfferToggle(title: "Gardening",          icon: "leaf.fill",         color: .green,      isOn: $offersGardening)
                    }

                    // Save Button
                    Button(action: saveProfile) {
                        Text("Save Changes")
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
                .padding(.top, 16)
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showSavedAlert) {
            Alert(title: Text("Saved!"), message: Text("Your profile has been updated."), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveProfile() {
        showSavedAlert = true
    }
}

// MARK: - Reusable Form Components

private struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.leading, 4)
                .padding(.horizontal)

            VStack(spacing: 0) {
                content()
            }
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
}

private struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .font(.subheadline)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.vertical, 12)
    }
}

private struct LabeledTextEditor: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .frame(width: 22)
                .padding(.top, 14)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                TextEditor(text: $text)
                    .font(.subheadline)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
        }
        .padding(.bottom, 8)
    }
}

private struct ServiceOfferToggle: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            Text(title)
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.brandGreen)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    WorkerEditProfileView()
}
