//
//  WorkerMessagesView.swift
//  Taskero
//

import SwiftUI

// MARK: - Model

struct WorkerConversation: Identifiable {
    let id = UUID()
    let customerName: String
    let customerProfileImage: String?
    let lastMessage: String
    let timestamp: String
    let unreadCount: Int
    let jobType: String
    let jobReference: String
}

// MARK: - Mock Conversations

private let mockConversations: [WorkerConversation] = [
    WorkerConversation(customerName: "Sarah Connor", customerProfileImage: "reviewer_1", lastMessage: "Great! I'll leave the key under the mat 🗝️", timestamp: "2m ago", unreadCount: 2, jobType: "Kitchen Cleaning", jobReference: "HOV01203490"),
    WorkerConversation(customerName: "John Smith", customerProfileImage: "reviewer_2", lastMessage: "What time will you arrive?", timestamp: "15m ago", unreadCount: 1, jobType: "Pipe Leak Fix", jobReference: "HOV01203491"),
    WorkerConversation(customerName: "Emily Davis", customerProfileImage: "reviewer_3", lastMessage: "The dog won't bother you, he's friendly 😊", timestamp: "1h ago", unreadCount: 0, jobType: "AC Service", jobReference: "HOV01203493"),
    WorkerConversation(customerName: "Michael Brown", customerProfileImage: "reviewer_1", lastMessage: "Thanks for the great work!", timestamp: "3h ago", unreadCount: 0, jobType: "Wall Painting", jobReference: "HOV01203489"),
    WorkerConversation(customerName: "Jessica Wilson", customerProfileImage: "reviewer_2", lastMessage: "Can you bring your own tools?", timestamp: "Yesterday", unreadCount: 0, jobType: "Furniture Assembly", jobReference: "HOV01203488"),
    WorkerConversation(customerName: "Robert Lane", customerProfileImage: nil, lastMessage: "Please confirm your arrival time.", timestamp: "2d ago", unreadCount: 0, jobType: "House Cleaning", jobReference: "HOV01203487")
]

// MARK: - View

struct WorkerMessagesView: View {

    let mainColor = Color.brandGreen
    @State private var searchText = ""

    var filteredConversations: [WorkerConversation] {
        if searchText.isEmpty { return mockConversations }
        return mockConversations.filter {
            $0.customerName.localizedCaseInsensitiveContains(searchText) ||
            $0.jobType.localizedCaseInsensitiveContains(searchText)
        }
    }

    var totalUnread: Int { mockConversations.reduce(0) { $0 + $1.unreadCount } }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // Header
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Messages")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        if totalUnread > 0 {
                            Text("\(totalUnread) unread")
                                .font(.caption)
                                .foregroundColor(mainColor)
                                .fontWeight(.semibold)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 12)

                // Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search conversations...", text: $searchText)
                        .font(.subheadline)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 16)

                // Conversation List
                if filteredConversations.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.25))
                        Text("No conversations found")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredConversations) { conversation in
                                NavigationLink(destination: WorkerChatView(conversation: conversation)) {
                                    WorkerConversationRow(conversation: conversation, mainColor: mainColor)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Divider()
                                    .padding(.leading, 80)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Conversation Row

private struct WorkerConversationRow: View {
    let conversation: WorkerConversation
    let mainColor: Color

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                if let imageNamed = conversation.customerProfileImage,
                   UIImage(named: imageNamed) != nil {
                    Image(imageNamed)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 54, height: 54)
                        .overlay(
                            Text(conversation.customerName.prefix(1))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        )
                }

                // Online indicator (decorative)
                Circle()
                    .fill(Color.brandGreen)
                    .frame(width: 13, height: 13)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 2, y: 2)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.customerName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(conversation.timestamp)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack {
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(conversation.unreadCount > 0 ? .primary : .gray)
                        .fontWeight(conversation.unreadCount > 0 ? .medium : .regular)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(mainColor)
                            .clipShape(Capsule())
                    }
                }

                Text(conversation.jobType)
                    .font(.caption)
                    .foregroundColor(mainColor)
                    .fontWeight(.medium)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(conversation.unreadCount > 0 ? mainColor.opacity(0.02) : Color.white)
    }
}

#Preview {
    WorkerMessagesView()
}
