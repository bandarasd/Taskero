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
    @Binding var scrollToTop: Bool
    @State private var showAddressSelection = false
    @State private var currentLocation = MockData.currentUser.address
    @State private var viewID = UUID() // Used to reset navigation stack
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Invisible anchor at the top
                        Color.clear
                            .frame(height: 1)
                            .id("top")
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Button(action: {
                                    showAddressSelection = true
                                }) {
                                    HStack {
                                        Text(currentLocation)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            ZStack(alignment: .topTrailing) {
                                NavigationLink(destination: ClientNotificationsView()) {
                                    Image(systemName: "bell")
                                        .font(.title2)
                                        .padding(8)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                }
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
                                NavigationLink(destination: AllCategoriesView()) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(mainColor)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Grid of Categories (Updated Layout)
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                                ForEach(MockData.categories) { category in
                                    NavigationLink(destination: CategoryServicesView(category: category)) {
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
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Sections
                        ServiceSectionView(title: "Best Services", services: MockData.bestServices, mainColor: mainColor)
                        
                        ServiceSectionView(title: "Kitchen Cleaning", services: MockData.kitchenCleaningServices, mainColor: mainColor)
                        
                        ServiceSectionView(title: "Plumbing Services", services: MockData.plumbingServices, mainColor: mainColor)
                        
                        ServiceSectionView(title: "Home Maintenance", services: MockData.homeMaintenanceServices, mainColor: mainColor)
                        
                        Spacer().frame(height: 100) // Increase spacing to clear tab bar
                    }
                    .padding(.top)
                }
                .background(Color(UIColor.systemBackground))
                .navigationBarHidden(true)
            }
            .sheet(isPresented: $showAddressSelection) {
                AddressSelectionView(onSelect: { selectedAddress in
                    currentLocation = selectedAddress
                })
            }
        }
        .id(viewID) // Replacing the view ID forces a hard reset of the NavigationView
        .onChange(of: scrollToTop) { _ in
            viewID = UUID() // Regenerate ID to pop to root and scroll to top
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
                NavigationLink(destination: ServiceSectionListView(title: title, services: services, mainColor: mainColor)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(mainColor)
                }
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

struct AllCategoriesView: View {
    let mainColor = Color.brandGreen
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    var filteredCategories: [CategoryItem] {
        searchText.isEmpty ? MockData.categories :
            MockData.categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text("All Categories").font(.headline).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search Categories", text: $searchText)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            .padding(.horizontal)
            .padding(.vertical, 10)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(filteredCategories) { category in
                        NavigationLink(destination: CategoryServicesView(category: category)) {
                            CategoryCard(category: category, mainColor: mainColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                Spacer().frame(height: 100)
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView(scrollToTop: .constant(false))
}

struct ServiceSectionListView: View {
    let title: String
    let services: [ServiceItem]
    let mainColor: Color
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text(title).font(.headline).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(services) { service in
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
        .navigationBarHidden(true)
    }
}
