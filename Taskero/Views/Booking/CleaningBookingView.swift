//
//  CleaningBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

enum CleaningType: String, CaseIterable {
    case standard = "Standard"
    case deep = "Deep Cleaning"
    case moveInOut = "Move In/Out"
}

enum DirtLevel: String, CaseIterable {
    case light = "Light"
    case medium = "Medium"
    case heavy = "Heavy"
}

struct CleaningExtra: Identifiable, Hashable, CaseIterable {
    let id = UUID()
    let rawValue: String
    let price: Double

    static let allCases: [CleaningExtra] = [
        .init(rawValue: "Window Cleaning", price: 25.0),
        .init(rawValue: "Oven Cleaning", price: 30.0),
        .init(rawValue: "Fridge Cleaning", price: 20.0),
        .init(rawValue: "Laundry Service", price: 40.0),
        .init(rawValue: "Carpet Shampoo", price: 35.0)
    ]
}

struct CleaningBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    // Room counts
    @State private var areaSize: Double = 50 // sqm
    @State private var cleaningType: CleaningType = .standard
    @State private var dirtLevel: DirtLevel = .medium
    @State private var bathroomCount = 1
    @State private var isUrgent = false
    @State private var selectedExtras: Set<CleaningExtra> = []
    
    @State private var jobDetails = ""
    
    // Pricing Logic
    var totalPrice: Int {
        let baseRatePerSqm = 2.0
        let areaPrice = areaSize * baseRatePerSqm
        
        let typeMultiplier: Double = {
            switch cleaningType {
            case .standard: return 1.0
            case .deep: return 1.5
            case .moveInOut: return 2.0
            }
        }()
        
        let dirtMultiplier: Double = {
            switch dirtLevel {
            case .light: return 1.0
            case .medium: return 1.2
            case .heavy: return 1.5
            }
        }()
        
        let bathroomPrice = Double(bathroomCount) * 20.0
        let urgencyFee = isUrgent ? 30.0 : 0.0
        let extrasPrice = selectedExtras.reduce(0) { $0 + $1.price }
        
        let total = (areaPrice * typeMultiplier * dirtMultiplier) + bathroomPrice + urgencyFee + extrasPrice
        return Int(total)
    }
    
    // Service Details for Review Summary
    var serviceDetails: ServiceDetails {
        var items: [(label: String, value: String)] = []
        
        items.append(("Area Size", "\(Int(areaSize)) sqm"))
        items.append(("Cleaning Type", cleaningType.rawValue))
        items.append(("Dirt Level", dirtLevel.rawValue))
        items.append(("Bathrooms", "\(bathroomCount)"))
        items.append(("Urgent Request", isUrgent ? "Yes" : "No"))
        
        if !selectedExtras.isEmpty {
            let extrasString = selectedExtras.map { $0.rawValue }.joined(separator: ", ")
            items.append(("Extras", extrasString))
        }
        
        if !jobDetails.isEmpty {
            items.append(("Job Details", jobDetails))
        }
        
        return ServiceDetails(items: items)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(service.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(8)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
            .padding()
            .padding(.top, 40) // Status bar space
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Customize your cleaning service for an accurate price.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Area Size
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Area Size")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(Int(areaSize)) sqm")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.brandGreen)
                        }
                        
                        Slider(value: $areaSize, in: 20...500, step: 10)
                            .accentColor(.brandGreen)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                    
                    // Cleaning Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cleaning Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Type", selection: $cleaningType) {
                            ForEach(CleaningType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Dirt Level
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dirt Level")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Dirt", selection: $dirtLevel) {
                            ForEach(DirtLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Bathrooms
                    HStack {
                        Text("Number of Bathrooms")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Stepper(value: $bathroomCount, in: 1...10) {
                            Text("\(bathroomCount)")
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Urgency
                    Toggle("Urgent / Same Day Request", isOn: $isUrgent)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                    
                    // Extras
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Extras")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ForEach(CleaningExtra.allCases, id: \.self) { extra in
                            HStack {
                                Text(extra.rawValue)
                                Spacer()
                                Text("+$\(Int(extra.price))")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                Image(systemName: selectedExtras.contains(extra) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedExtras.contains(extra) ? .brandGreen : .gray)
                                    .font(.title3)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
                            .onTapGesture {
                                if selectedExtras.contains(extra) {
                                    selectedExtras.remove(extra)
                                } else {
                                    selectedExtras.insert(extra)
                                }
                            }
                        }
                    }
                    
                    // Job Details
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Job Details")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        TextEditor(text: $jobDetails)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.clear, lineWidth: 1))
                        
                        if jobDetails.isEmpty {
                            // Placeholder
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 100)
                }
                .padding()
            }
            
            // Bottom Action Bar
            VStack {
                NavigationLink(destination: BookingDetailsView(service: service, totalPrice: totalPrice, serviceDetails: serviceDetails)) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandGreen)
                    .cornerRadius(24)
            }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
    
    private func roomCounterRow(title: String, count: Binding<Int>) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    if count.wrappedValue > 0 {
                        count.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.headline)
                        .foregroundColor(count.wrappedValue > 0 ? Color.brandGreen : .gray)
                        .frame(width: 32, height: 32)
                        .background(Color.brandGreen.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Text("\(count.wrappedValue)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: 20)
                
                Button(action: {
                    count.wrappedValue += 1
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(Color.brandGreen)
                        .frame(width: 32, height: 32)
                        .background(Color.brandGreen.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}



// Preview to verify locally
#Preview {
    CleaningBookingView(service: ServiceItem(
        title: "House Cleaning",
        price: "$20",
        originalPrice: "",
        rating: "4.8",
        provider: "Jenny Wilson",
        imageColor: .green,
        imageName: nil
    ))
}
