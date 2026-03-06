//
//  HelpCenterView.swift
//  Taskero
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let category: String
}

struct HelpCenterView: View {
    @Environment(\.presentationMode) var presentationMode
    let mainColor = Color.brandGreen
    @State private var searchText = ""
    @State private var expandedID: UUID? = nil
    @State private var selectedCategory = "All"

    let categories = ["All", "Booking", "Payment", "Account", "Workers"]

    let faqs: [FAQItem] = [
        FAQItem(question: "How do I book a service?", answer: "Browse services from the Home or Categories tab. Tap on a service, customize your requirements on the booking screen, then proceed to payment.", category: "Booking"),
        FAQItem(question: "Can I cancel a booking?", answer: "Yes. Go to My Bookings → select the upcoming booking → tap Cancel. Cancellations made more than 24 hours before the service are fully refunded.", category: "Booking"),
        FAQItem(question: "How do I reschedule?", answer: "Open the booking from My Bookings, tap the three-dot menu, and select Reschedule. Choose a new date and time that works for the provider.", category: "Booking"),
        FAQItem(question: "What payment methods are accepted?", answer: "We accept Visa, Mastercard, American Express, Apple Pay, Google Pay, and PayPal.", category: "Payment"),
        FAQItem(question: "When am I charged?", answer: "Payment is authorized at booking but only captured once the service is completed and you confirm satisfaction.", category: "Payment"),
        FAQItem(question: "How do I get a refund?", answer: "Refunds are processed automatically for cancelled bookings within the policy window. For disputes, contact support within 48 hours of service completion.", category: "Payment"),
        FAQItem(question: "How do I update my profile?", answer: "Go to Profile → Edit Profile to update your name, email, phone number, and address.", category: "Account"),
        FAQItem(question: "How do I change my address?", answer: "Go to Profile → Address to add or update your saved addresses.", category: "Account"),
        FAQItem(question: "Is my payment information secure?", answer: "Yes. We use industry-standard encryption (TLS 1.3) and never store your full card details on our servers.", category: "Account"),
        FAQItem(question: "How are workers verified?", answer: "All workers go through identity verification, background checks, and skills assessment before being approved on the platform.", category: "Workers"),
        FAQItem(question: "What if I'm unhappy with the service?", answer: "Contact the worker via chat first. If unresolved, raise a dispute through your order details within 48 hours and our team will mediate.", category: "Workers")
    ]

    var filteredFAQs: [FAQItem] {
        faqs.filter { item in
            (selectedCategory == "All" || item.category == selectedCategory) &&
            (searchText.isEmpty || item.question.localizedCaseInsensitiveContains(searchText))
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
                Text("Help Center").font(.headline).fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            ScrollView {
                VStack(spacing: 20) {
                    // Hero
                    VStack(spacing: 10) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(mainColor)
                        Text("How can we help?")
                            .font(.title3).fontWeight(.bold)
                        Text("Find answers to common questions or contact our support team.")
                            .font(.subheadline).foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.vertical, 10)

                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search questions...", text: $searchText)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)

                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat)
                                    .font(.caption).fontWeight(.semibold)
                                    .padding(.horizontal, 14).padding(.vertical, 7)
                                    .background(selectedCategory == cat ? mainColor : Color.white)
                                    .foregroundColor(selectedCategory == cat ? .white : .gray)
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
                                    .onTapGesture { withAnimation { selectedCategory = cat } }
                            }
                        }
                    }

                    // FAQs
                    VStack(spacing: 10) {
                        ForEach(filteredFAQs) { item in
                            FAQRow(item: item, isExpanded: expandedID == item.id) {
                                withAnimation(.spring(response: 0.35)) {
                                    expandedID = expandedID == item.id ? nil : item.id
                                }
                            }
                        }
                    }

                    // Contact card
                    VStack(spacing: 14) {
                        Text("Still need help?").font(.headline)
                        Text("Our support team is available 24/7.")
                            .font(.subheadline).foregroundColor(.gray)
                        HStack(spacing: 14) {
                            contactButton(icon: "message.fill", label: "Live Chat", color: mainColor)
                            contactButton(icon: "envelope.fill", label: "Email Us", color: .blue)
                            contactButton(icon: "phone.fill", label: "Call Us", color: .orange)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 2)

                    Spacer().frame(height: 80)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func contactButton(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle().fill(color.opacity(0.12)).frame(width: 44, height: 44)
                Image(systemName: icon).foregroundColor(color)
            }
            Text(label).font(.caption2).fontWeight(.semibold).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: action) {
                HStack {
                    Text(item.question)
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption).fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(16)
            }
            if isExpanded {
                Text(item.answer)
                    .font(.subheadline).foregroundColor(.gray)
                    .padding(.horizontal, 16).padding(.bottom, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .clipped()
    }
}

#Preview { HelpCenterView() }
