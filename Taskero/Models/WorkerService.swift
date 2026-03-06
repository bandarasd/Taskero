//
//  WorkerService.swift
//  Taskero
//

import SwiftUI

struct WorkerService: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var basePrice: Double
    var category: ServiceType
    var imageNames: [String]
    var isActive: Bool

    static let mockServices: [WorkerService] = [
        WorkerService(
            title: "Deep Home Cleaning",
            description: "Full deep cleaning including all rooms, kitchen, and bathrooms. We use eco-friendly products.",
            basePrice: 80,
            category: .cleaning,
            imageNames: [],
            isActive: true
        ),
        WorkerService(
            title: "Pipe Leak Repair",
            description: "Fast and reliable leak repair for kitchens, bathrooms and outdoor pipes.",
            basePrice: 60,
            category: .plumbing,
            imageNames: [],
            isActive: true
        ),
        WorkerService(
            title: "Interior Wall Painting",
            description: "Professional interior painting with quality materials. Single rooms or whole home.",
            basePrice: 120,
            category: .painting,
            imageNames: [],
            isActive: false
        )
    ]
}
