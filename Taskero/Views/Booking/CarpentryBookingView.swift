//
//  CarpentryBookingView.swift
//  Taskero
//

import SwiftUI

enum CarpentryWorkType: String, CaseIterable {
    case furnitureRepair   = "Furniture Repair"
    case customBuild       = "Custom Build"
    case cabinetMaking     = "Cabinet Making"
    case doorWindow        = "Door / Window Frame"
    case deckingFlooring   = "Decking & Flooring"
    case other             = "Other"

    var basePrice: Double {
        switch self {
        case .furnitureRepair:  return 60
        case .customBuild:      return 150
        case .cabinetMaking:    return 130
        case .doorWindow:       return 80
        case .deckingFlooring:  return 200
        case .other:            return 70
        }
    }
}

enum CarpentryComplexity: String, CaseIterable {
    case simple   = "Simple"
    case standard = "Standard"
    case complex  = "Complex"

    var multiplier: Double {
        switch self {
        case .simple:   return 1.0
        case .standard: return 1.4
        case .complex:  return 2.0
        }
    }
}

enum WoodType: String, CaseIterable {
    case any       = "No Preference"
    case hardwood  = "Hardwood"
    case softwood  = "Softwood"
    case plywood   = "Plywood"
    case mdf       = "MDF"

    var surcharge: Double {
        switch self {
        case .any, .softwood, .mdf: return 0
        case .plywood:  return 15
        case .hardwood: return 30
        }
    }
}

struct CarpentryBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem

    @State private var workType: CarpentryWorkType = .furnitureRepair
    @State private var complexity: CarpentryComplexity = .standard
    @State private var woodType: WoodType = .any
    @State private var itemCount = 1
    @State private var materialProvided = false
    @State private var isUrgent = false
    @State private var jobDetails = ""

    var totalPrice: Int {
        let base = workType.basePrice * complexity.multiplier
        let woodFee = materialProvided ? 0 : woodType.surcharge
        let items = Double(itemCount)
        let urgency = isUrgent ? 40.0 : 0
        return Int(base * items + woodFee + urgency)
    }

    var serviceDetails: ServiceDetails {
        var items: [(label: String, value: String)] = []
        items.append(("Work Type", workType.rawValue))
        items.append(("Complexity", complexity.rawValue))
        items.append(("Number of Items", "\(itemCount)"))
        items.append(("Wood Type", woodType.rawValue))
        items.append(("Materials Provided", materialProvided ? "Yes (by me)" : "No (worker supplies)"))
        items.append(("Urgent Request", isUrgent ? "Yes" : "No"))
        if !jobDetails.isEmpty { items.append(("Job Details", jobDetails)) }
        return ServiceDetails(items: items)
    }

    var body: some View {
        VStack(spacing: 0) {
            bookingHeader(title: service.title, presentationMode: presentationMode)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Tell us about your carpentry job for an accurate quote.")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Work Type
                    bookingSection("Type of Work") {
                        Picker("Work Type", selection: $workType) {
                            ForEach(CarpentryWorkType.allCases, id: \.self) { t in
                                Text(t.rawValue).tag(t)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 110)
                        .clipped()
                    }

                    // Complexity
                    bookingSection("Complexity") {
                        Picker("Complexity", selection: $complexity) {
                            ForEach(CarpentryComplexity.allCases, id: \.self) { c in
                                Text(c.rawValue).tag(c)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Number of items
                    HStack {
                        Text("Number of Items")
                            .font(.headline).fontWeight(.bold)
                        Spacer()
                        Stepper(value: $itemCount, in: 1...20) {
                            Text("\(itemCount)").fontWeight(.bold)
                        }
                    }
                    .softCard()

                    // Wood Type
                    bookingSection("Wood Type Preference") {
                        Picker("Wood", selection: $woodType) {
                            ForEach(WoodType.allCases, id: \.self) { w in
                                Text(w.rawValue).tag(w)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 110)
                        .clipped()
                    }

                    // Toggles
                    VStack(spacing: 0) {
                        Toggle("I'll supply the materials", isOn: $materialProvided)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Urgent / Same-Day Request  +$40", isOn: $isUrgent)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                    }
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)

                    // Job Details
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
    CarpentryBookingView(service: ServiceItem(title: "Carpentry", price: "$60", originalPrice: "", rating: "4.7", provider: "Jim Carpenter", imageColor: .brown, imageName: nil, type: .carpenter))
}
