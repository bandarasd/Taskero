//
//  PlumbingBookingView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct PlumbingBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    
    @State private var issueType: PlumbingIssueType = .leak
    @State private var isUrgent = false
    @State private var jobDetails = ""
    
    var price: Int {
        let basePrice = issueType.basePrice
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
                    Text("Describe your plumbing issue.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Issue Type
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Issue Type")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Picker("Issue", selection: $issueType) {
                            ForEach(PlumbingIssueType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
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
            // Dismiss keyboard
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

enum PlumbingIssueType: String, CaseIterable {
    case leak = "Leak Repair"
    case clog = "Drain Clog"
    case install = "Installation"
    case maintenance = "Maintenance"
    case other = "Other"
    
    var basePrice: Double {
        switch self {
        case .leak: return 80.0
        case .clog: return 60.0
        case .install: return 100.0
        case .maintenance: return 50.0
        case .other: return 50.0
        }
    }
}

#Preview {
    PlumbingBookingView(service: ServiceItem(
        title: "Plumbing Repairing",
        price: "$85",
        originalPrice: "",
        rating: "4.8",
        provider: "Mario Bros",
        imageColor: .red,
        imageName: nil
    ))
}
