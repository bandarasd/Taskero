//
//  RepairBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct RepairBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var applianceType: ApplianceType = .ac
    @State private var brand = ""
    @State private var issueDescription = ""
    @State private var isUrgent = false
    
    var price: Int {
        let basePrice = applianceType.basePrice
        let urgencyFee = isUrgent ? 40.0 : 0.0
        return Int(basePrice + urgencyFee)
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
            .padding(.top, 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Select appliance and describe issue.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Appliance Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Appliance Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Appliance", selection: $applianceType) {
                            ForEach(ApplianceType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Brand
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Brand / Model (Optional)")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        TextField("e.g. Samsung, LG", text: $brand)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                    }
                    
                    // Urgency
                    Toggle("Urgent / Emergency", isOn: $isUrgent)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Issue Description")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        TextEditor(text: $issueDescription)
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
        return VStack {
            NavigationLink(destination: BookingDetailsView(service: service, totalPrice: price)) {
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



enum ApplianceType: String, CaseIterable {
    case ac = "Air Conditioner"
    case fridge = "Refrigerator"
    case washer = "Washing Machine"
    case microwave = "Microwave"
    case other = "Other"
    
    var basePrice: Double {
        switch self {
        case .ac: return 60.0
        case .fridge: return 70.0
        case .washer: return 65.0
        case .microwave: return 40.0
        case .other: return 50.0
        }
    }
}

#Preview {
    RepairBookingView(service: ServiceItem(
        title: "AC Service & Repair",
        price: "$50",
        originalPrice: "",
        rating: "4.6",
        provider: "James",
        imageColor: .cyan,
        imageName: nil,
        type: .repairing
    ))
}
