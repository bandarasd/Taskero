//
//  WorkerChatView.swift
//  Taskero
//

import SwiftUI

// MARK: - Model

private struct WorkerChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSentByWorker: Bool
    let timestamp: String
}

// MARK: - View

struct WorkerChatView: View {

    let conversation: WorkerConversation
    let mainColor = Color.brandGreen

    @Environment(\.presentationMode) var presentationMode
    @State private var messageText = ""
    @State private var messages: [WorkerChatMessage] = [
        WorkerChatMessage(text: "Hi! I've confirmed your booking. I'll be there at the scheduled time.", isSentByWorker: true, timestamp: "10:00 AM"),
        WorkerChatMessage(text: "Perfect! The door code is 1234.", isSentByWorker: false, timestamp: "10:02 AM"),
        WorkerChatMessage(text: "Got it, thank you! Is there anything specific I should know before arriving?", isSentByWorker: true, timestamp: "10:05 AM"),
        WorkerChatMessage(text: "Great! I'll leave the key under the mat 🗝️", isSentByWorker: false, timestamp: "10:08 AM")
    ]

    var body: some View {
        VStack(spacing: 0) {

            // Header
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    // Avatar
                    if let img = conversation.customerProfileImage, UIImage(named: img) != nil {
                        Image(img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(conversation.customerName.prefix(1))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                            )
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversation.customerName)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(conversation.jobType)
                            .font(.caption)
                            .foregroundColor(mainColor)
                    }

                    Spacer()

                    // Call button
                    Button(action: {}) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(mainColor)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                // Job Reference Tag
                HStack {
                    Spacer()
                    Text("Job #\(conversation.jobReference)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(8)
                    Spacer()
                }
                .padding(.bottom, 8)

                Divider()
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)

            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            WorkerMessageBubble(message: message, mainColor: mainColor)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }
            .background(Color.gray.opacity(0.04))

            // Input Bar
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(mainColor)
                    }

                    TextField("Type a message...", text: $messageText)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(20)

                    Button(action: sendMessage) {
                        Image(systemName: messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(mainColor)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let now = formatter.string(from: Date())

        messages.append(WorkerChatMessage(text: trimmed, isSentByWorker: true, timestamp: now))
        messageText = ""
    }
}

// MARK: - Message Bubble

private struct WorkerMessageBubble: View {
    let message: WorkerChatMessage
    let mainColor: Color

    var body: some View {
        HStack {
            if message.isSentByWorker { Spacer(minLength: 60) }

            VStack(alignment: message.isSentByWorker ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(message.isSentByWorker ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(message.isSentByWorker ? mainColor : Color.white)
                    .cornerRadius(18, corners: message.isSentByWorker
                        ? [.topLeft, .topRight, .bottomLeft]
                        : [.topLeft, .topRight, .bottomRight])
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

                Text(message.timestamp)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }

            if !message.isSentByWorker { Spacer(minLength: 60) }
        }
    }
}

#Preview {
    WorkerChatView(conversation: WorkerConversation(
        customerName: "Sarah Connor",
        customerProfileImage: nil,
        lastMessage: "Great! I'll leave the key under the mat 🗝️",
        timestamp: "2m ago",
        unreadCount: 2,
        jobType: "Kitchen Cleaning",
        jobReference: "HOV01203490"
    ))
}
