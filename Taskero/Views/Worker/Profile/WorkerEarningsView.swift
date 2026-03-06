//
//  WorkerEarningsView.swift
//  Taskero
//

import SwiftUI

struct WorkerEarningsView: View {
    let mainColor = Color.brandGreen
    let earnings = MockData.workerEarnings
    @Environment(\.presentationMode) var presentationMode
    
    var totalBalance: Double {
        earnings.reduce(0) { $0 + $1.amount }
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
                Text("Earnings")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Balance Card
                    VStack(spacing: 16) {
                        Text("Available Balance")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("$\(String(format: "%.2f", totalBalance))")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        
                        Button(action: {}) {
                            Text("Withdraw Funds")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(mainColor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 10)
                    }
                    .padding(24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [mainColor, mainColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(24)
                    .shadow(color: mainColor.opacity(0.3), radius: 10, y: 5)
                    .padding()
                    
                    // Transactions List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Transactions")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(earnings) { earning in
                                EarningDetailRow(earning: earning)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color.gray.opacity(0.03).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

struct EarningDetailRow: View {
    let earning: WorkerEarning
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(earning.isPositive ? Color.brandGreen.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: earning.type == .withdrawal ? "building.columns.fill" : (earning.type == .bonus ? "gift.fill" : "briefcase.fill"))
                    .font(.title3)
                    .foregroundColor(earning.isPositive ? .brandGreen : .red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(earning.type.rawValue)
                    .font(.headline)
                
                if let ref = earning.jobReference {
                    Text("Job #\(ref)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text(formatDate(earning.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(earning.isPositive ? "+" : "-")$\(String(format: "%.2f", abs(earning.amount)))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(earning.isPositive ? .brandGreen : .primary)
                
                Text(earning.status)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(earning.status == "Completed" ? 0.1 : 0))
                    .foregroundColor(earning.status == "Completed" ? .green : .gray)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    WorkerEarningsView()
}
