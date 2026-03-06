//
//  BookingsView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct BookingsView: View {
    @State private var selectedStatus: BookingStatus = .ongoing
    
    // Use centralized mock data
    @State private var bookings: [Booking] = MockData.bookings
    @State private var orderDetails: [OrderDetail] = MockData.orderDetails

    
    var filteredBookings: [Booking] {
        bookings.filter { $0.status == selectedStatus }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Bookings")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                // Segmented Control / Tabs
                HStack(spacing: 0) {
                    ForEach(BookingStatus.allCases, id: \.self) { status in
                        VStack(spacing: 8) {
                            Text(status.rawValue)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedStatus == status ? .brandGreen : .gray)
                            
                            Rectangle()
                                .fill(selectedStatus == status ? Color.brandGreen : Color.clear)
                                .frame(height: 3)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                selectedStatus = status
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                
                // List of Bookings
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredBookings) { booking in
                            if let orderDetail = orderDetails.first(where: { $0.booking.serviceName == booking.serviceName }) {
                                NavigationLink(destination: OrderDetailsView(orderDetail: orderDetail)) {
                                    BookingCard(booking: booking, orderDetail: orderDetail)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                BookingCard(booking: booking, orderDetail: nil)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.05))
            }
            .navigationBarHidden(true)
        }
    }
}

struct BookingCard: View {
    let booking: Booking
    let orderDetail: OrderDetail?
    
    var body: some View {
        VStack(spacing: 16) {
            // Header: Service Info & Status
            HStack(alignment: .top) {
                // Image
                if let imageName = booking.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                } else {
                    Image(systemName: "wrench.fill") // Placeholder
                        .font(.largeTitle)
                        .foregroundColor(booking.imageColor ?? .gray)
                        .frame(width: 80, height: 80)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(booking.serviceName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(booking.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Provider
                    HStack(spacing: 8) {
                        if let providerImage = booking.providerImage, UIImage(named: providerImage) != nil {
                            Image(providerImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 20, height: 20)
                                Text(booking.providerName.prefix(1))
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text(booking.providerName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Status Label
                Text(booking.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(booking.status.backgroundColor)
                    .foregroundColor(booking.status.color)
                    .cornerRadius(8)
            }
            
            Divider()
            
            // Footer: Date/Time & Price
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date & Time")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(formatDate(booking.date)) | \(booking.time)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // Action Button or Price
                if booking.status == .upcoming {
                    // E.g., View Receipt or Cancel
                     Text("$\(String(format: "%.2f", booking.price))")
                        .font(.headline)
                } else {
                     Text("$\(String(format: "%.2f", booking.price))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 5)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
