//
//  ProfileOptionRow.swift
//  Taskero
//
//  Created by Antigravity on 2026-01-25.
//

import SwiftUI

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var showChevron: Bool = true
    var titleColor: Color = .primary
    var isSystemImage: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                if isSystemImage {
                    Image(systemName: icon)
                        .foregroundColor(.primary)
                } else {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(titleColor)
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack {
        ProfileOptionRow(icon: "person", title: "Edit Profile")
        ProfileOptionRow(icon: "bell", title: "Notifications", value: "On")
        ProfileOptionRow(icon: "door.right.hand.open", title: "Logout", showChevron: false, titleColor: .red)
    }
    .padding()
}
