//
//  AddressSelectionView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import SwiftUI

struct AddressSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var searchService = AddressSearchService()
    @State private var selectedTimePreference: TimePreference = .deliverNow
    @State private var selectedAddress: String = "2118 Thornridge California"
    var onSelect: ((String) -> Void)?
    
    enum TimePreference {
        case deliverNow
        case schedule
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Addresses")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Invisible spacer for balance
                Color.clear.frame(width: 24, height: 24)
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for an address", text: $searchService.query)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Search Results (shown when searching)
                    if !searchService.results.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Search Results")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(searchService.results) { result in
                                Button(action: {
                                    selectedAddress = result.place_name
                                    onSelect?(result.place_name)
                                    searchService.selectResult(result)
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    AddressRow(
                                        icon: "mappin.circle.fill",
                                        title: result.text,
                                        subtitle: result.place_name,
                                        showEdit: false
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // Quick Actions (hidden when searching)
                    if searchService.query.isEmpty {
                        HStack(spacing: 12) {
                            Button(action: {
                                let homeAddress = "Galwala Junction Bus Stop, Kudugala-Wattegama Rd"
                                onSelect?(homeAddress)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                QuickActionButton(icon: "house.fill", title: "Home", subtitle: "Galwala Juncti...")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            QuickActionButton(icon: "briefcase.fill", title: "Set work", subtitle: nil)
                            QuickActionButton(icon: "plus", title: "Add label", subtitle: nil)
                        }
                        .padding(.horizontal)
                        
                        // Explore Nearby
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Explore nearby")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            Button(action: {
                                let address = "115 John Rodrigo Mawatha, Moratuwa"
                                onSelect?(address)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                AddressRow(
                                    icon: "mappin.circle.fill",
                                    title: "115 John Rodrigo Mawatha",
                                    subtitle: "Moratuwa",
                                    showEdit: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Saved Addresses
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Saved addresses")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            Button(action: {
                                let address = "Galwala Junction Bus Stop, Kudugala-Wattegama Rd"
                                onSelect?(address)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                AddressRow(
                                    icon: "house.fill",
                                    title: "Home",
                                    subtitle: "Galwala Junction Bus Stop, Kudugala-Wattegama Rd",
                                    showEdit: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                let address = "Katugastota"
                                onSelect?(address)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                AddressRow(
                                    icon: "mappin.circle.fill",
                                    title: "Katugastota",
                                    subtitle: nil,
                                    showEdit: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                let address = "Galle"
                                onSelect?(address)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                AddressRow(
                                    icon: "mappin.circle.fill",
                                    title: "Galle",
                                    subtitle: nil,
                                    showEdit: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                let address = "148 John Rodrigo Mawatha, Moratuwa"
                                onSelect?(address)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                AddressRow(
                                    icon: "mappin.circle.fill",
                                    title: "148 John Rodrigo Mawatha",
                                    subtitle: "Moratuwa",
                                    showEdit: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Time Preference
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Time preference")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                TimePreferenceButton(
                                    icon: "clock.fill",
                                    title: "Deliver now",
                                    isSelected: selectedTimePreference == .deliverNow
                                ) {
                                    selectedTimePreference = .deliverNow
                                }
                                
                                TimePreferenceButton(
                                    icon: nil,
                                    title: "Schedule",
                                    isSelected: selectedTimePreference == .schedule
                                ) {
                                    selectedTimePreference = .schedule
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer().frame(height: 40)
                }
                .padding(.top)
            }
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarHidden(true)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

struct AddressRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let showEdit: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if showEdit {
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct TimePreferenceButton: View {
    let icon: String?
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.body)
                }
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .black : .gray)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(UIColor.systemGray6) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color(UIColor.systemGray4), lineWidth: 1)
            )
        }
    }
}

#Preview {
    AddressSelectionView()
}
