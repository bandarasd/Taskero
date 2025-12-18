//
//  CategoryModel.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String // Asset name or SF Symbol name
    let isSystemImage: Bool
    let color: Color
    let backgroundColor: Color
}

struct PermissionModel {
    static let categories = [
        CategoryItem(name: "Carpenter", icon: "ic_carpenter", isSystemImage: false, color: .white, backgroundColor: .orange),
        CategoryItem(name: "Cleaner", icon: "ic_cleaner", isSystemImage: false, color: .white, backgroundColor: .blue),
        CategoryItem(name: "Painter", icon: "ic_painter", isSystemImage: false, color: .white, backgroundColor: .green),
        CategoryItem(name: "Electrician", icon: "ic_electrician", isSystemImage: false, color: .white, backgroundColor: .yellow),
        CategoryItem(name: "Mover", icon: "ic_mover", isSystemImage: false, color: .white, backgroundColor: .pink),
        CategoryItem(name: "AC Repair", icon: "ic_ac_repair", isSystemImage: false, color: .white, backgroundColor: .cyan),
        CategoryItem(name: "Plumber", icon: "ic_plumber", isSystemImage: false, color: .white, backgroundColor: .red),
        CategoryItem(name: "Gardener", icon: "ic_gardener", isSystemImage: false, color: .white, backgroundColor: .purple)
    ]
}
