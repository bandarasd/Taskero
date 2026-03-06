//
//  UserProfile.swift
//  Taskero
//
//  Created by Antigravity on 2026-01-25.
//

import Foundation

struct UserProfile: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var phone: String
    var address: String
    var profileImage: String?
    var joinedDate: Date
    
    static let mock = UserProfile(
        name: "Mark Robinson",
        email: "mark.robinson@example.com",
        phone: "(201) 555-0123",
        address: "Washington Ave, Manchester, Kentucky 39495",
        profileImage: "worker_1", // Using an existing worker image as a placeholder
        joinedDate: Date().addingTimeInterval(-86400 * 30 * 6) // Joined 6 months ago
    )
}
