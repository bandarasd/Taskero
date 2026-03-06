//
//  WorkerNotificationsView.swift
//  Taskero
//

import SwiftUI

// MARK: - Model

enum WorkerNotificationType {
    case newJob, payment, reminder, review, system
    
    var icon: String {
        switch self {
        case .newJob:    return "briefcase.fill"
        case .payment:   return "dollarsign.circle.fill"
        case .reminder:  return "clock.fill"
        case .review:    return "star.fill"
        case .system:    return "bell.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .newJob:    return .blue
        case .payment:   return .brandGreen
        case .reminder:  return .orange
        case .review:    return .yellow
        case .system:    return .gray
        }
    }
    
    var iconBackground: Color { iconColor.opacity(0.12) }
}

struct WorkerNotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timeAgo: String
    let type: WorkerNotificationType
    var isRead: Bool
}

// MARK: - Mock Data

private let mockWorkerNotifications: [WorkerNotificationItem] = [
    WorkerNotificationItem(title: "New Job Request!", message: "Sarah Connor requested Kitchen Cleaning on tomorrow at 9:00 AM. Accept before it expires!", timeAgo: "2 min ago", type: .newJob, isRead: false),
    WorkerNotificationItem(title: "Payment Received", message: "You received $150.00 for Job #HOV01203454. The payout is now in your wallet.", timeAgo: "1h ago", type: .payment, isRead: false),
    WorkerNotificationItem(title: "Job Reminder", message: "Your AC Service job for Emily Davis starts in 1 hour at 3:00 PM.", timeAgo: "2h ago", type: .reminder, isRead: true),
    WorkerNotificationItem(title: "New Review 🌟", message: "Jessica Wilson left you a 5-star review: \"Assembled everything perfectly, very professional!\"", timeAgo: "5h ago", type: .review, isRead: true),
    WorkerNotificationItem(title: "New Job Request!", message: "John Smith requested Pipe Leak Fix on March 8 at 2:00 PM. Payout: $80.00", timeAgo: "Yesterday", type: .newJob, isRead: true),
    WorkerNotificationItem(title: "Payment Received", message: "You received $85.00 for Job #HOV01203461. Funds available in your wallet.", timeAgo: "2d ago", type: .payment, isRead: true),
    WorkerNotificationItem(title: "Profile Update", message: "Your profile has been verified! You now have a verified badge on your profile.", timeAgo: "3d ago", type: .system, isRead: true),
    WorkerNotificationItem(title: "Weekly Earnings Summary", message: "This week you earned $485.00 across 4 jobs. Keep it up! 💪", timeAgo: "1 week ago", type: .payment, isRead: true)
]

// MARK: - View

struct WorkerNotificationsView: View {

    let mainColor = Color.brandGreen
    @Environment(\.presentationMode) var presentationMode
    @State private var notifications = mockWorkerNotifications

    var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var groupedNotifications: [(String, [WorkerNotificationItem])] {
        let today = notifications.filter { ["2 min ago", "1h ago", "2h ago", "5h ago"].contains($0.timeAgo) }
        let yesterday = notifications.filter { $0.timeAgo == "Yesterday" }
        let older = notifications.filter { ["2d ago", "3d ago", "1 week ago"].contains($0.timeAgo) }
        var groups: [(String, [WorkerNotificationItem])] = []
        if !today.isEmpty     { groups.append(("Today", today)) }
        if !yesterday.isEmpty { groups.append(("Yesterday", yesterday)) }
        if !older.isEmpty     { groups.append(("Earlier", older)) }
        return groups
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Notifications")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                if unreadCount > 0 {
                    Button(action: markAllRead) {
                        Text("Mark all read")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(mainColor)
                    }
                } else {
                    Image(systemName: "arrow.left").opacity(0)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)

            if notifications.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.25))
                    Text("No notifications yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(groupedNotifications, id: \.0) { group in
                            Section(header: SectionHeader(title: group.0)) {
                                ForEach(group.1) { notification in
                                    NotificationRow(notification: notification, mainColor: mainColor)
                                        .onTapGesture { markRead(notification) }
                                    Divider()
                                        .padding(.leading, 70)
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
                    .padding()
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.gray.opacity(0.05).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private func markAllRead() {
        withAnimation {
            for i in notifications.indices {
                notifications[i].isRead = true
            }
        }
    }

    private func markRead(_ item: WorkerNotificationItem) {
        if let idx = notifications.firstIndex(where: { $0.id == item.id }) {
            notifications[idx].isRead = true
        }
    }
}

// MARK: - Subviews

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .textCase(.uppercase)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.05))
    }
}

private struct NotificationRow: View {
    let notification: WorkerNotificationItem
    let mainColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(notification.type.iconBackground)
                    .frame(width: 46, height: 46)
                Image(systemName: notification.type.icon)
                    .font(.system(size: 18))
                    .foregroundColor(notification.type.iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline)
                        .fontWeight(notification.isRead ? .medium : .bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(notification.timeAgo)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Text(notification.message)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !notification.isRead {
                Circle()
                    .fill(mainColor)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(notification.isRead ? Color.white : mainColor.opacity(0.02))
    }
}

#Preview {
    WorkerNotificationsView()
}
