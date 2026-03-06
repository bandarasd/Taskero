//
//  ServiceItem.swift
//  Taskero
//
//  Created by Intravision on 2026-01-15.
//

import SwiftUI

enum ServiceType: String, CaseIterable, Codable {
    case cleaning = "Cleaning"
    case plumbing = "Plumbing"
    case laundry = "Laundry"
    case painting = "Painting"
    case repairing = "Repairing"
    case electrician = "Electrician"
    case assembly = "Assembly"
    case carpenter = "Carpentry"
    case moving = "Moving"
    case gardening = "Gardening"
    case general = "General"
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let originalPrice: String
    let rating: String
    let provider: String
    let imageColor: Color
    let imageName: String?
    var images: [String] = []
    var type: ServiceType = .general
}
