//
//  ChatView.swift
//  Taskero
//

import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromMe: Bool
    let timestamp: Date
    var imageAttachment: String? = nil
}

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    let conversation: Conversation

    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi! I'll be there by 10 AM.", isFromMe: false, timestamp: Date().addingTimeInterval(-600)),
        ChatMessage(text: "Sure, thanks for confirming!", isFromMe: true, timestamp: Date().addingTimeInterval(-580)),
        ChatMessage(text: "Do you need me to bring any specific cleaning supplies?", isFromMe: false, timestamp: Date().addingTimeInterval(-500)),
        ChatMessage(text: "No, I have everything at home. Just bring your tools.", isFromMe: true, timestamp: Date().addingTimeInterval(-480)),
        ChatMessage(text: "Perfect! See you soon.", isFromMe: false, timestamp: Date().addingTimeInterval(-300))
    ]

    @FocusState private var textFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.black)
                }
                ZStack(alignment: .bottomTrailing) {
                    if let avatar = conversation.avatar, UIImage(named: avatar) != nil {
                        Image(avatar).resizable().scaledToFill()
                            .frame(width: 40, height: 40).clipShape(Circle())
                    } else {
                        Circle().fill(Color.brandGreen.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Text(String(conversation.name.prefix(1))).fontWeight(.bold).foregroundColor(.brandGreen))
                    }
                    if conversation.isOnline {
                        Circle().fill(Color.green).frame(width: 10, height: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(conversation.name).font(.subheadline).fontWeight(.bold)
                    Text(conversation.isOnline ? "Online" : "Offline")
                        .font(.caption)
                        .foregroundColor(conversation.isOnline ? .green : .gray)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "phone.fill")
                        .font(.title3).foregroundColor(.brandGreen)
                        .padding(8).background(Color.brandGreen.opacity(0.1)).clipShape(Circle())
                }
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title3).foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .padding(.top, 40)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)

            // Service context banner
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill").foregroundColor(.brandGreen).font(.caption)
                Text("Service: \(conversation.serviceTitle)")
                    .font(.caption).fontWeight(.medium).foregroundColor(.brandGreen)
                Spacer()
                NavigationLink(destination: BookingsView()) {
                    Text("View Order")
                        .font(.caption2).fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color.brandGreen)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(Color.brandGreen.opacity(0.07))

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.horizontal).padding(.vertical, 12)
                }
                .background(Color.gray.opacity(0.04))
                .onAppear {
                    if let last = messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            // Input Bar
            HStack(spacing: 10) {
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2).foregroundColor(.brandGreen)
                }
                HStack {
                    TextField("Type a message...", text: $messageText)
                        .focused($textFieldFocused)
                    if !messageText.isEmpty {
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.brandGreen)
                        }
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(22)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.gray.opacity(0.15), lineWidth: 1))
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 5, y: -3)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, isFromMe: true, timestamp: Date()))
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromMe { Spacer(minLength: 50) }
            VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 3) {
                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(message.isFromMe ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(message.isFromMe ? Color.brandGreen : Color.white)
                    .cornerRadius(18, corners: message.isFromMe
                        ? [.topLeft, .topRight, .bottomLeft]
                        : [.topLeft, .topRight, .bottomRight])
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
                Text(timeString(message.timestamp))
                    .font(.caption2).foregroundColor(.gray)
            }
            if !message.isFromMe { Spacer(minLength: 50) }
        }
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "h:mm a"
        return f.string(from: date)
    }
}

#Preview {
    ChatView(conversation: Conversation.mockList[0])
}
