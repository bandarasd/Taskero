//
//  WorkerReviewsView.swift
//  Taskero
//

import SwiftUI

// MARK: - Model

struct WorkerReview: Identifiable {
    let id = UUID()
    let customerName: String
    let customerImage: String?
    let rating: Int
    let comment: String
    let serviceName: String
    let timeAgo: String
    let jobReference: String
}

// MARK: - Mock Data

private let mockWorkerReviews: [WorkerReview] = [
    WorkerReview(customerName: "Jessica Wilson",    customerImage: "reviewer_2", rating: 5, comment: "Assembled everything perfectly, very professional and on time! Will definitely book again. 🌟", serviceName: "Furniture Assembly", timeAgo: "5h ago",       jobReference: "HOV01203488"),
    WorkerReview(customerName: "Emily Davis",       customerImage: "reviewer_3", rating: 5, comment: "Great AC service! Mickey was very thorough and explained everything clearly. Highly recommended.", serviceName: "AC Service",           timeAgo: "2d ago",       jobReference: "HOV01203493"),
    WorkerReview(customerName: "Sarah Connor",      customerImage: "reviewer_1", rating: 4, comment: "Kitchen is spotless! Arrived on time. Would appreciate a bit more care with delicate items.", serviceName: "Kitchen Cleaning",     timeAgo: "1 week ago",   jobReference: "HOV01203490"),
    WorkerReview(customerName: "Michael Brown",     customerImage: "reviewer_1", rating: 5, comment: "Living room looks amazing. Mickey's attention to detail is outstanding. 100% recommend!", serviceName: "Wall Painting",        timeAgo: "2 weeks ago",  jobReference: "HOV01203489"),
    WorkerReview(customerName: "Robert Johnson",    customerImage: nil,          rating: 4, comment: "Fixed the plumbing issue quickly and efficiently. Clean workspace after the work. Good job.", serviceName: "Pipe Leak Fix",        timeAgo: "3 weeks ago",  jobReference: "HOV01203491"),
    WorkerReview(customerName: "Laura Martinez",    customerImage: "reviewer_2", rating: 5, comment: "Best cleaning service I've ever used! Every corner was spotless. Mickey is a true professional.", serviceName: "House Cleaning",       timeAgo: "1 month ago",  jobReference: "HOV01203487"),
    WorkerReview(customerName: "David Kim",         customerImage: nil,          rating: 3, comment: "Good work overall but took a bit longer than expected. The result was satisfactory.", serviceName: "Kitchen Cleaning",     timeAgo: "2 months ago", jobReference: "HOV01203485"),
    WorkerReview(customerName: "Amanda Chen",       customerImage: "reviewer_3", rating: 5, comment: "Mickey is absolutely fantastic! My house has never been this clean. Already booked again.", serviceName: "Deep Cleaning",        timeAgo: "2 months ago", jobReference: "HOV01203483")
]

// MARK: - View

struct WorkerReviewsView: View {

    let mainColor = Color.brandGreen
    @Environment(\.presentationMode) var presentationMode

    var averageRating: Double {
        guard !mockWorkerReviews.isEmpty else { return 0 }
        let total = mockWorkerReviews.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(mockWorkerReviews.count)
    }

    var ratingsBreakdown: [(Int, Int)] {
        (1...5).reversed().map { star in
            (star, mockWorkerReviews.filter { $0.rating == star }.count)
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("My Reviews")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)

            ScrollView {
                VStack(spacing: 20) {

                    // Rating Summary Card
                    HStack(spacing: 24) {
                        // Big Rating Number
                        VStack(spacing: 6) {
                            Text(String(format: "%.1f", averageRating))
                                .font(.system(size: 52, weight: .bold))
                                .foregroundColor(.primary)
                            StarRatingRow(rating: Int(averageRating.rounded()), size: 14)
                            Text("\(mockWorkerReviews.count) reviews")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Breakdown bars
                        VStack(spacing: 6) {
                            ForEach(ratingsBreakdown, id: \.0) { star, count in
                                HStack(spacing: 8) {
                                    Text("\(star)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(width: 10)
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(.yellow)
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule().fill(Color.gray.opacity(0.15)).frame(height: 6)
                                            Capsule().fill(mainColor)
                                                .frame(width: mockWorkerReviews.isEmpty ? 0 : geo.size.width * CGFloat(count) / CGFloat(mockWorkerReviews.count), height: 6)
                                        }
                                    }
                                    .frame(height: 6)
                                    Text("\(count)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(width: 18, alignment: .trailing)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 16)

                    // Reviews List
                    VStack(spacing: 12) {
                        ForEach(mockWorkerReviews) { review in
                            ReviewCard(review: review, mainColor: mainColor)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

private struct ReviewCard: View {
    let review: WorkerReview
    let mainColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let img = review.customerImage, UIImage(named: img) != nil {
                    Image(img)
                        .resizable().scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.18))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(review.customerName.prefix(1))
                                .font(.headline).fontWeight(.bold).foregroundColor(.gray)
                        )
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(review.customerName)
                        .font(.subheadline).fontWeight(.bold)
                    HStack(spacing: 4) {
                        StarRatingRow(rating: review.rating, size: 12)
                        Text("• \(review.timeAgo)")
                            .font(.caption).foregroundColor(.gray)
                    }
                }

                Spacer()

                Text(review.serviceName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(mainColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(mainColor.opacity(0.1))
                    .cornerRadius(6)
            }

            Text(review.comment)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}

struct StarRatingRow: View {
    let rating: Int
    var size: CGFloat = 14
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    WorkerReviewsView()
}
