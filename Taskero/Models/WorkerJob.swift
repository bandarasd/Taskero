//
//  WorkerJob.swift
//  Taskero
//

import SwiftUI

enum WorkerJobStatus: String, CaseIterable, Codable {
    case pending = "New Request"
    case accepted = "Accepted"
    case inProgress = "In Progress"
    case completed = "Completed"
    case canceled = "Canceled"
    case declined = "Declined"
    
    var color: Color {
        switch self {
        case .pending: return .blue
        case .accepted: return .orange
        case .inProgress: return .purple
        case .completed: return .brandGreen
        case .canceled, .declined: return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .pending: return .blue.opacity(0.1)
        case .accepted: return .orange.opacity(0.1)
        case .inProgress: return .purple.opacity(0.1)
        case .completed: return .brandGreen.opacity(0.1)
        case .canceled, .declined: return .red.opacity(0.1)
        }
    }
}

struct WorkerJob: Identifiable {
    let id = UUID()
    let serviceName: String
    let category: String
    let customerName: String
    let customerAddress: String
    let customerPhone: String
    let date: Date
    let time: String
    let duration: String
    let status: WorkerJobStatus
    let payout: Double
    let workload: String
    let addOnService: String?
    let houseWithPet: String?
    let customerNote: String?
    
    // UI Helpers
    let mapImagePlaceholder: String? // Name of an asset for the map
    let customerProfileImage: String?
}
