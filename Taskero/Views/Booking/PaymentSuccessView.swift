//
//  PaymentSuccessView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct PaymentSuccessView: View {
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.brandGreen)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)
            
            // Text Content
            VStack(spacing: 12) {
                Text("Booking Successful!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandGreen)
                
                Text("You have successfully made payment\nand book the services.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Action for viewing receipt
                }) {
                    Text("View E-Receipt")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandGreen)
                        .cornerRadius(30)
                }
                
                Button(action: {
                    // Action for messaging workers
                }) {
                    Text("Message Workers")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.brandGreen)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandGreen.opacity(0.1))
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
        }
        .frame(maxWidth: 340)
        .background(Color.white)
        .cornerRadius(40)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        
        // Add overlay bubbles similar to design if needed, simpler for now.
        .overlay(
             // Decorative bubbles
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.brandGreen.opacity(0.6))
                        .frame(width: 20, height: 20)
                        .position(x: 40, y: 50)
                    
                    Circle()
                        .fill(Color.brandGreen.opacity(0.4))
                        .frame(width: 15, height: 15)
                        .position(x: 300, y: 80)
                    
                     Circle()
                        .fill(Color.brandGreen.opacity(0.5))
                        .frame(width: 10, height: 10)
                        .position(x: 280, y: 200)
                }
            }
        )
    }
}
