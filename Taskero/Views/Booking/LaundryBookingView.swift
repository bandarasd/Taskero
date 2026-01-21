//
//  LaundryBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct LaundryBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var clothingWeight = ""
    @State private var includeIroning = false
    @State private var includeFragrance = false
    @State private var fragranceType = "Lavender"
    @State private var fabricType: FabricType = .regular
    @State private var jobDetails = ""
    
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
            .padding(.top, 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Enter weight and service details.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Weight Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weight Total Clothing")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            TextField("12", text: $clothingWeight)
                                .keyboardType(.decimalPad)
                            
                            Text("kg")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Fabric Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fabric Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Fabric", selection: $fabricType) {
                            ForEach(FabricType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Ironing Service Dropdown
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ironing Service")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Menu {
                            Button("Yes", action: { includeIroning = true })
                            Button("No", action: { includeIroning = false })
                        } label: {
                            HStack {
                                Text(includeIroning ? "Yes" : "No")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down") // or triangle.fill
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Fragrance Service Dropdown
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fragrance Service")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Menu {
                            Button("Yes", action: { includeFragrance = true })
                            Button("No", action: { includeFragrance = false })
                        } label: {
                            HStack {
                                Text(includeFragrance ? "Yes" : "No")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    
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
                    }
                    
                    Spacer().frame(height: 100)
                }
                .padding()
            }
            
            // Bottom Action Bar
            bottomBar
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var bottomBar: some View {
        let weightPrice = (Double(clothingWeight) ?? 0) * fabricType.ratePerKg
        let ironingPrice = includeIroning ? 10.0 : 0.0
        let totalPrice = Int(weightPrice + ironingPrice + 5.0) // +5 Base fee
        
        return VStack {
            NavigationLink(destination: BookingDetailsView(service: service, totalPrice: totalPrice)) {
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
}

enum FabricType: String, CaseIterable {
    case regular = "Regular"
    case delicate = "Delicate"
    case bedding = "Bedding"
    
    var ratePerKg: Double {
        switch self {
        case .regular: return 2.0
        case .delicate: return 4.0
        case .bedding: return 3.0
        }
    }
}

#Preview {
    LaundryBookingView(service: ServiceItem(
        title: "Laundry Services",
        price: "$95",
        originalPrice: "",
        rating: "4.8",
        provider: "Laundry Co.",
        imageColor: .purple,
        imageName: nil
    ))
}
