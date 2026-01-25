//
//  ServiceDetails.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import Foundation

// Model to hold user-selected service details
struct ServiceDetails {
    var items: [(label: String, value: String)]
    
    init(items: [(label: String, value: String)] = []) {
        self.items = items
    }
}
