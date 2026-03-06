//
//  BookingViewShared.swift
//  Taskero
//
//  Shared components reused across all Booking views.
//

import SwiftUI

// MARK: - Header

func bookingHeader(title: String, presentationMode: Binding<PresentationMode>) -> some View {
    HStack {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundColor(.black)
        }
        Spacer()
        Text(title)
            .font(.headline)
            .foregroundColor(.black)
        Spacer()
        // balance spacer
        Image(systemName: "arrow.left").opacity(0)
    }
    .padding()
    .padding(.top, 40)
    .background(Color.white)
    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
}

// MARK: - Section Container

struct BookingSectionContainer<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
    }
}

// convenience free function returning the container view
func bookingSection<C: View>(_ title: String, @ViewBuilder content: () -> C) -> some View {
    BookingSectionContainer(title, content: content)
}

// MARK: - Job Details Field

func jobDetailsField(text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Additional Details")
            .font(.headline)
            .fontWeight(.bold)
        ZStack(alignment: .topLeading) {
            if text.wrappedValue.isEmpty {
                Text("Describe anything specific about the job...")
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(12)
            }
            TextEditor(text: text)
                .frame(height: 90)
                .padding(8)
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(14)
    .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
}

// MARK: - Bottom Price Bar

func bookingBottomBar(price: Int, service: ServiceItem, details: ServiceDetails) -> some View {
    VStack(spacing: 0) {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Estimated Price")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("$\(price)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandGreen)
            }
            Spacer()
            NavigationLink(destination: BookingDetailsView(service: service, totalPrice: price, serviceDetails: details)) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .background(Color.brandGreen)
                    .cornerRadius(22)
            }
        }
        .padding()
    }
    .background(Color.white)
    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: -4)
}

// MARK: - Soft Card Modifier

extension View {
    func softCard() -> some View {
        self
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
    }
}
