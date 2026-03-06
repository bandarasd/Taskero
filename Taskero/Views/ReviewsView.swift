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
                ForEach(MockData.reviews) { review in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if let imageName = review.reviewerImage, UIImage(named: imageName) != nil {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                    
                                    Text(review.reviewerName.prefix(1))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(review.reviewerName)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(review.comment)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                Text("\(review.rating)")
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
                        
                        if let images = review.reviewImages, !images.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(images, id: \.self) { img in
                                        Image(img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                        
                        HStack(spacing: 15) {
                            HStack(spacing: 4) {
                                Image(systemName: "heart")
                                Text("\(review.likes)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                            Text(review.timeAgo)
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
