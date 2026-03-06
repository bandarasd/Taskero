//
//  GardeningBookingView.swift
//  Taskero
//

import SwiftUI

enum GardeningServiceType: String, CaseIterable {
    case lawnMowing         = "Lawn Mowing"
    case hedgeTrimming      = "Hedge & Shrub Trimming"
    case weedControl        = "Weed Control"
    case gardenDesign       = "Garden Design"
    case treePruning        = "Tree Pruning"
    case fullMaintenance    = "Full Garden Maintenance"

    var baseRatePerSqm: Double {
        switch self {
        case .lawnMowing:       return 1.5
        case .hedgeTrimming:    return 2.0
        case .weedControl:      return 1.8
        case .gardenDesign:     return 4.0
        case .treePruning:      return 3.0
        case .fullMaintenance:  return 3.5
        }
    }
}

enum GardenCondition: String, CaseIterable {
    case wellMaintained = "Well Maintained"
    case moderate       = "Moderate"
    case overgrown      = "Overgrown"

    var multiplier: Double {
        switch self {
        case .wellMaintained: return 1.0
        case .moderate:       return 1.3
        case .overgrown:      return 1.7
        }
    }
}

enum GardeningFrequency: String, CaseIterable {
    case oneTime   = "One-Time"
    case monthly   = "Monthly"
    case biWeekly  = "Bi-Weekly"
    case weekly    = "Weekly"
}

struct GardeningBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem

    @State private var serviceType: GardeningServiceType = .lawnMowing
    @State private var gardenSize: Double = 40 // sqm
    @State private var condition: GardenCondition = .moderate
    @State private var frequency: GardeningFrequency = .oneTime
    @State private var includeWasteRemoval = false
    @State private var includeFertilizing = false
    @State private var isUrgent = false
    @State private var jobDetails = ""

    var totalPrice: Int {
        let base = gardenSize * serviceType.baseRatePerSqm * condition.multiplier
        let waste = includeWasteRemoval ? 25.0 : 0
        let fertilize = includeFertilizing ? 20.0 : 0
        let urgency = isUrgent ? 35.0 : 0
        return Int(base + waste + fertilize + urgency)
    }

    var serviceDetails: ServiceDetails {
        var items: [(label: String, value: String)] = []
        items.append(("Service Type", serviceType.rawValue))
        items.append(("Garden Size", "\(Int(gardenSize)) sqm"))
        items.append(("Condition", condition.rawValue))
        items.append(("Frequency", frequency.rawValue))
        items.append(("Waste Removal", includeWasteRemoval ? "Yes (+$25)" : "No"))
        items.append(("Fertilizing", includeFertilizing ? "Yes (+$20)" : "No"))
        items.append(("Urgent Request", isUrgent ? "Yes" : "No"))
        if !jobDetails.isEmpty { items.append(("Job Details", jobDetails)) }
        return ServiceDetails(items: items)
    }

    var body: some View {
        VStack(spacing: 0) {
            bookingHeader(title: service.title, presentationMode: presentationMode)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Let us know your garden needs for an accurate estimate.")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Service Type
                    bookingSection("Service Type") {
                        Picker("Service", selection: $serviceType) {
                            ForEach(GardeningServiceType.allCases, id: \.self) { t in
                                Text(t.rawValue).tag(t)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 110)
                        .clipped()
                    }

                    // Garden Size
                    bookingSection("Garden Size") {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Area")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(Int(gardenSize)) sqm")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.brandGreen)
                            }
                            Slider(value: $gardenSize, in: 10...1000, step: 10)
                                .accentColor(.brandGreen)
                        }
                    }

                    // Garden Condition
                    bookingSection("Garden Condition") {
                        Picker("Condition", selection: $condition) {
                            ForEach(GardenCondition.allCases, id: \.self) { c in
                                Text(c.rawValue).tag(c)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Frequency
                    bookingSection("Service Frequency") {
                        VStack(spacing: 8) {
                            ForEach(GardeningFrequency.allCases, id: \.self) { f in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(f.rawValue).font(.subheadline)
                                        if f != .oneTime {
                                            Text("Recurring schedule")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: frequency == f ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(frequency == f ? .brandGreen : .gray)
                                }
                                .padding(12)
                                .background(frequency == f ? Color.brandGreen.opacity(0.08) : Color.gray.opacity(0.04))
                                .cornerRadius(10)
                                .onTapGesture { frequency = f }
                            }
                        }
                    }

                    // Add-ons
                    VStack(spacing: 0) {
                        Toggle("Include Waste Removal  +$25", isOn: $includeWasteRemoval)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Include Fertilizing  +$20", isOn: $includeFertilizing)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Urgent / Same-Day Request  +$35", isOn: $isUrgent)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                    }
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)

                    jobDetailsField(text: $jobDetails)

                    Spacer().frame(height: 100)
                }
                .padding()
            }

            bookingBottomBar(price: totalPrice, service: service, details: serviceDetails)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

#Preview {
    GardeningBookingView(service: ServiceItem(title: "Gardening", price: "$40", originalPrice: "", rating: "4.9", provider: "Green Thumb Co.", imageColor: .green, imageName: nil, type: .gardening))
}
