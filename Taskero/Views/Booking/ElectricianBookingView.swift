//
//  ElectricianBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct ElectricianBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var numberOfPoints = ""

    @State private var fixtureType: ElectricianFixtureType = .light
    @State private var isUrgent = false
    @State private var jobDetails = ""
    
    var price: Int {
        let points = Int(numberOfPoints) ?? 1
        let baseRate = fixtureType.ratePerPoint
        let urgencyFee = isUrgent ? 30.0 : 0.0
        return Int(Double(points) * baseRate + urgencyFee)
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
                    Text("Details about electrical work.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Fixture Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fixture / Issue Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Type", selection: $fixtureType) {
                            ForEach(ElectricianFixtureType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Number of Points
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Number of Points/Units")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        TextField("e.g. 5", text: $numberOfPoints)
                            .keyboardType(.numberPad)
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



enum ElectricianFixtureType: String, CaseIterable {
    case light = "Light Fixture"
    case fan = "Ceiling Fan"
    case switchSocket = "Switch/Socket"
    case wiring = "Wiring Check"
    case other = "Other"
    
    var ratePerPoint: Double {
        switch self {
        case .light: return 20.0
        case .fan: return 30.0
        case .switchSocket: return 15.0
        case .wiring: return 50.0 // Base
        case .other: return 40.0 // Base
        }
    }
}

#Preview {
    ElectricianBookingView(service: ServiceItem(
        title: "Electric Wiring",
        price: "$150",
        originalPrice: "",
        rating: "4.7",
        provider: "Sparky",
        imageColor: .orange,
        imageName: nil,
        type: .general // Will be updated to electrician
    ))
}
