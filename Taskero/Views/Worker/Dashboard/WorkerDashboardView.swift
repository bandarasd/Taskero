//
//  WorkerDashboardView.swift
//  Taskero
//

import SwiftUI

struct WorkerDashboardView: View {
    @State private var isOnline = true
    let mainColor = Color.brandGreen
    let worker = MockData.currentWorker
    
    // Derived mock data
    var todaysEarnings: Double {
        MockData.workerEarnings
            .filter { Calendar.current.isDateInToday($0.date) && $0.isPositive }
            .reduce(0) { $0 + $1.amount }
    }
    
    var completedJobsToday: Int {
        MockData.workerJobs
            .filter { Calendar.current.isDateInToday($0.date) && $0.status == .completed }
            .count
    }
    
    var nextJob: WorkerJob? {
        MockData.workerJobs
            .filter { $0.status == .accepted || $0.status == .inProgress }
            .sorted { $0.date < $1.date }
            .first
    }
    
    var recentEarnings: [WorkerEarning] {
        Array(MockData.workerEarnings.prefix(3))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header & Online Toggle
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(worker.name)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()

                        // Notification Bell
                        NavigationLink(destination: WorkerNotificationsView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 4, y: -4)
                            }
                        }
                        .padding(.trailing, 8)
                        
                        // Online/Offline Toggle
                        HStack {
                            Text(isOnline ? "Online" : "Offline")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(isOnline ? .white : .gray)
                            
                            Toggle("", isOn: $isOnline)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: mainColor))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isOnline ? mainColor.opacity(0.8) : Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Summary Cards Grid
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "Today's Earnings",
                            value: "$\(String(format: "%.2f", todaysEarnings))",
                            icon: "dollarsign.circle.fill",
                            color: .brandGreen
                        )
                        
                        SummaryCard(
                            title: "Jobs Done",
                            value: "\(completedJobsToday)",
                            icon: "checkmark.circle.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                    
                    // Next Job Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Up Next")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if let job = nextJob {
                            NavigationLink(destination: WorkerJobDetailView(job: job)) {
                                WorkerJobCard(job: job)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No upcoming jobs")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent Earnings
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Activity")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: WorkerEarningsView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(mainColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(recentEarnings) { earning in
                                EarningRow(earning: earning)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Subviews

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

struct EarningRow: View {
    let earning: WorkerEarning
    
    var body: some View {
        HStack {
            // Icon
            ZStack {
                Circle()
                    .fill(earning.isPositive ? Color.brandGreen.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: earning.isPositive ? "arrow.down.left" : "arrow.up.right")
                    .foregroundColor(earning.isPositive ? .brandGreen : .red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(earning.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(formatDate(earning.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(earning.isPositive ? "+" : "-")$\(String(format: "%.2f", abs(earning.amount)))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(earning.isPositive ? .brandGreen : .primary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    WorkerDashboardView()
}
