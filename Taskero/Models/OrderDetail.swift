//
//  OrderDetail.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import SwiftUI

enum ServiceStatus: String, CaseIterable {
    case created = "Service created"
    case readyForService = "Ready for service"
    case inProgress = "Service in progress"
    case done = "Service Done"
}

struct Worker {
    let name: String
    let rating: Double
    let reviewCount: Int
    let profileImage: String? // Asset name or nil for placeholder
}

struct OrderDetail: Identifiable {
    let id = UUID()
    let orderId: String
    let booking: Booking // Reference to the booking
    let status: ServiceStatus
    
    // Customer Info
    let customerName: String
    let customerPhone: String
    let customerAddress: String
    
    // Worker Info
    let worker: Worker?
    
    // Pricing
    let subtotal: Double
    let serviceFee: Double
    var total: Double {
        subtotal + serviceFee
    }
    
    // Order Details
    let paymentMethod: String
    let orderDateTime: Date
    let paymentDateTime: Date
    let duration: String
    let workload: String
    let addOnService: String?
    let houseWithPet: String?
    let taskerGender: String?
    let noteForWorker: String?
}
