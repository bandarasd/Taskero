//
//  ReviewsView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct ReviewsView: View {
    @Environment(\.presentationMode) var presentationMode
    let mainColor = Color.brandGreen
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<10, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Reviewer \(index + 1)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("Awesome service! Highly recommended.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                Text("5")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .overlay(
                                Capsule().stroke(mainColor, lineWidth: 1)
                            )
                            .foregroundColor(mainColor)
                        }
                        
                        HStack(spacing: 15) {
                            HStack(spacing: 4) {
                                Image(systemName: "heart")
                                Text("\(100 + index)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                            Text("\(index + 1) weeks ago")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Reviews")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
    }
}

#Preview {
    NavigationView {
        ReviewsView()
    }
}
