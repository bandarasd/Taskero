//
//  WorkerServicesView.swift
//  Taskero
//

import SwiftUI
import PhotosUI

struct WorkerServicesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var services: [WorkerService] = WorkerService.mockServices
    @State private var showAddService = false
    @State private var serviceToEdit: WorkerService? = nil

    let mainColor = Color.brandGreen

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
                Text("My Services")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { showAddService = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(mainColor)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

            if services.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 50))
                        .foregroundColor(mainColor.opacity(0.4))
                    Text("No Services Yet")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Add the services you offer so customers can discover and book you.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Button(action: { showAddService = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add Your First Service")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(mainColor)
                        .cornerRadius(22)
                    }
                    .padding(.top, 4)
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Stats row
                        HStack(spacing: 0) {
                            statCell(value: "\(services.count)", label: "Listed")
                            Divider().frame(height: 40)
                            statCell(value: "\(services.filter { $0.isActive }.count)", label: "Active")
                            Divider().frame(height: 40)
                            statCell(value: "\(services.filter { !$0.isActive }.count)", label: "Paused")
                        }
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // Add button banner
                        Button(action: { showAddService = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(mainColor)
                                Text("Add New Service")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(mainColor)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(mainColor.opacity(0.07))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        ForEach($services) { $service in
                            WorkerServiceCard(service: $service, onEdit: {
                                serviceToEdit = service
                            }, onDelete: {
                                services.removeAll { $0.id == service.id }
                            })
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        }

                        Spacer().frame(height: 40)
                    }
                }
                .background(Color.gray.opacity(0.04).ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddService) {
            AddEditServiceView(existingService: nil) { newService in
                services.append(newService)
            }
        }
        .sheet(item: $serviceToEdit) { svc in
            AddEditServiceView(existingService: svc) { updated in
                if let idx = services.firstIndex(where: { $0.id == updated.id }) {
                    services[idx] = updated
                }
            }
        }
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(mainColor)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Service Card

struct WorkerServiceCard: View {
    @Binding var service: WorkerService
    var onEdit: () -> Void
    var onDelete: () -> Void

    let mainColor = Color.brandGreen

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Category icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(categoryColor(service.category).opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: categoryIcon(service.category))
                        .font(.system(size: 20))
                        .foregroundColor(categoryColor(service.category))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(service.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    HStack(spacing: 6) {
                        Text(service.category.rawValue)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(categoryColor(service.category))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(categoryColor(service.category).opacity(0.1))
                            .clipShape(Capsule())
                        Text("From $\(Int(service.basePrice))")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                Toggle("", isOn: $service.isActive)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: mainColor))
                    .scaleEffect(0.85)
            }
            .padding(14)

            Divider().padding(.horizontal, 14)

            HStack {
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(mainColor.opacity(0.08))
                    .cornerRadius(8)
                }

                Spacer()

                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Remove")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.07))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    func categoryColor(_ type: ServiceType) -> Color {
        switch type {
        case .cleaning:    return .blue
        case .plumbing:    return .cyan
        case .laundry:     return .teal
        case .painting:    return .green
        case .electrician: return .yellow
        case .assembly:    return .orange
        case .repairing:   return .purple
        case .carpenter:   return .brown
        case .moving:      return .pink
        case .gardening:   return Color.brandGreen
        case .general:     return .gray
        }
    }

    func categoryIcon(_ type: ServiceType) -> String {
        switch type {
        case .cleaning:    return "sparkles"
        case .plumbing:    return "wrench.fill"
        case .laundry:     return "washer.fill"
        case .painting:    return "paintbrush.fill"
        case .electrician: return "bolt.fill"
        case .assembly:    return "hammer.fill"
        case .repairing:   return "screwdriver.fill"
        case .carpenter:   return "ruler.fill"
        case .moving:      return "shippingbox.fill"
        case .gardening:   return "leaf.fill"
        case .general:     return "briefcase.fill"
        }
    }
}
