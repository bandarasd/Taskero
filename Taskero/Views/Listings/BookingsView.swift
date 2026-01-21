//
//  BookingsView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct BookingsView: View {
    @State private var selectedStatus: BookingStatus = .upcoming
    
    // Mock Data
    @State private var bookings: [Booking] = [
        Booking(serviceName: "House Cleaning", category: "Cleaning", providerName: "Jenny Wilson", date: Date(), time: "10:00 AM", status: .upcoming, price: 87.50, imageName: nil, imageColor: .brandGreen),
        Booking(serviceName: "AC Repair", category: "Repairing", providerName: "Guy Hawkins", date: Date().addingTimeInterval(-86400 * 2), time: "02:00 PM", status: .completed, price: 120.00, imageName: nil, imageColor: .orange),
        Booking(serviceName: "Painting", category: "Painting", providerName: "Robert Fox", date: Date().addingTimeInterval(-86400 * 5), time: "09:00 AM", status: .canceled, price: 250.00, imageName: nil, imageColor: .blue),
         Booking(serviceName: "Laundry", category: "Laundry", providerName: "Albert Flores", date: Date().addingTimeInterval(86400 * 3), time: "11:00 AM", status: .upcoming, price: 45.00, imageName: nil, imageColor: .purple)
    ]
    
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
                            BookingCard(booking: booking)
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
    
    var body: some View {
        VStack(spacing: 16) {
            // Header: Service Info & Status
            HStack(alignment: .top) {
                // Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(booking.imageColor?.opacity(0.2) ?? Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    if let imageName = booking.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } else {
                         Image(systemName: "wrench.fill") // Placeholder
                            .font(.title)
                            .foregroundColor(booking.imageColor ?? .gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(booking.serviceName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(booking.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Provider
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text(booking.providerName) // Could be "Waiting for provider" if empty
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
                        .fontWeight(.bold)
                        .foregroundColor(.brandGreen)
                } else if booking.status == .completed {
                     Text("Re-Book")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.brandGreen)
                        .cornerRadius(16)
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
