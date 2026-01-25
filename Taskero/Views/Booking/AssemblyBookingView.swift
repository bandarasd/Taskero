//
//  AssemblyBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct AssemblyBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var itemCount = 1
    @State private var itemType = "Furniture"
    @State private var complexity: AssemblyComplexity = .medium
    @State private var jobDetails = ""
    
    var price: Int {
        let basePrice = 50.0
        let complexityRate = complexity.rate
        return Int((basePrice + complexityRate) * Double(itemCount))
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
                    Text("Select items and complexity.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Item Count
                    HStack {
                        Text("Number of Items")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Stepper(value: $itemCount, in: 1...20) {
                            Text("\(itemCount)")
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Item Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Item Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        TextField("e.g. Desk, Chair, Bed", text: $itemType)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                    }
                    
                    // Complexity
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Complexity")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Complexity", selection: $complexity) {
                            ForEach(AssemblyComplexity.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
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
            VStack {
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
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

enum AssemblyComplexity: String, CaseIterable {
    case simple = "Simple"
    case medium = "Medium"
    case complex = "Complex"
    
    var rate: Double {
        switch self {
        case .simple: return 20.0
        case .medium: return 50.0
        case .complex: return 100.0
        }
    }
}

#Preview {
    AssemblyBookingView(service: ServiceItem(
        title: "Furniture Assembly",
        price: "$100",
        originalPrice: "",
        rating: "4.5",
        provider: "FixItAll",
        imageColor: .brown,
        imageName: nil,
        type: .general 
    ))
}
