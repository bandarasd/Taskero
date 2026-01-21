//
//  ServiceDetailView.swift
//  Taskero
//
//  Created by Dananjaya Bandara on 2025-12-18.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceItem
    @Environment(\.presentationMode) var presentationMode
    @State private var isAboutMeExpanded = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    
                    VStack(alignment: .leading, spacing: 20) {
                        titleAndProviderSection
                        tagsAndLocationSection
                        priceSection
                        aboutMeSection
                        photosSection
                        reviewsSection
                        Spacer().frame(height: 100)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .offset(y: -30)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            
            bottomActionBar
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        ZStack(alignment: .topLeading) {
            if let imageName = service.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
            } else {
                Rectangle()
                    .fill(service.imageColor.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    )
            }
            
            // Custom Navigation Bar items
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
            }
            .padding(.top, 50)
            .padding(.horizontal)
        }
    }
    
    private var titleAndProviderSection: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Text(service.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Image(systemName: "bookmark")
                    .font(.title2)
                    .foregroundColor(Color.brandGreen)
            }
            
            HStack {
                Image("user_avatar_2") // Placeholder
                    .resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                
                Text(service.provider)
                    .font(.headline)
                    .foregroundColor(Color.brandGreen)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("4.8")
                        .fontWeight(.bold)
                    Text("(4.4K)")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
    }
    
    private var tagsAndLocationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cleaning")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.brandGreen.opacity(0.1))
                    .foregroundColor(Color.brandGreen)
                    .cornerRadius(8)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color.brandGreen)
                    Text("255 Grand Park Avenue, New York")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var priceSection: some View {
        HStack(alignment: .bottom) {
            Text(service.price)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color.brandGreen)
            Text("(Floor price)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 6)
        }
    }
    
    private var aboutMeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About me")
                .font(.headline)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(isAboutMeExpanded ? nil : 3)
            
            Button(action: {
                withAnimation {
                    isAboutMeExpanded.toggle()
                }
            }) {
                Text(isAboutMeExpanded ? "Read less" : "Read more...")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.brandGreen)
            }
        }
    }
    
    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Photos & Videos")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: GalleryView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color.brandGreen)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                }
            }
        }
    }
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                Text("4.8 (4.4K)")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: ReviewsView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color.brandGreen)
                }
            }
            
            // Review Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(["All", "5", "4", "3", "2", "1"], id: \.self) { rating in
                        HStack(spacing: 4) {
                            if rating != "All" {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                            }
                            Text(rating)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(rating == "All" ? Color.brandGreen : Color.white)
                        .foregroundColor(rating == "All" ? .white : Color.brandGreen)
                        .cornerRadius(20)
                        .overlay(
                            Capsule()
                                .stroke(Color.brandGreen, lineWidth: rating == "All" ? 0 : 1)
                        )
                    }
                }
            }
            
            // Single Review Item Mock
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text("Lauralee Quintero")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text("Awesome! this is what i was looking for, i recommend to everyone ❤️❤️❤️")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text("5")
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Capsule().stroke(Color.brandGreen, lineWidth: 1)
                    )
                    .foregroundColor(Color.brandGreen)
                }
                
                HStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                        Text("724")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    
                    Text("3 weeks ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var bottomActionBar: some View {
        HStack(spacing: 20) {
            Button(action: {}) {
                Text("Message")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.brandGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandGreen.opacity(0.1))
                    .cornerRadius(24)
            }
            
            NavigationLink(destination: destinationView) {
                Text("Book Now")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandGreen)
                    .cornerRadius(24)
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch service.type {
        case .cleaning:
            CleaningBookingView(service: service)
        case .plumbing:
            PlumbingBookingView(service: service)
        case .laundry:
            LaundryBookingView(service: service)
        case .painting:
            PaintingBookingView(service: service)
        case .electrician:
            ElectricianBookingView(service: service)
        case .assembly:
            AssemblyBookingView(service: service)
        case .repairing:
            RepairBookingView(service: service)
        default:
            CleaningBookingView(service: service) // Fallback
        }
    }
}

// Preview to verify locally
#Preview {
    ServiceDetailView(service: ServiceItem(
        title: "House Cleaning",
        price: "$20",
        originalPrice: "",
        rating: "4.8",
        provider: "Jenny Wilson",
        imageColor: .green,
        imageName: nil
    ))
}
