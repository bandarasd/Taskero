//
//  WorkerJobsView.swift
//  Taskero
//

import SwiftUI

struct WorkerJobsView: View {
    let mainColor = Color.brandGreen
    @State private var selectedTab = 0
    
    // Using filtered lists from mock data
    var newRequests: [WorkerJob] { MockData.workerJobs.filter { $0.status == .pending } }
    var activeJobs: [WorkerJob] { MockData.workerJobs.filter { $0.status == .accepted || $0.status == .inProgress } }
    var completedJobs: [WorkerJob] { MockData.workerJobs.filter { $0.status == .completed || $0.status == .canceled } }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Jobs")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // Custom Segmented Control
                HStack(spacing: 0) {
                    TabButton(title: "Requests", isSelected: selectedTab == 0) { selectedTab = 0 }
                    TabButton(title: "Active", isSelected: selectedTab == 1) { selectedTab = 1 }
                    TabButton(title: "Completed", isSelected: selectedTab == 2) { selectedTab = 2 }
                }
                .padding(.bottom, 10)
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if selectedTab == 0 {
                            JobListView(jobs: newRequests, emptyMessage: "No new requests right now.")
                        } else if selectedTab == 1 {
                            JobListView(jobs: activeJobs, emptyMessage: "You don't have any active jobs.")
                        } else {
                            JobListView(jobs: completedJobs, emptyMessage: "No completed jobs yet.")
                        }
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.05).ignoresSafeArea())
            }
            .navigationBarHidden(true)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .semibold)
                    .foregroundColor(isSelected ? .brandGreen : .gray)
                
                Rectangle()
                    .fill(isSelected ? Color.brandGreen : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct JobListView: View {
    let jobs: [WorkerJob]
    let emptyMessage: String
    
    var body: some View {
        if jobs.isEmpty {
            VStack(spacing: 16) {
                Spacer().frame(height: 100)
                Image(systemName: "tray.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.3))
                Text(emptyMessage)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        } else {
            ForEach(jobs) { job in
                NavigationLink(destination: WorkerJobDetailView(job: job)) {
                    WorkerJobCard(job: job)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    WorkerJobsView()
}
