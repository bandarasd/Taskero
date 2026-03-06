//  Taskero
//

import SwiftUI

enum ClientNotifType {
    case booking, payment, promo, reminder, review

    var icon: String {
        switch self {
        case .booking:  return "briefcase.fill"
        case .payment:  return "creditcard.fill"
        case .promo:    return "tag.fill"
        case .reminder: return "clock.fill"
        case .review:   return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .booking:  return .blue
        case .payment:  return Color.brandGreen
        case .promo:    return .purple
        case .reminder: return .orange
        case .review:   return .yellow
        }
    }
}

struct ClientNotification: Identifiable {
    let id = UUID()
    let type: ClientNotifType
    let title: String
    let body: String
    let timestamp: Date
    var isRead: Bool
}

extension ClientNotification {
    static let mocks: [ClientNotification] = [
        ClientNotification(type: .booking, title: "Booking Confirmed", body: "Your House Cleaning booking with Jenny Wilson has been confirmed for tomorrow at 10 AM.", timestamp: Date().addingTimeInterval(-1200), isRead: false),
        ClientNotification(type: .payment, title: "Payment Successful", body: "Your payment of $87.50 for House Cleaning was processed successfully.", timestamp: Date().addingTimeInterval(-3600), isRead: false),
        ClientNotification(type: .reminder, title: "Upcoming Appointment", body: "Reminder: Laundry service with Albert Flores is scheduled in 2 days.", timestamp: Date().addingTimeInterval(-7200), isRead: true),
        ClientNotification(type: .review, title: "Leave a Review", body: "How was your AC Repair service with Guy Hawkins? Share your experience!", timestamp: Date().addingTimeInterval(-86400), isRead: true),
        ClientNotification(type: .promo, title: "Weekend Offer 🎉", body: "Get 20% off all cleaning services this weekend. Use code: CLEAN20", timestamp: Date().addingTimeInterval(-86400 * 2), isRead: true),
        ClientNotification(type: .booking, title: "Worker On The Way", body: "Wade Warren is heading to your location. ETA: 15 minutes.", timestamp: Date().addingTimeInterval(-86400 * 3), isRead: true),
        ClientNotification(type: .promo, title: "Refer & Earn", body: "Invite friends to Taskero and earn $10 credit for each referral.", timestamp: Date().addingTimeInterval(-86400 * 5), isRead: true)
    ]
}

struct ClientNotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    let mainColor = Color.brandGreen
    @State private var notifications = ClientNotification.mocks

    var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                Spacer()
                Text("Notifications").font(.headline).fontWeight(.bold)
                Spacer()
                if unreadCount > 0 {
                    Button("Mark all read") {
                        for i in notifications.indices { notifications[i].isRead = true }
                    }
                    .font(.caption).fontWeight(.semibold).foregroundColor(mainColor)
                } else {
                    Image(systemName: "arrow.left").opacity(0)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 3, y: 2)

            if notifications.isEmpty {
                Spacer()
                VStack(spacing: 14) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 46)).foregroundColor(.gray.opacity(0.3))
                    Text("No Notifications").font(.headline)
                    Text("You're all caught up!").font(.subheadline).foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach($notifications) { $notif in
                            ClientNotifRow(notification: $notif)
                                .onTapGesture { notif.isRead = true }
                            Divider().padding(.leading, 70)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 5, y: 3)
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Spacer().frame(height: 60)
                }
                .background(Color.gray.opacity(0.04).ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
    }
}

struct ClientNotifRow: View {
    @Binding var notification: ClientNotification

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(notification.type.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: notification.type.icon)
                    .font(.system(size: 18))
                    .foregroundColor(notification.type.color)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline)
                        .fontWeight(notification.isRead ? .regular : .bold)
                    Spacer()
                    Text(relTimeStr(notification.timestamp))
                        .font(.caption2).foregroundColor(.gray)
                }
                Text(notification.body)
                    .font(.caption).foregroundColor(.gray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if !notification.isRead {
                Circle().fill(Color.brandGreen).frame(width: 8, height: 8).padding(.top, 4)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 14)
        .background(notification.isRead ? Color.white : Color.brandGreen.opacity(0.03))
    }

    private func relTimeStr(_ date: Date) -> String {
        let diff = Date().timeIntervalSince(date)
        if diff < 3600 { return "\(Int(diff / 60))m" }
        if diff < 86400 { return "\(Int(diff / 3600))h" }
        return "\(Int(diff / 86400))d"
    }
}

#Preview { ClientNotificationsView() }
