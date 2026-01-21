//
//  Booking.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

enum BookingStatus: String, CaseIterable, Codable {
    case upcoming = "Upcoming"
    case completed = "Completed"
    case canceled = "Cancelled"
    
    var color: Color {
        switch self {
        case .upcoming: return .blue
        case .completed: return .brandGreen // Assuming brandGreen exists in extensions
        case .canceled: return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .upcoming: return .blue.opacity(0.1)
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
}
