//
//  ReviewSummaryView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct ReviewSummaryView: View {
    let service: ServiceItem
    let totalPrice: Int
    let selectedDate: Date
    let selectedTime: String
    let paymentMethod: String
    let selectedLocation: String
    let serviceDetails: ServiceDetails
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showSuccessModal = false
    @State private var isServiceDetailsExpanded = false
    
    // Mock Data
    private let promoDiscount = 37.50
    private var totalAmount: Double {
        Double(totalPrice) - promoDiscount
    }
    
    var body: some View {
        ZStack {
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
                    Text("Review Summary")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding()
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Booking Details Card (Top Section)
                        VStack(spacing: 16) {
                            DetailRow(label: "Service", value: service.title)
                            DetailRow(label: "Category", value: service.type.rawValue)
                            DetailRow(label: "Workers", value: "Jenny Wilson") // Mock worker
                            DetailRow(label: "Date & Time", value: "\(formatDate(selectedDate)) | \(selectedTime)")
                            DetailRow(label: "Working Hours", value: "2 hours") // Mock hours
                            DetailRow(label: "Location", value: selectedLocation)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        // Service Details Accordion (Service-Specific Info Only)
                        VStack(spacing: 0) {
                            // Header
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    isServiceDetailsExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text("\(service.title) Details")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .rotationEffect(.degrees(isServiceDetailsExpanded ? 180 : 0))
                                }
                                .padding()
                            }
                            
                            // Expandable Content - User Selected Service Details
                            if isServiceDetailsExpanded {
                                VStack(spacing: 12) {
                                    Divider()
                                        .padding(.horizontal)
                                    
                                    ForEach(serviceDetails.items.indices, id: \.self) { index in
                                        DetailRow(label: serviceDetails.items[index].label, value: serviceDetails.items[index].value)
                                            .padding(.horizontal)
                                    }
                                }
                                .padding(.bottom, 12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                        
                        // Pricing Details
                        VStack(spacing: 16) {
                            HStack {
                                Text(service.title)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("$\(String(format: "%.2f", Double(totalPrice)))")
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                Text("Promo")
                                    .foregroundColor(.brandGreen)
                                Spacer()
                                Text("- $\(String(format: "%.2f", promoDiscount))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.brandGreen)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text("$\(String(format: "%.2f", totalAmount))")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        // Payment Method
                        HStack {
                            // Display custom payment icon
                            if let iconName = getPaymentIcon(for: paymentMethod) {
                                Image(iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 32)
                            } else {
                                Image(systemName: "creditcard.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.orange)
                            }
                            
                            if paymentMethod == "MasterCard" {
                                Text(".... .... .... 4679")
                                    .fontWeight(.bold)
                            } else {
                                Text(paymentMethod)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            Button("Change") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(.brandGreen)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical)
                }
                
                // Confirm Payment Button
                VStack {
                    Button(action: {
                        showSuccessModal = true
                    }) {
                        Text("Confirm Payment")
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
            .opacity(showSuccessModal ? 0.3 : 1) // Dim background when modal is up
            
            // Payment Success Modal Overlay
            if showSuccessModal {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Optional: dismiss on tap outside
                    }
                
                PaymentSuccessView(onDismiss: {
                   // Navigate to home or Reset flow.
                   // For now, let's just dismiss the modal or pop to root.
                   // Ideally we need a way to pop to root.
                   // We will implement a basic dismiss for now.
                   showSuccessModal = false
                   // In a real app we would navigate to Home view here
                })
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    // Map payment method string to icon asset name
    private func getPaymentIcon(for method: String) -> String? {
        switch method {
        case "PayPal":
            return "paypal"
        case "Google Pay":
            return "google_pay"
        case "Apple Pay":
            return "apple_pay"
        case "MasterCard":
            return "mastercard"
        case "Cash Money":
            return "cash_icon"
        default:
            return nil
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .font(.subheadline)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .font(.subheadline)
        }
    }
}
