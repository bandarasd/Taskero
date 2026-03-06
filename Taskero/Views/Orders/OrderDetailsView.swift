//
//  OrderDetailsView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let orderDetail: OrderDetail
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                header
                
                VStack(spacing: 20) {
                    // Service Info Card
                    serviceInfoCard
                    
                    // Status Timeline
                    statusTimeline
                    
                    // Customer Location
                    customerLocationSection
                    
                    // Worker Section
                    if let worker = orderDetail.worker {
                        workerSection(worker: worker)
                    }
                    
                    // Order Summary
                    orderSummarySection
                    
                    // Order Details
                    orderDetailsSection
                    
                    // Action Buttons
                    if orderDetail.booking.status == .upcoming {
                        // Cancel Order Button (only for upcoming orders)
                        cancelOrderButton
                    } else if orderDetail.booking.status == .completed {
                        // Completed Order Actions (Review + Re-Book)
                        completedOrderActions
                    }
                    
                    Spacer().frame(height: 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Orders Detail")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            // Placeholder for symmetry
            Image(systemName: "arrow.left")
                .font(.title2)
                .opacity(0)
        }
        .padding()
        .padding(.top, 40)
    }
    
    // MARK: - Service Info Card
    private var serviceInfoCard: some View {
        HStack(spacing: 12) {
            // Service Image
            if let imageName = orderDetail.booking.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "wrench.fill")
                    .font(.title)
                    .foregroundColor(orderDetail.booking.imageColor ?? .brandGreen)
                    .frame(width: 50, height: 50)
            }
            
            Text(orderDetail.booking.serviceName)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Status Badge - Dynamic based on booking status
            Text(getStatusBadgeText())
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(getStatusBadgeColor().opacity(0.2))
                .foregroundColor(getStatusBadgeColor())
                .cornerRadius(8)
        }
        .padding()
        .background(Color.brandGreen.opacity(0.1))
        .cornerRadius(16)
    }
    
    // MARK: - Status Timeline
    private var statusTimeline: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 0) {
                ForEach(Array(ServiceStatus.allCases.enumerated()), id: \.offset) { index, status in
                    VStack(spacing: 8) {
                        // Circle indicator
                        ZStack {
                            Circle()
                                .fill(isStatusCompleted(status) ? Color.brandGreen : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                            
                            if isStatusCompleted(status) {
                                Image(systemName: status == orderDetail.status ? "circle.fill" : "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Status label
                        Text(getStatusLabel(status))
                            .font(.system(size: 9))
                            .foregroundColor(isStatusCompleted(status) ? .brandGreen : .gray)
                            .multilineTextAlignment(.center)
                            .frame(width: 60)
                    }
                    
                    if index < ServiceStatus.allCases.count - 1 {
                        // Connecting line
                        Rectangle()
                            .fill(isStatusCompleted(ServiceStatus.allCases[index + 1]) ? Color.brandGreen : Color.gray.opacity(0.3))
                            .frame(height: 2)
                            .offset(y: -20)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Customer Location Section
    private var customerLocationSection: some View {
        VStack(spacing: 12) {
            // Customer name and phone row
            HStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.brandGreen)
                    .font(.title3)
                    .frame(width: 24)
                
                Text("Customer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(orderDetail.customerName) (\(orderDetail.customerPhone))")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            // Address row
            HStack(spacing: 12) {
                Image(systemName: "location.fill")
                    .foregroundColor(.brandGreen)
                    .font(.title3)
                    .frame(width: 24)
                
                Text("Address")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(orderDetail.customerAddress)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    // MARK: - Worker Section
    private func workerSection(worker: Worker) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Worker")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                // Worker Profile Image
                if let profileImage = worker.profileImage, UIImage(named: profileImage) != nil {
                    Image(profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.brandGreen.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Text(worker.name.prefix(1))
                            .font(.headline)
                            .foregroundColor(.brandGreen)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(worker.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text(String(format: "%.1f", worker.rating))
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("(\(worker.reviewCount)+ review)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.gray)
                        .font(.title3)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Order Summary Section
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("$\(String(format: "%.2f", orderDetail.subtotal))")
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Service fee")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("$\(String(format: "%.2f", orderDetail.serviceFee))")
                        .font(.subheadline)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", orderDetail.total))")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    // MARK: - Order Details Section
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Details")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                orderDetailRow(icon: "doc.text.fill", iconColor: .brandGreen, label: "Order ID", value: orderDetail.orderId)
                
                orderDetailRow(icon: "creditcard.fill", iconColor: .brandGreen, label: "Payment method", value: orderDetail.paymentMethod, showPaymentIcon: true)
                
                orderDetailRow(icon: "calendar", iconColor: .brandGreen, label: "Order date", value: formatDateTime(orderDetail.orderDateTime))
                
                orderDetailRow(icon: "clock.fill", iconColor: .brandGreen, label: "Payment time", value: formatDateTime(orderDetail.paymentDateTime))
                
                orderDetailRow(icon: "clock.fill", iconColor: .brandGreen, label: "Duration", value: orderDetail.duration)
                
                orderDetailRow(icon: "briefcase.fill", iconColor: .brandGreen, label: "Workload", value: orderDetail.workload)
                
                if let addOn = orderDetail.addOnService {
                    orderDetailRow(icon: "plus.circle.fill", iconColor: .brandGreen, label: "Add-on service", value: addOn)
                }
                
                if let pet = orderDetail.houseWithPet {
                    orderDetailRow(icon: "pawprint.fill", iconColor: .brandGreen, label: "House with pet", value: pet)
                }
                
                if let gender = orderDetail.taskerGender {
                    orderDetailRow(icon: "person.fill", iconColor: .brandGreen, label: "Choose Tasker Gender", value: gender)
                }
            }
        }
    }
    
    // MARK: - Cancel Order Button
    private var cancelOrderButton: some View {
        Button(action: {}) {
            Text("Cancel order")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
    
    // MARK: - Completed Order Actions
    private var completedOrderActions: some View {
        VStack(spacing: 16) {
            if let rating = orderDetail.booking.userRating {
                // Reviewed State: Show Rating + Order Again
                VStack(spacing: 8) {
                    Text("You rated this service")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: "star.fill")
                                .font(.title3)
                                .foregroundColor(index < rating ? .orange : .gray.opacity(0.3))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(16)
                
                reBookButton
            } else {
                // Unreviewed State: Add Review + Order Again
                HStack(spacing: 16) {
                    NavigationLink(destination: AddReviewView(orderDetail: orderDetail)) {
                        Text("Add Review")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(24)
                    }
                    
                    reBookButton
                }
            }
        }
    }
    
    private var reBookButton: some View {
        NavigationLink(destination: ServiceDetailView(service: ServiceItem(
            title: orderDetail.booking.serviceName,
            price: "$\(String(format: "%.0f", orderDetail.booking.price))",
            originalPrice: "",
            rating: "4.8",
            provider: orderDetail.booking.providerName,
            imageColor: orderDetail.booking.imageColor ?? .brandGreen,
            imageName: orderDetail.booking.imageName,
            images: orderDetail.booking.imageName != nil ? [orderDetail.booking.imageName!] : [],
            type: {
                switch orderDetail.booking.category {
                case "Cleaning": return .cleaning
                case "Plumbing": return .plumbing
                case "Laundry": return .laundry
                case "Painting": return .painting
                case "Repairing", "Repair", "AC Repair": return .repairing
                case "Electrical": return .electrician
                case "Assembly": return .assembly
                default: return .general
                }
            }()
        ))) {
            Text("Order Again")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brandGreen)
                .cornerRadius(24)
        }
    }
    
    // MARK: - Helper Views
    private func orderDetailRow(icon: String, iconColor: Color, label: String, value: String, showPaymentIcon: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.title3)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            if showPaymentIcon && value.lowercased().contains("mastercard") {
                HStack(spacing: 8) {
                    Image("mastercard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 20)
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            } else {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func isStatusCompleted(_ status: ServiceStatus) -> Bool {
        let allStatuses = ServiceStatus.allCases
        guard let currentIndex = allStatuses.firstIndex(of: orderDetail.status),
              let statusIndex = allStatuses.firstIndex(of: status) else {
            return false
        }
        return statusIndex <= currentIndex
    }
    
    private func getStatusLabel(_ status: ServiceStatus) -> String {
        switch status {
        case .created:
            return "Service\ncreated"
        case .readyForService:
            return "Ready for\nservice"
        case .inProgress:
            return "Service in\nprogress"
        case .done:
            return "Service\nDone"
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy / h:mm a"
        return formatter.string(from: date)
    }
    
    private func getStatusBadgeText() -> String {
        switch orderDetail.booking.status {
        case .upcoming:
            return "Scheduled"
        case .ongoing:
            return "Ongoing"
        case .completed:
            return "Completed"
        case .canceled:
            return "Cancelled"
        }
    }
    
    private func getStatusBadgeColor() -> Color {
        switch orderDetail.booking.status {
        case .upcoming:
            return .blue
        case .ongoing:
            return .orange
        case .completed:
            return .brandGreen
        case .canceled:
            return .red
        }
    }
}

#Preview {
    OrderDetailsView(orderDetail: OrderDetail(
        orderId: "HOV01203450",
        booking: Booking(
            serviceName: "Cleaning on-demand",
            category: "Cleaning",
            providerName: "Andrew Sirolin",
            date: Date(),
            time: "10:00 AM",
            status: .upcoming,
            price: 76.00,
            imageName: "cleaning_service",
            imageColor: .brandGreen
        ),
        status: .created,
        customerName: "Mark Robinson",
        customerPhone: "(201) ****** 82",
        customerAddress: "Washington Ave, Manchester, Kentucky 39495",
        worker: Worker(
            name: "Andrew Sirolin",
            rating: 4.9,
            reviewCount: 890,
            profileImage: nil
        ),
        subtotal: 75.00,
        serviceFee: 1.00,
        paymentMethod: "Mastercard",
        orderDateTime: Date(),
        paymentDateTime: Date(),
        duration: "2 hours, 09:00 to 12:00 AM",
        workload: "55m²/2100ft²",
        addOnService: "Ironing",
        houseWithPet: "Dog",
        taskerGender: "Male",
        noteForWorker: "Clean 3 room, 2 bedroom, 1 kitchen, beaceful while cleaning wooden floor"
    ))
}
