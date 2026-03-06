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
    @State private var currentImageIndex = 0
    
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
                        includedServicesSection
                        howItWorksSection
                        photosSection
                        reviewsSection
                        Spacer().frame(height: 100)
                    }
                    .padding()
                    .background(Color.white)
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
            let displayImages = service.images.isEmpty ? (service.imageName != nil ? [service.imageName!] : []) : service.images
            
            if !displayImages.isEmpty {
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentImageIndex) {
                        ForEach(0..<displayImages.count, id: \.self) { index in
                            Image(displayImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 350)
                                .clipped()
                                .tag(index)
                        }
                    }
                    .frame(height: 350)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Dots indicator
                    if displayImages.count > 1 {
                        HStack(spacing: 8) {
                            ForEach(0..<displayImages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentImageIndex == index ? Color.brandGreen : Color.white.opacity(0.5))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    }
                }
            } else {
                Rectangle()
                    .fill(service.imageColor.opacity(0.3))
                    .frame(height: 350)
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
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 50)
            .padding(.horizontal)
        }
    }
    
    private var titleAndProviderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(service.title)
                .font(.title)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 12) {
                // Provider Profile
                ZStack {
                    Circle()
                        .fill(Color.brandGreen.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Text(service.provider.prefix(1))
                        .font(.headline)
                        .foregroundColor(.brandGreen)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(service.provider)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text("4.8")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("(4.4K Reviews)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 10) {
                    Button(action: {}) {
                        Image(systemName: "message.fill")
                            .foregroundColor(.brandGreen)
                            .padding(10)
                            .background(Color.brandGreen.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.brandGreen)
                            .padding(10)
                            .background(Color.brandGreen.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.vertical, 8)
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
    
    private var includedServicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's Included")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                inclusionRow(text: "Deep cleaning of all surfaces")
                inclusionRow(text: "Eco-friendly cleaning supplies")
                inclusionRow(text: "Professional & vetted taskers")
                inclusionRow(text: "100% Satisfaction guarantee")
            }
        }
    }
    
    private func inclusionRow(text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.brandGreen)
            Text(text)
                .font(.body)
                .foregroundColor(.gray)
        }
    }
    
    private var howItWorksSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("How it Works")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    processStep(icon: "1.circle.fill", title: "Book", description: "Select date & time")
                    processStep(icon: "2.circle.fill", title: "Clean", description: "Tasker arrives")
                    processStep(icon: "3.circle.fill", title: "Done", description: "Enjoy your home")
                }
            }
        }
    }
    
    private func processStep(icon: String, title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.brandGreen)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 100, alignment: .leading)
        }
        .padding()
        .background(Color.brandGreen.opacity(0.05))
        .cornerRadius(16)
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
            
            // Dictionary to map rating to star counts
            ForEach(MockData.reviews.prefix(3)) { review in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        if let imageName = review.reviewerImage, UIImage(named: imageName) != nil {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Text(review.reviewerName.prefix(1))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(review.reviewerName)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(review.comment)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                            Text("\(review.rating)")
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
                    
                    if let images = review.reviewImages, !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(images, id: \.self) { img in
                                    Image(img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 4) {
                            Image(systemName: "heart")
                            Text("\(review.likes)")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                        Text(review.timeAgo)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
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
        case .carpenter:
            CarpentryBookingView(service: service)
        case .moving:
            MovingBookingView(service: service)
        case .gardening:
            GardeningBookingView(service: service)
        case .general:
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
