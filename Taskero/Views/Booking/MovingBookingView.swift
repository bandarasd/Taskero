//
//  MovingBookingView.swift
//  Taskero
//

import SwiftUI

enum MovePropertyType: String, CaseIterable {
    case studio      = "Studio / Bedsit"
    case oneBed      = "1-Bedroom Flat"
    case twoBed      = "2-Bedroom Flat"
    case threePlusBed = "3+ Bedroom House"
    case office      = "Office / Commercial"
    case singleItems = "Single Items Only"

    var basePrice: Double {
        switch self {
        case .studio:       return 80
        case .oneBed:       return 120
        case .twoBed:       return 180
        case .threePlusBed: return 280
        case .office:       return 350
        case .singleItems:  return 60
        }
    }
}

enum MoveDistance: String, CaseIterable {
    case local  = "Local (< 5 km)"
    case short  = "Short (5–30 km)"
    case medium = "Medium (30–100 km)"
    case long   = "Long (100+ km)"

    var multiplier: Double {
        switch self {
        case .local:  return 1.0
        case .short:  return 1.3
        case .medium: return 1.7
        case .long:   return 2.5
        }
    }
}

enum FloorLevel: String, CaseIterable {
    case ground  = "Ground Floor"
    case low     = "1st – 3rd Floor"
    case mid     = "4th – 7th Floor"
    case high    = "8th Floor & Above"

    var surcharge: Double {
        switch self {
        case .ground: return 0
        case .low:    return 15
        case .mid:    return 30
        case .high:   return 50
        }
    }
}

struct MovingBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    let service: ServiceItem

    @State private var propertyType: MovePropertyType = .oneBed
    @State private var distance: MoveDistance = .local
    @State private var floorLevel: FloorLevel = .ground
    @State private var hasElevator = false
    @State private var needsPacking = false
    @State private var hasHeavyItems = false
    @State private var isUrgent = false
    @State private var jobDetails = ""

    var totalPrice: Int {
        let base = propertyType.basePrice * distance.multiplier
        let floor = hasElevator ? 0 : floorLevel.surcharge
        let packing = needsPacking ? 50.0 : 0
        let heavy = hasHeavyItems ? 60.0 : 0
        let urgency = isUrgent ? 50.0 : 0
        return Int(base + floor + packing + heavy + urgency)
    }

    var serviceDetails: ServiceDetails {
        var items: [(label: String, value: String)] = []
        items.append(("Property Type", propertyType.rawValue))
        items.append(("Distance", distance.rawValue))
        items.append(("Floor Level", floorLevel.rawValue))
        items.append(("Has Elevator", hasElevator ? "Yes" : "No"))
        items.append(("Packing Service", needsPacking ? "Yes (+$50)" : "No"))
        items.append(("Heavy Items", hasHeavyItems ? "Yes (+$60)" : "No"))
        items.append(("Urgent Request", isUrgent ? "Yes" : "No"))
        if !jobDetails.isEmpty { items.append(("Job Details", jobDetails)) }
        return ServiceDetails(items: items)
    }

    var body: some View {
        VStack(spacing: 0) {
            bookingHeader(title: service.title, presentationMode: presentationMode)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Share your move details for an accurate estimate.")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Property Type
                    bookingSection("Property Type") {
                        Picker("Property", selection: $propertyType) {
                            ForEach(MovePropertyType.allCases, id: \.self) { t in
                                Text(t.rawValue).tag(t)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 110)
                        .clipped()
                    }

                    // Distance
                    bookingSection("Moving Distance") {
                        VStack(spacing: 8) {
                            ForEach(MoveDistance.allCases, id: \.self) { d in
                                HStack {
                                    Text(d.rawValue)
                                        .font(.subheadline)
                                    Spacer()
                                    if distance == d {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.brandGreen)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(12)
                                .background(distance == d ? Color.brandGreen.opacity(0.08) : Color.gray.opacity(0.04))
                                .cornerRadius(10)
                                .onTapGesture { distance = d }
                            }
                        }
                    }

                    // Floor Level
                    bookingSection("Floor Level (Origin)") {
                        Picker("Floor", selection: $floorLevel) {
                            ForEach(FloorLevel.allCases, id: \.self) { f in
                                Text(f.rawValue).tag(f)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    // Options toggles
                    VStack(spacing: 0) {
                        Toggle("Has Elevator Access", isOn: $hasElevator)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Packing & Unpacking Service  +$50", isOn: $needsPacking)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Heavy / Oversized Items  +$60", isOn: $hasHeavyItems)
                            .font(.subheadline).fontWeight(.semibold)
                            .toggleStyle(SwitchToggleStyle(tint: .brandGreen))
                            .padding()
                        Divider()
                        Toggle("Urgent / Next-Day Move  +$50", isOn: $isUrgent)
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
    MovingBookingView(service: ServiceItem(title: "Moving Service", price: "$120", originalPrice: "", rating: "4.6", provider: "Move Masters", imageColor: .pink, imageName: nil, type: .moving))
}
