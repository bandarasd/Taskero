//
//  WorkerJobDetailView.swift
//  Taskero
//

import SwiftUI

struct WorkerJobDetailView: View {
    let job: WorkerJob
    let mainColor = Color.brandGreen
    @Environment(\.presentationMode) var presentationMode
    @State private var currentStatus: WorkerJobStatus
    @State private var showDeclineAlert = false
    @State private var showCompleteAlert = false

    init(job: WorkerJob) {
        self.job = job
        self._currentStatus = State(initialValue: job.status)
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
                Text("Job Details")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                // Placeholder for symmetry
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Status Banner
                    HStack {
                        Spacer()
                        Text(currentStatus.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(currentStatus.backgroundColor)
                            .foregroundColor(currentStatus.color)
                            .cornerRadius(8)
                        Spacer()
                    }
                    
                    // Map Placeholder & Customer Card
                    VStack(spacing: 0) {
                        if let mapImage = job.mapImagePlaceholder {
                            // Mock Map
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 180)
                                .overlay(
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(mainColor.opacity(0.5))
                                )
                        } else {
                            // Default Fallback Map Placeholder
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 180)
                                .overlay(
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(mainColor.opacity(0.5))
                                )
                        }
                        
                        // Customer Info
                        HStack(spacing: 16) {
                            if let profileImage = job.customerProfileImage, UIImage(named: profileImage) != nil {
                                Image(profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text(job.customerName.prefix(1))
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(job.customerName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(job.customerPhone)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Call & Message buttons
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(mainColor)
                                        .clipShape(Circle())
                                }
                                Button(action: {}) {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(mainColor)
                                        .padding(10)
                                        .background(mainColor.opacity(0.1))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                        .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    
                    // Job Details Block
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Job Summary")
                            .font(.headline)
                        
                        JobDetailRow(title: "Service", value: job.serviceName)
                        JobDetailRow(title: "Category", value: job.category)
                        JobDetailRow(title: "Date", value: formatDate(job.date))
                        JobDetailRow(title: "Time", value: job.time)
                        JobDetailRow(title: "Duration", value: job.duration)
                        JobDetailRow(title: "Workload", value: job.workload)
                        
                        if let addOn = job.addOnService {
                            JobDetailRow(title: "Add-on", value: addOn)
                        }
                        
                        if let note = job.customerNote {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Customer Note")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(note)
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.yellow.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.02), radius: 5, x: 0, y: 2)
                    
                    // Payment Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Payout Summary")
                            .font(.headline)
                        
                        HStack {
                            Text("Service Payout")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$\(String(format: "%.2f", job.payout))")
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.02), radius: 5, x: 0, y: 2)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.gray.opacity(0.03).ignoresSafeArea())
            
            // Bottom Action Bar based on status
            bottomActionBar
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            if currentStatus == .pending {
                HStack(spacing: 16) {
                    Button(action: { showDeclineAlert = true }) {
                        Text("Decline")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(16)
                    }

                    Button(action: { withAnimation { currentStatus = .accepted } }) {
                        Text("Accept Job")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(mainColor)
                            .cornerRadius(16)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
            } else if currentStatus == .accepted {
                Button(action: { withAnimation { currentStatus = .inProgress } }) {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                        Text("Start Service")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .cornerRadius(16)
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
            } else if currentStatus == .inProgress {
                Button(action: { showCompleteAlert = true }) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(16)
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
            } else if currentStatus == .completed {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.brandGreen)
                        .font(.title2)
                    Text("Job Completed")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.brandGreen)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brandGreen.opacity(0.08))
            } else if currentStatus == .declined {
                HStack(spacing: 12) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    Text("Job Declined")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.06))
            }
        }
        .alert("Decline Job", isPresented: $showDeclineAlert) {
            Button("Decline", role: .destructive) { withAnimation { currentStatus = .declined } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to decline this job?")
        }
        .alert("Complete Job", isPresented: $showCompleteAlert) {
            Button("Mark as Completed") { withAnimation { currentStatus = .completed } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Confirm that the job has been completed successfully.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

private struct JobDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


#Preview {
    WorkerJobDetailView(job: MockData.workerJobs[0])
}
