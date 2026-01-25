//
//  BookingDetailsView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

struct BookingDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem
    let totalPrice: Int
    let serviceDetails: ServiceDetails
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedTime = "10:00 AM"

    
    let timeSlots = ["09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM"]
    
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
                
                VStack(spacing: 4) {
                    Text("Booking Details")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Starting from $\(totalPrice)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
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
                    Text("Select Date")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    // Month Calendar View (Custom Implementation to match design)
                    VStack(spacing: 20) {
                        // Month Header
                        HStack {
                            Text(currentMonth.formatted(.dateTime.month().year()))
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            HStack(spacing: 20) {
                                Button(action: { changeMonth(by: -1) }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.black)
                                }
                                Button(action: { changeMonth(by: 1) }) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.brandGreen)
                                }
                            }
                        }
                        
                        // Days Header
                        HStack {
                            ForEach(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Days Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                            ForEach(daysInMonth(), id: \.self) { date in
                                if let date = date {
                                    DayCell(date: date, isSelected: isSameDay(date, selectedDate))
                                        .onTapGesture {
                                            selectedDate = date
                                        }
                                } else {
                                    Text("") // Placeholder for empty days
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.brandGreen.opacity(0.05)) // Light purple/green bg
                    .cornerRadius(20)
                    

                    
                    // Start Time
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Choose Start Time")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(timeSlots, id: \.self) { time in
                                    Text(time)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(selectedTime == time ? Color.brandGreen : Color.white)
                                        .foregroundColor(selectedTime == time ? .white : .black)
                                        .cornerRadius(24)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.brandGreen, lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            selectedTime = time
                                        }
                                }
                            }
                        }
                    }
                    

                    
                    Spacer().frame(height: 50)
                }
                .padding()
            }
            
            // Bottom Action Bar
            bottomBar
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
    
    private var bottomBar: some View {
        VStack {
            NavigationLink(destination: LocationSelectionView(
                service: service,
                totalPrice: totalPrice,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                serviceDetails: serviceDetails
            )) {
                Text("Select Location")
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
    
    // MARK: - Calendar Helpers
    
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let numDays = range.count
        
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        // Adjust for Monday start (default Sunday=1) -> Mon=2
        // UI shows Mo Tu We.. so Monday start.
        // Calendar.current.firstWeekday is usually Sunday in US.
        // Shift: Mon(2) -> 0 padding. Sun(1) -> 6 padding?
        // Let's assume standard Gregorian where 1=Sun, 2=Mon
        // We want Mon to be index 0
        // Padding = (firstWeekday - 2 + 7) % 7
        
        let paddingDays = (firstWeekday - 2 + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: paddingDays)
        
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.subheadline)
            .fontWeight(isSelected ? .bold : .regular)
            .frame(width: 35, height: 35)
            .background(isSelected ? Color.brandGreen : Color.clear)
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(Circle())
    }
}

#Preview {
    BookingDetailsView(service: ServiceItem(
        title: "Test Service",
        price: "$125",
        originalPrice: "",
        rating: "",
        provider: "",
        imageColor: .blue,
        imageName: nil
    ), totalPrice: 125, serviceDetails: ServiceDetails())
}
