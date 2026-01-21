//
//  PaymentMethodsView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct PaymentMethodsView: View {
    let service: ServiceItem
    let totalPrice: Int
    let selectedDate: Date
    let selectedTime: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMethod: PaymentMethod = .paypal
    
    enum PaymentMethod: String, CaseIterable, Identifiable {
        case paypal = "PayPal"
        case googlePay = "Google Pay"
        case applePay = "Apple Pay"
        case mastercard = "MasterCard"
        case cash = "Cash Money"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .paypal: return "dollarsign.circle.fill" // Placeholder, in real app use assets
            case .googlePay: return "g.circle.fill"
            case .applePay: return "applelogo"
            case .mastercard: return "creditcard.fill"
            case .cash: return "banknote.fill"
            }
        }
        
        // Helper for custom image assets if available
        var imageName: String? {
            switch self {
            case .paypal: return "paypal_logo"
            case .googlePay: return "google_pay_logo"
            case .applePay: return "apple_pay_logo"
            case .mastercard: return "mastercard_logo"
            case .cash: return "cash_icon"
            }
        }
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
                Text("Payment Methods")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                // Empty view for balancing
                Color.clear.frame(width: 24, height: 24)
            }
            .padding()
            .padding(.top, 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Select the payment method you want to use")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(PaymentMethod.allCases) { method in
                            PaymentMethodRow(method: method, isSelected: selectedMethod == method) {
                                selectedMethod = method
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Bottom Button
            VStack {
                NavigationLink(destination: ReviewSummaryView(
                    service: service,
                    totalPrice: totalPrice,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    paymentMethod: selectedMethod.rawValue
                )) {
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
}

struct PaymentMethodRow: View {
    let method: PaymentMethodsView.PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                if method == .mastercard {
                    // Specific design for mastercard row
                     Image(systemName: method.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.red) // distinct color
                    
                    Text(".... .... .... 4679")
                        .font(.headline)
                        .foregroundColor(.black)
                } else {
                    Image(systemName: method.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                    
                    Text(method.rawValue)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Radio Button
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.brandGreen : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.brandGreen)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
