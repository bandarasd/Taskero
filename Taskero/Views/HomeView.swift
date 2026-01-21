//
//  HomeView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct HomeView: View {
    let mainColor = Color.brandGreen
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Text("2118 Thornridge California")
                                    .font(.headline)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                        }
                        
                        Spacer()
                        
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .padding(8)
                                .background(Color.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(mainColor)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading) {
                        HStack {
                            Text("All Categories")
                                .font(.headline)
                            Spacer()
                            Button("See All") { }
                                .font(.subheadline)
                                .foregroundColor(mainColor)
                        }
                        .padding(.horizontal)
                        
                        // Grid of Categories (Updated Layout)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                            ForEach(PermissionModel.categories) { category in
                                VStack {
                                    if category.isSystemImage {
                                        Image(systemName: category.icon)
                                            .font(.system(size: 40)) // Larger system icon
                                            .foregroundColor(category.backgroundColor)
                                            .frame(height: 70)
                                    } else {
                                        Image(category.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60) // Larger asset icon
                                            .frame(height: 70) // Container height for alignment
                                    }
                                    
                                    Text(category.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Sections
                    ServiceSectionView(title: "Best Services", services: [
                        ServiceItem(title: "Complete Kitchen Cleaning", price: "$150", originalPrice: "$180", rating: "(130 Reviews)", provider: "Mark Willions", imageColor: .orange, imageName: "cleaning_service", type: .cleaning),
                        ServiceItem(title: "Living Room Cleaning", price: "$200", originalPrice: "$230", rating: "(240 Reviews)", provider: "Ronald Mark", imageColor: .blue, imageName: "living_room_service", type: .cleaning),
                        ServiceItem(title: "AC Service & Repair", price: "$50", originalPrice: "$120", rating: "(100 Reviews)", provider: "James", imageColor: .cyan, imageName: "ac_repair_service", type: .repairing)
                    ], mainColor: mainColor)
                    
                    ServiceSectionView(title: "Kitchen Cleaning", services: [
                         ServiceItem(title: "Deep Kitchen Clean", price: "$120", originalPrice: "$150", rating: "(80 Reviews)", provider: "Sarah Jones", imageColor: .orange, imageName: "cleaning_service", type: .cleaning),
                         ServiceItem(title: "Sink Repair & Clean", price: "$90", originalPrice: "$110", rating: "(45 Reviews)", provider: "Mike Ross", imageColor: .purple, imageName: "plumbing_service", type: .plumbing),
                         ServiceItem(title: "Cabinet Degreasing", price: "$200", originalPrice: "$250", rating: "(20 Reviews)", provider: "CleanCo", imageColor: .green, imageName: "cleaning_service", type: .cleaning)
                    ], mainColor: mainColor)
                    
                    ServiceSectionView(title: "Plumbing Services", services: [
                         ServiceItem(title: "Pipe Leak Fix", price: "$60", originalPrice: "$90", rating: "(200 Reviews)", provider: "Mario Bros", imageColor: .red, imageName: "plumbing_service", type: .plumbing),
                         ServiceItem(title: "Water Heater Install", price: "$300", originalPrice: "$350", rating: "(15 Reviews)", provider: "HotWater Inc", imageColor: .orange, imageName: "plumbing_service", type: .plumbing),
                         ServiceItem(title: "Drain Unclogging", price: "$80", originalPrice: "$100", rating: "(330 Reviews)", provider: "FastPlumb", imageColor: .blue, imageName: "plumbing_service", type: .plumbing)
                    ], mainColor: mainColor)
                    
                    ServiceSectionView(title: "Home Maintenance", services: [
                         ServiceItem(title: "Wall Painting", price: "$500", originalPrice: "$600", rating: "(50 Reviews)", provider: "ColorWorld", imageColor: .green, imageName: "painting_service", type: .painting),
                         ServiceItem(title: "Furniture Assembly", price: "$100", originalPrice: "$120", rating: "(90 Reviews)", provider: "FixItAll", imageColor: .yellow, imageName: nil, type: .assembly), // Fallback due to quota
                         ServiceItem(title: "Electric Wiring", price: "$150", originalPrice: "$180", rating: "(110 Reviews)", provider: "Sparky", imageColor: .orange, imageName: "electrician_service", type: .electrician)
                    ], mainColor: mainColor)
                    
                    Spacer().frame(height: 100) // Increase spacing to clear tab bar
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemBackground))
            // Removed .ignoresSafeArea(edges: .bottom) to respect Tab Bar
            .navigationBarHidden(true)
        }
    }
}

// Data Model for Services


// Reusable Section View
struct ServiceSectionView: View {
    let title: String
    let services: [ServiceItem]
    let mainColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2.bold())
                Spacer()
                Button("See All") { }
                    .font(.subheadline)
                    .foregroundColor(mainColor)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(services) { service in
                        NavigationLink(destination: ServiceDetailView(service: service)) {
                            ServiceCard(service: service, mainColor: mainColor)
                        }
                        .buttonStyle(PlainButtonStyle()) // Needed to prevent whole cell highlighting/blue overlay in some iOS versions
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ServiceCard: View {
    let service: ServiceItem
    let mainColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image Area
            ZStack(alignment: .bottomTrailing) {
                if let imageName = service.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped() // Ensure it doesn't overflow
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                } else {
                    // Fallback Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [service.imageColor.opacity(0.3), service.imageColor.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(mainColor)
                    }
                    Text(service.rating)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Text(service.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(service.price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(mainColor)
                    
                    Text(service.originalPrice)
                        .font(.caption)
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundColor(.gray)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(service.provider)
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("Service Provider")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Add")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(mainColor)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
        }
        .frame(width: 260)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
