import SwiftUI

struct Conversation: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var lastMessage: String {
        ConversationMessages.last?.text ?? "No messages yet"
    }
    var time: String
    var imageName: String
    var unreadCount: Int
    var ConversationMessages: [ChatMessage] // Now Swift knows how to hash this!
}
