//
//  PaintingBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct PaintingBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var areaSize: Double = 50 // sqm
    @State private var includeCeiling = false
    @State private var wallCondition: WallCondition = .good
    @State private var paintProvided = "No"
    @State private var jobDetails = ""
    
    var price: Int {
        let baseRate = 15.0 // per sqm
        let ceilingRate = includeCeiling ? 5.0 : 0.0
        let conditionMultiplier: Double = {
            switch wallCondition {
            case .good: return 1.0
            case .fair: return 1.2
            case .poor: return 1.5
            }
        }()
        
        let total = (areaSize * (baseRate + ceilingRate)) * conditionMultiplier
        return Int(total)
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
                    Text("Estimate the area and wall condition.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Area Size
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Wall Area")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(Int(areaSize)) sqm")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.brandGreen)
                        }
                        
                        Slider(value: $areaSize, in: 10...500, step: 10)
                            .accentColor(.brandGreen)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                    
                    // Ceiling
                    Toggle("Include Ceiling Painting", isOn: $includeCeiling)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                     
                     // Wall Condition
                     VStack(alignment: .leading, spacing: 10) {
                         Text("Wall Condition")
                             .font(.headline)
                             .fontWeight(.bold)
                         
                         Picker("Condition", selection: $wallCondition) {
                             ForEach(WallCondition.allCases, id: \.self) { condition in
                                 Text(condition.rawValue).tag(condition)
                             }
                         }
                         .pickerStyle(SegmentedPickerStyle())
                     }
                     
                    // Paint Provided
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Do you have the paint?")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Paint", selection: $paintProvided) {
                            Text("No, Tasker should bring").tag("No")
                            Text("Yes, I have it").tag("Yes")
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
            NavigationLink(destination: BookingDetailsView(service: service, totalPrice: price, serviceDetails: ServiceDetails())) {
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

enum WallCondition: String, CaseIterable {
    case good = "Good (Minor Prep)"
    case fair = "Fair (Some Holes)"
    case poor = "Poor (Peeling/Bad)"
}

#Preview {
    PaintingBookingView(service: ServiceItem(
        title: "Wall Painting",
        price: "$500",
        originalPrice: "",
        rating: "4.5",
        provider: "ColorWorld",
        imageColor: .green,
        imageName: nil,
        type: .painting
    ))
}
