//
//  Country.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-11.
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    var id: String { code }
    let name: String
    let flag: String
    let code: String
    let dial_code: String
}
