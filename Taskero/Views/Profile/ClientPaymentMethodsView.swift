//
//  ClientPaymentMethodsView.swift
//  Taskero
//

import SwiftUI

struct PaymentCard: Identifiable {
    let id = UUID()
    var cardholderName: String
    var lastFour: String
    var network: CardNetwork
    var expiry: String
    var isDefault: Bool

    enum CardNetwork: String {
        case visa, mastercard, amex

        var icon: String {
            switch self {
            case .visa:       return "visa_icon"
            case .mastercard: return "mastercard"
            case .amex:       return "amex_icon"
            }
        }
        var color: Color {
            switch self {
            case .visa:       return Color(red: 0.09, green: 0.20, blue: 0.58)
            case .mastercard: return Color(red: 0.82, green: 0.19, blue: 0.13)
            case .amex:       return Color(red: 0.10, green: 0.45, blue: 0.74)
            }
        }
    }
}

struct ClientPaymentMethodsView: View {
    @Environment(\.presentationMode) var presentationMode
    let mainColor = Color.brandGreen

    @State private var cards: [PaymentCard] = [
        PaymentCard(cardholderName: "Mark Robinson", lastFour: "4242", network: .visa, expiry: "08/27", isDefault: true),
        PaymentCard(cardholderName: "Mark Robinson", lastFour: "5555", network: .mastercard, expiry: "03/26", isDefault: false)
    ]
    @State private var showAddCard = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text("Payment Methods").font(.headline).fontWeight(.bold)
                Spacer()
                Button(action: { showAddCard = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2).foregroundColor(mainColor)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            ScrollView {
                VStack(spacing: 20) {
                    // Cards
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Saved Cards").font(.headline).padding(.leading, 4)

                        ForEach(cards) { card in
                            PaymentCardTile(card: card,
                                onSetDefault: {
                                    for i in cards.indices { cards[i].isDefault = (cards[i].id == card.id) }
                                },
                                onDelete: {
                                    cards.removeAll { $0.id == card.id }
                                }
                            )
                        }

                        // Add card button
                        Button(action: { showAddCard = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3).foregroundColor(mainColor)
                                Text("Add New Card")
                                    .font(.subheadline).fontWeight(.semibold).foregroundColor(mainColor)
                                Spacer()
                                Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
                            }
                            .padding(16)
                            .background(mainColor.opacity(0.06))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(mainColor.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [5])))
                        }
                    }

                    // Other payment methods
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Other Methods").font(.headline).padding(.leading, 4)
                        VStack(spacing: 0) {
                            altMethodRow(icon: "apple_pay", label: "Apple Pay")
                            Divider().padding(.leading, 56)
                            altMethodRow(icon: "google_pay", label: "Google Pay")
                            Divider().padding(.leading, 56)
                            altMethodRow(icon: "paypal", label: "PayPal")
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
                    }
                }
                .padding()
                Spacer().frame(height: 80)
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddCard) {
            AddCardView { newCard in cards.append(newCard) }
        }
    }

    @ViewBuilder
    private func altMethodRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            if UIImage(named: icon) != nil {
                Image(icon).resizable().scaledToFit()
                    .frame(width: 36, height: 24)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 36, height: 24)
                    .overlay(Text(label.prefix(1)).font(.caption).fontWeight(.bold).foregroundColor(.gray))
            }
            Text(label).font(.subheadline).fontWeight(.medium)
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
        }
        .padding(16)
    }
}

struct PaymentCardTile: View {
    let card: PaymentCard
    let onSetDefault: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // Card visual
            RoundedRectangle(cornerRadius: 10)
                .fill(card.network.color)
                .frame(width: 60, height: 40)
                .overlay(
                    Text("**** \(card.lastFour)")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: card.network.color.opacity(0.4), radius: 5, y: 2)

            VStack(alignment: .leading, spacing: 3) {
                Text("\(card.network.rawValue.capitalized) •••• \(card.lastFour)")
                    .font(.subheadline).fontWeight(.semibold)
                Text("Expires \(card.expiry)")
                    .font(.caption).foregroundColor(.gray)
                if card.isDefault {
                    Text("Default")
                        .font(.caption2).fontWeight(.bold)
                        .foregroundColor(.brandGreen)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(Color.brandGreen.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            Spacer()
            Menu {
                if !card.isDefault {
                    Button("Set as Default", action: onSetDefault)
                }
                Button("Remove Card", role: .destructive, action: onDelete)
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
    }
}

struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    let onAdd: (PaymentCard) -> Void

    @State private var cardNumber = ""
    @State private var cardholderName = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var showAlert = false

    let mainColor = Color.brandGreen

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Card preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(colors: [mainColor, mainColor.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 180)
                            .shadow(color: mainColor.opacity(0.4), radius: 12, y: 6)
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("TASKERO PAY")
                                    .font(.caption).fontWeight(.bold).foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Image(systemName: "wave.3.right")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Text(formattedCardNumber)
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("CARD HOLDER").font(.system(size: 9)).foregroundColor(.white.opacity(0.7))
                                    Text(cardholderName.isEmpty ? "YOUR NAME" : cardholderName.uppercased())
                                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("EXPIRES").font(.system(size: 9)).foregroundColor(.white.opacity(0.7))
                                    Text(expiry.isEmpty ? "MM/YY" : expiry)
                                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                                }
                            }
                        }
                        .padding(24)
                    }
                    .padding()

                    VStack(spacing: 18) {
                        addCardField("Card Number", text: $cardNumber, keyboard: .numberPad)
                        addCardField("Cardholder Name", text: $cardholderName, keyboard: .default)
                        HStack(spacing: 14) {
                            addCardField("MM/YY", text: $expiry, keyboard: .numberPad)
                            addCardField("CVV", text: $cvv, keyboard: .numberPad)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Add New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }.foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        guard cardNumber.count >= 16, !cardholderName.isEmpty, expiry.count == 5 else {
                            showAlert = true; return
                        }
                        let last4 = String(cardNumber.suffix(4))
                        let card = PaymentCard(cardholderName: cardholderName, lastFour: last4, network: .visa, expiry: expiry, isDefault: false)
                        onAdd(card)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .fontWeight(.bold).foregroundColor(mainColor)
                }
            }
            .alert("Invalid Card", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter valid card details.")
            }
        }
    }

    var formattedCardNumber: String {
        let digits = cardNumber.filter { $0.isNumber }
        let padded = digits.padding(toLength: 16, withPad: "•", startingAt: 0)
        return stride(from: 0, to: 16, by: 4).map { String(padded[padded.index(padded.startIndex, offsetBy: $0)..<padded.index(padded.startIndex, offsetBy: min($0+4, 16))]) }.joined(separator: " ")
    }

    @ViewBuilder
    private func addCardField(_ label: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).fontWeight(.semibold).foregroundColor(.gray)
            TextField(label, text: text)
                .keyboardType(keyboard)
                .padding(12)
                .background(Color.gray.opacity(0.06))
                .cornerRadius(10)
        }
    }
}

#Preview { ClientPaymentMethodsView() }
