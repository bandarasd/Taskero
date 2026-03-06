//
//  CategoryServicesView.swift
//  Taskero
//

import SwiftUI

struct CategoryServicesView: View {
    let category: CategoryItem
    @Environment(\.presentationMode) var presentationMode
    @State private var sortOption: SortOption = .topRated
    @State private var searchText = ""

    let mainColor = Color.brandGreen

    enum SortOption: String, CaseIterable {
        case topRated  = "Top Rated"
        case priceLow  = "Price: Low"
        case priceHigh = "Price: High"
    }

    var allServices: [ServiceItem] {
        let all = MockData.bestServices + MockData.kitchenCleaningServices +
                  MockData.plumbingServices + MockData.homeMaintenanceServices
        let type = serviceType(for: category.name)
        if let type { return all.filter { $0.type == type } }
        return all
    }

    var filteredServices: [ServiceItem] {
        var result = allServices
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.provider.localizedCaseInsensitiveContains(searchText)
            }
        }
        switch sortOption {
        case .topRated:  return result.sorted { $0.rating > $1.rating }
        case .priceLow:  return result.sorted { priceValue($0.price) < priceValue($1.price) }
        case .priceHigh: return result.sorted { priceValue($0.price) > priceValue($1.price) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(category.backgroundColor.opacity(0.15))
                            .frame(width: 32, height: 32)
                        if category.isSystemImage {
                            Image(systemName: category.icon)
                                .font(.system(size: 14)).foregroundColor(category.backgroundColor)
                        } else {
                            Image(category.icon).resizable().scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                    }
                    Text(category.name).font(.headline).fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            // Search + Sort
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search in \(category.name)...", text: $searchText)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.04), radius: 3, y: 1)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SortOption.allCases, id: \.self) { opt in
                            Text(opt.rawValue)
                                .font(.caption).fontWeight(.semibold)
                                .padding(.horizontal, 14).padding(.vertical, 7)
                                .background(sortOption == opt ? mainColor : Color.white)
                                .foregroundColor(sortOption == opt ? .white : .gray)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
                                .onTapGesture { withAnimation { sortOption = opt } }
                        }
                    }
                }
            }
            .padding(.horizontal).padding(.vertical, 10)
            .background(Color.gray.opacity(0.04))

            if filteredServices.isEmpty {
                Spacer()
                VStack(spacing: 14) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 44)).foregroundColor(mainColor.opacity(0.3))
                    Text("No Services Found").font(.headline)
                    Text("Try a different category or search term.")
                        .font(.subheadline).foregroundColor(.gray)
                        .multilineTextAlignment(.center).padding(.horizontal, 40)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        Text("\(filteredServices.count) services available")
                            .font(.caption).foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(filteredServices) { service in
                            NavigationLink(destination: ServiceDetailView(service: service)) {
                                ServiceListCard(service: service, mainColor: mainColor)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    Spacer().frame(height: 100)
                }
                .background(Color.gray.opacity(0.04).ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
    }

    private func serviceType(for name: String) -> ServiceType? {
        switch name.lowercased() {
        case "cleaner":      return .cleaning
        case "plumber":      return .plumbing
        case "painter":      return .painting
        case "electrician":  return .electrician
        case "carpenter":    return .carpenter
        case "mover":        return .moving
        case "gardener":     return .gardening
        case "ac repair":    return .repairing
        default:             return nil
        }
    }

    private func priceValue(_ price: String) -> Int {
        Int(price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0
    }
}

struct ServiceListCard: View {
    let service: ServiceItem
    let mainColor: Color

    var body: some View {
        HStack(spacing: 14) {
            Group {
                if let name = service.imageName, UIImage(named: name) != nil {
                    Image(name).resizable().scaledToFill()
                        .frame(width: 90, height: 90).clipped()
                        .cornerRadius(12)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(service.imageColor.opacity(0.25))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(service.imageColor.opacity(0.6))
                                .font(.title2)
                        )
                }
            }
            .frame(width: 90, height: 90)

            VStack(alignment: .leading, spacing: 6) {
                Text(service.title).font(.subheadline).fontWeight(.bold).lineLimit(2)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill").font(.caption2).foregroundColor(.yellow)
                    Text(service.rating).font(.caption2).foregroundColor(.gray)
                }
                Text(service.provider).font(.caption).foregroundColor(.gray).lineLimit(1)
                HStack(spacing: 6) {
                    Text(service.price).font(.subheadline).fontWeight(.bold).foregroundColor(mainColor)
                    if !service.originalPrice.isEmpty {
                        Text(service.originalPrice).font(.caption).strikethrough().foregroundColor(.gray)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
    }
}

#Preview {
    NavigationView {
        CategoryServicesView(category: MockData.categories[0])
    }
}
