//
//  EditProfileView.swift
//  Taskero
//
//  Created by Antigravity on 2026-01-25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var profile: UserProfile
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    
    init(profile: Binding<UserProfile>) {
        self._profile = profile
        _name = State(initialValue: profile.wrappedValue.name)
        _email = State(initialValue: profile.wrappedValue.email)
        _phone = State(initialValue: profile.wrappedValue.phone)
        _address = State(initialValue: profile.wrappedValue.address)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Avatar selection
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let imageName = profile.profileImage {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(mainColor.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(mainColor)
                                    )
                            }
                            
                            Circle()
                                .fill(mainColor)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        Text("Change Profile Picture")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(mainColor)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Form fields
                    VStack(alignment: .leading, spacing: 20) {
                        CustomTextField(label: "Full Name", text: $name, placeholder: "Enter your name")
                        CustomTextField(label: "Email", text: $email, placeholder: "Enter your email", keyboardType: .emailAddress)
                        CustomTextField(label: "Phone Number", text: $phone, placeholder: "Enter your phone", keyboardType: .phonePad)
                        CustomTextField(label: "Address", text: $address, placeholder: "Enter your address")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // MARK: - Save Button
                    Button(action: {
                        profile.name = name
                        profile.email = email
                        profile.phone = phone
                        profile.address = address
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Changes")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(mainColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
        }
    }
}

#Preview {
    EditProfileView(profile: .constant(UserProfile.mock))
}
