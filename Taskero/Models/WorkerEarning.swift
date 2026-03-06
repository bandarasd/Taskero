//
//  WorkerEarning.swift
//  Taskero
//

import Foundation

enum TransactionType: String {
    case payout = "Job Payout"
    case bonus = "Bonus"
    case withdrawal = "Withdrawal"
}

struct WorkerEarning: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let type: TransactionType
    let jobReference: String? // e.g., "HOV01203454"
    let status: String // "Completed", "Pending"
    
    var isPositive: Bool {
        return type == .payout || type == .bonus
    }
}
