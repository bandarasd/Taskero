//
//  Booking.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

enum BookingStatus: String, CaseIterable, Codable {
    case ongoing = "Ongoing"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case canceled = "Cancelled"
    
    var color: Color {
        switch self {
        case .upcoming: return .blue
        case .ongoing: return .orange
        case .completed: return .brandGreen // Assuming brandGreen exists in extensions
        case .canceled: return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .upcoming: return .blue.opacity(0.1)
        case .ongoing: return .orange.opacity(0.1)
        case .completed: return .brandGreen.opacity(0.1)
        case .canceled: return .red.opacity(0.1)
        }
    }
}

struct Booking: Identifiable {
    let id = UUID()
    let serviceName: String
    let category: String
    let providerName: String
    let date: Date
    let time: String
    let status: BookingStatus
    let price: Double
    let imageName: String? // Asset name
    let imageColor: Color? // Fallback color
    var userRating: Int? = nil
    let providerImage: String?
    
    init(serviceName: String, category: String, providerName: String, date: Date, time: String, status: BookingStatus, price: Double, imageName: String?, imageColor: Color?, userRating: Int? = nil, providerImage: String? = nil) {
        self.serviceName = serviceName
        self.category = category
        self.providerName = providerName
        self.date = date
        self.time = time
        self.status = status
        self.price = price
        self.imageName = imageName
        self.imageColor = imageColor
        self.userRating = userRating
        self.providerImage = providerImage
    }
}
