//
//  AuthView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-11.
//

import SwiftUI

struct AuthView: View {
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @State private var mobileNumber: String = ""
    @State private var selectedCountry: Country?
    @State private var countries: [Country] = []
    @State private var showCountryPicker = false
    
    let mainColor = Color(red: 0/255, green: 191/255, blue: 99/255) // #00BF63
    
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
                    Button(action: {
                        showCountryPicker = true
                    }) {
                        HStack {
                            if let country = selectedCountry {
                                Text(country.flag)
                                    .font(.title2)
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
                    
                    // Phone Number Field
                    HStack(spacing: 8) {
                        Text(selectedCountry?.dial_code ?? "")
                            .foregroundColor(.black)
                            .font(.body)
                        
                        TextField("76 857 4082", text: $mobileNumber)
                            .keyboardType(.phonePad)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)
            
            // Continue Button
            Button(action: {
                completeAuth()
            }) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            
            // Divider
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
                    completeAuth()
                }
                
                SocialLoginButton(icon: "google_logo", text: "Continue with Google") { // Using SF Symbol for placeholder, ideally custom asset
                     completeAuth()
                }
                
                SocialLoginButton(icon: "envelope.fill", text: "Continue with Email") {
                    completeAuth()
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }

        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(countries: countries, selectedCountry: $selectedCountry)
        }
        .onAppear {
            loadCountries()
        }
    }
    
    func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countryCode", withExtension: "json") else {
            print("Configuration file 'countryCode.json' not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            countries = try decoder.decode([Country].self, from: data)
            // Default to Sri Lanka if available, or first one
            if let defaultCountry = countries.first(where: { $0.code == "LK" }) {
                selectedCountry = defaultCountry
            } else {
                selectedCountry = countries.first
            }
        } catch {
            print("Error parsing country codes: \(error)")
        }
    }
    

    
    func completeAuth() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
}
