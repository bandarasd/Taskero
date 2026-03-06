//
//  MessagesView.swift
//  Taskero
//

import SwiftUI

struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String?
    let lastMessage: String
    let timestamp: Date
    let unreadCount: Int
    let serviceTitle: String
    let isOnline: Bool
}

extension Conversation {
    static let mockList: [Conversation] = [
        Conversation(name: "Jenny Wilson", avatar: "worker_2", lastMessage: "I'll be there by 10 AM!", timestamp: Date().addingTimeInterval(-300), unreadCount: 2, serviceTitle: "House Cleaning", isOnline: true),
        Conversation(name: "Wade Warren", avatar: "worker_3", lastMessage: "The pipe is fixed. All good now.", timestamp: Date().addingTimeInterval(-3600), unreadCount: 0, serviceTitle: "Plumbing", isOnline: false),
        Conversation(name: "Andrew Sirolin", avatar: "worker_1", lastMessage: "Can you send me the address?", timestamp: Date().addingTimeInterval(-7200), unreadCount: 1, serviceTitle: "Deep Cleaning", isOnline: true),
        Conversation(name: "Guy Hawkins", avatar: "worker_4", lastMessage: "Job completed successfully!", timestamp: Date().addingTimeInterval(-86400), unreadCount: 0, serviceTitle: "AC Repair", isOnline: false),
        Conversation(name: "Kristin Watson", avatar: "worker_7", lastMessage: "Sure, what time works for you?", timestamp: Date().addingTimeInterval(-86400 * 2), unreadCount: 0, serviceTitle: "Window Cleaning", isOnline: false),
        Conversation(name: "Eleanor Pena", avatar: "worker_10", lastMessage: "On my way! ETA 20 mins.", timestamp: Date().addingTimeInterval(-86400 * 3), unreadCount: 0, serviceTitle: "Gardening", isOnline: true)
    ]
}

struct MessagesView: View {
    let mainColor = Color.brandGreen
    @State private var searchText = ""
    @State private var conversations: [Conversation] = Conversation.mockList

    var filtered: [Conversation] {
        if searchText.isEmpty { return conversations }
        return conversations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.serviceTitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Messages")
                        .font(.title2).fontWeight(.bold)
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.title2)
                        let total = conversations.reduce(0) { $0 + $1.unreadCount }
                        if total > 0 {
                            Text("\(total)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(3)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 6, y: -5)
                        }
                    }
                }
                .padding()

                // Search
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search conversations...", text: $searchText)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 12)

                if filtered.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 44))
                            .foregroundColor(mainColor.opacity(0.35))
                        Text("No conversations yet")
                            .font(.headline)
                        Text("Your chats with service providers will appear here.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filtered) { convo in
                                NavigationLink(destination: ChatView(conversation: convo)) {
                                    ConversationRow(conversation: convo)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Divider().padding(.leading, 80)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
                        .padding(.horizontal)
                        .padding(.top, 4)

                        Spacer().frame(height: 100)
                    }
                    .background(Color.gray.opacity(0.04).ignoresSafeArea())
                }
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                if let avatar = conversation.avatar, UIImage(named: avatar) != nil {
                    Image(avatar)
                        .resizable().scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                } else {
                    Circle().fill(Color.brandGreen.opacity(0.2))
                        .frame(width: 54, height: 54)
                        .overlay(
                            Text(String(conversation.name.prefix(1)))
                                .font(.headline).fontWeight(.bold)
                                .foregroundColor(.brandGreen)
                        )
                }
                if conversation.isOnline {
                    Circle().fill(Color.green).frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.name)
                        .font(.subheadline).fontWeight(.semibold)
                    Spacer()
                    Text(timeString(conversation.timestamp))
                        .font(.caption2).foregroundColor(.gray)
                }
                HStack {
                    Text(conversation.lastMessage)
                        .font(.caption).foregroundColor(.gray)
                        .lineLimit(1)
                    Spacer()
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2).fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.brandGreen)
                            .clipShape(Capsule())
                    }
                }
                Text(conversation.serviceTitle)
                    .font(.caption2)
                    .foregroundColor(.brandGreen)
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Color.brandGreen.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }

    private func timeString(_ date: Date) -> String {
        let diff = Date().timeIntervalSince(date)
        if diff < 3600 { return "\(Int(diff / 60))m ago" }
        if diff < 86400 { return "\(Int(diff / 3600))h ago" }
        let fmt = DateFormatter(); fmt.dateFormat = "MMM d"
        return fmt.string(from: date)
    }
}

#Preview { MessagesView() }
