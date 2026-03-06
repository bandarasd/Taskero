//
//  WorkerJobCard.swift
//  Taskero
//

import SwiftUI

struct WorkerJobCard: View {
    let job: WorkerJob
    let mainColor = Color.brandGreen
    
    var body: some View {
        VStack(spacing: 16) {
            // Customer & Service Header
            HStack(alignment: .top) {
                // Customer Profile Image
                if let profileImage = job.customerProfileImage, UIImage(named: profileImage) != nil {
                    Image(profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Text(job.customerName.prefix(1))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.customerName)
                        .font(.headline)
                    
                    Text(job.serviceName)
                        .font(.subheadline)
                        .foregroundColor(mainColor)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Payout
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", job.payout))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Status Badge
                    Text(job.status.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(job.status.backgroundColor)
                        .foregroundColor(job.status.color)
                        .cornerRadius(6)
                }
            }
            
            Divider()
            
            // Details Rows
            VStack(spacing: 10) {
                WorkerJobDetailRow(icon: "calendar", text: "\(formatDate(job.date)) • \(job.time)")
                WorkerJobDetailRow(icon: "clock", text: job.duration)
                WorkerJobDetailRow(icon: "mappin.and.ellipse", text: job.customerAddress)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

private struct WorkerJobDetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .frame(width: 16)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            
            Spacer()
        }
    }
}

#Preview {
    WorkerJobCard(job: MockData.workerJobs[0])
        .padding()
}
